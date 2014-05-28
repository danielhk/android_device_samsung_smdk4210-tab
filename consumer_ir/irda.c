/*
 * Copyright (C) 2013 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 * Kitkat CONSUMER_IR hal driver for Samsung devices
 *	by:daniel.p6800@gmail.com
 */
#include <errno.h>

#define  LOG_TAG  "irda_hal"
#include <cutils/log.h>
#include <cutils/sockets.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <string.h>
#include <hardware/hardware.h>
#include <hardware/consumerir.h>

#define   IRDA_DEBUG   1

#define ARRAY_SIZE(a) (sizeof(a) / sizeof(a[0]))

static const consumerir_freq_range_t irda_freqs[] = {
    {.min = 30000, .max = 30000},
    {.min = 33000, .max = 33000},
    {.min = 36000, .max = 36000},
    {.min = 38000, .max = 38000},
    {.min = 40000, .max = 40000},
    {.min = 56000, .max = 56000},
};

int fd = 0;

static int irda_transmit(struct consumerir_device *dev,
   int carrier_freq, int pattern[], int pattern_len)
{
    int i, strlen, cmdstart, ret;
    char irbuf[1024];

    cmdstart = pattern[0];
    // add the frequency
    strlen = sprintf(irbuf, "%d", carrier_freq);

    for (i = 0; i < pattern_len; i++) {
	if ((i > 0) && (cmdstart == pattern[i]))
	    break;
        strlen += sprintf(irbuf + strlen, ",%d", pattern[i]);
    }

    ret = write(fd, (char *)irbuf, strlen);
    if (ret > 0)
	return errno;
    else
	return 0;
}

static int irda_get_num_carrier_freqs(struct consumerir_device *dev)
{
    return ARRAY_SIZE(irda_freqs);
}

static int irda_get_carrier_freqs(struct consumerir_device *dev,
    size_t len, consumerir_freq_range_t *ranges)
{
    size_t to_copy = ARRAY_SIZE(irda_freqs);

    to_copy = len < to_copy ? len : to_copy;
    memcpy(ranges, irda_freqs, to_copy * sizeof(consumerir_freq_range_t));
    return to_copy;
}

static int irda_close(hw_device_t *dev)
{
    free(dev);
    close(fd);
    return 0;
}

static int irda_open(const struct hw_module_t* module, char const* name,
        struct hw_device_t** device)
{
    if (strcmp(name, CONSUMERIR_TRANSMITTER) != 0) {
        return -EINVAL;
    }

    if (device == NULL) {
        ALOGE("NULL device on open");
        return -EINVAL;
    }

    consumerir_device_t *dev = malloc(sizeof(consumerir_device_t));
    memset(dev, 0, sizeof(*dev));

    dev->common.tag = HARDWARE_DEVICE_TAG;
    dev->common.version = 0;
    dev->common.module = (struct hw_module_t*)module;
    dev->common.close = irda_close;
    dev->transmit = irda_transmit;
    dev->get_num_carrier_freqs = irda_get_num_carrier_freqs;
    dev->get_carrier_freqs = irda_get_carrier_freqs;

    *device = (struct hw_device_t*) dev;

    fd = open("/sys/class/sec/sec_ir/ir_send", O_RDWR);

    return 0;
}

static struct hw_module_methods_t irda_module_methods = {
    .open = irda_open
};

consumerir_module_t HAL_MODULE_INFO_SYM = {
    .common = {
	.tag 		    = HARDWARE_MODULE_TAG,
	.module_api_version = CONSUMERIR_MODULE_API_VERSION_1_0,
	.hal_api_version    = HARDWARE_HAL_API_VERSION,
	.id 		    = CONSUMERIR_HARDWARE_MODULE_ID,
	.name 		    = "Irda HW Module",
	.author 	    = "The CyanogenMod Project",
	.methods 	    = &irda_module_methods,
    },
};
