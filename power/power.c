/*
 * Copyright (C) 2012 The Android Open Source Project
 * by: daniel_hk (https://github.com/danielhk) 7/29/2016
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
 */
#include <errno.h>
#include <string.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>

#define LOG_TAG "Exynos4 PowerHAL"
#include <utils/Log.h>

#include <hardware/hardware.h>
#include <hardware/power.h>

#define DOUBLE_TAP_TO_WAKE_PATH "/sys/android_touch/doubletap_wake"

/**********************************************************
 *** HELPER FUNCTIONS
 **********************************************************/

static int sysfs_read(char *path, char *s, int num_bytes)
{
    char errno_str[64];
    int len;
    int ret = 0;
    int fd;

    fd = open(path, O_RDONLY);
    if (fd < 0) {
        strerror_r(errno, errno_str, sizeof(errno_str));
        ALOGE("Error opening %s: %s\n", path, errno_str);

        return -1;
    }

    len = read(fd, s, num_bytes - 1);
    if (len < 0) {
        strerror_r(errno, errno_str, sizeof(errno_str));
        ALOGE("Error reading from %s: %s\n", path, errno_str);

        ret = -1;
    } else {
        s[len] = '\0';
    }

    close(fd);

    return ret;
}

static void sysfs_write(const char *path, char *s)
{
    char errno_str[64];
    int len;
    int fd;

    fd = open(path, O_WRONLY);
    if (fd < 0) {
        strerror_r(errno, errno_str, sizeof(errno_str));
        ALOGE("Error opening %s: %s\n", path, errno_str);
        return;
    }

    len = write(fd, s, strlen(s));
    if (len < 0) {
        strerror_r(errno, errno_str, sizeof(errno_str));
        ALOGE("Error writing to %s: %s\n", path, errno_str);
    }

    close(fd);
}

static void power_init(__attribute__((unused)) struct power_module *module)
{
}

static void power_set_interactive(__attribute__((unused)) struct power_module *module,
				  __attribute__((unused)) int on)
{
}

static void power_hint(__attribute__((unused)) struct power_module *module, power_hint_t hint,
                       __attribute__((unused)) void *data) {
    switch (hint) {
    default:
        break;
    }
}

static void exynos4_set_feature(__attribute__((unused)) struct power_module *module, feature_t feature,
				__attribute__((unused)) int state)
{
    switch (feature) {
#ifdef DOUBLE_TAP_TO_WAKE_PATH
        case POWER_FEATURE_DOUBLE_TAP_TO_WAKE:
            ALOGV("%s: %s double tap to wake", __func__, state ? "enabling" : "disabling");
            sysfs_write(DOUBLE_TAP_TO_WAKE_PATH, state > 0 ? "1\n" : "0\n");
            break;
#endif
        default:
            ALOGW("Error setting the feature, it doesn't exist %d\n", feature);
            break;
    }
}

static struct hw_module_methods_t power_module_methods = {
    .open = NULL,
};

struct power_module HAL_MODULE_INFO_SYM = {
    .common = {
        .tag = HARDWARE_MODULE_TAG,
        .module_api_version = POWER_MODULE_API_VERSION_0_2,
        .hal_api_version = HARDWARE_HAL_API_VERSION,
        .id = POWER_HARDWARE_MODULE_ID,
        .name = "Exynos4 Power HAL",
        .author = "daniel_hk (https://github.com/danielhk)",
        .methods = &power_module_methods,
    },

    .init = power_init,
    .setInteractive = power_set_interactive,
    .powerHint = power_hint,
    .setFeature = exynos4_set_feature,
};
