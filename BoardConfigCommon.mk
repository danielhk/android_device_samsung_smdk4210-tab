#
# Copyright (C) 2012 The CyanogenMod Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

TARGET_ARCH := arm
TARGET_CPU_ABI := armeabi-v7a
TARGET_CPU_ABI2 := armeabi
TARGET_CPU_SMP := true
TARGET_CPU_VARIANT := cortex-a9
TARGET_ARCH_VARIANT := armv7-a-neon
TARGET_ARCH_VARIANT_FPU := neon
ARCH_ARM_HAVE_TLS_REGISTER := true
ARCH_ARM_HAVE_NEON := true

BOARD_VENDOR := samsung
TARGET_BOARD_PLATFORM := exynos4
TARGET_FAMILY := smdk4210-tab
TARGET_SOC := exynos4210
TARGET_BOOTLOADER_BOARD_NAME := smdk4210
TARGET_BOARD_INFO_FILE := device/samsung/smdk4210-tab/board-info.txt

EXYNOS4_ENHANCEMENTS := true
EXYNOS4210_ENHANCEMENTS := true
COMMON_GLOBAL_CFLAGS += -DEXYNOS4_ENHANCEMENTS
COMMON_GLOBAL_CFLAGS += -DEXYNOS4210_ENHANCEMENTS
COMMON_GLOBAL_CFLAGS += -DEXYNOS4210_TABLET
COMMON_GLOBAL_CFLAGS += -DDISABLE_HW_ID_MATCH_CHECK

TARGET_NO_BOOTLOADER := true
TARGET_NO_RADIOIMAGE := true

DEVICE_PACKAGE_OVERLAYS += device/samsung/smdk4210-tab/overlay
TARGET_SPECIFIC_HEADER_PATH += device/samsung/smdk4210-tab/overlay/include

# Init
TARGET_PROVIDES_INIT := true
TARGET_PROVIDES_INIT_TARGET_RC := true

# Kernel
TARGET_KERNEL_SOURCE := kernel/samsung/smdk4210
TARGET_KERNEL_MODULES := CLEAN_MODULES
BOARD_KERNEL_BASE := 0x40000000
BOARD_KERNEL_PAGESIZE := 4096
BOARD_KERNEL_CMDLINE := "console=ttySAC2,115200 consoleblank=0"
CLEAN_MODULES:
	arm-eabi-strip --strip-debug `find $(KERNEL_MODULES_OUT) -name *.ko`

# Filesystem
BOARD_NAND_PAGE_SIZE := 4096
BOARD_NAND_SPARE_SIZE := 128
#BOARD_BOOTIMAGE_PARTITION_SIZE := 8388608
BOARD_SYSTEMIMAGE_PARTITION_SIZE := 872415232
#BOARD_USERDATAIMAGE_PARTITION_SIZE := 14138998784
BOARD_FLASH_BLOCK_SIZE := 1024
TARGET_USERIMAGES_USE_EXT4 := true

# Vold
BOARD_VOLD_MAX_PARTITIONS := 12
BOARD_VOLD_EMMC_SHARES_DEV_MAJOR := true
BOARD_VOLD_DISC_HAS_MULTIPLE_MAJORS := true
TARGET_USE_CUSTOM_LUN_FILE_PATH := "/sys/devices/platform/s3c-usbgadget/gadget/lun%d/file"

# Hardware tunables
BOARD_HARDWARE_CLASS := hardware/samsung/cmhw

# Graphics
BOARD_EGL_CFG := device/samsung/smdk4210-tab/configs/egl.cfg
BOARD_USE_MHEAP_SCREENSHOT := true
USE_OPENGL_RENDERER := true
BOARD_EGL_WORKAROUND_BUG_10194508 := true

# Enable WEBGL in WebKit
ENABLE_WEBGL := true

# Boot Animation
TARGET_BOOTANIMATION_PRELOAD := true
TARGET_BOOTANIMATION_TEXTURE_CACHE := true

# HWComposer
BOARD_USES_HWCOMPOSER := true
BOARD_USE_SYSFS_VSYNC_NOTIFICATION := true

# FIMG Acceleration
BOARD_USES_FIMGAPI := true
BOARD_USES_SKIA_FIMGAPI := true

# TVOut
BOARD_USE_SECTVOUT := true
BOARD_USES_SKTEXTBOX := true

# OMX
BOARD_USE_SAMSUNG_COLORFORMAT := true
BOARD_NONBLOCK_MODE_PROCESS := true
BOARD_USE_STOREMETADATA := true
BOARD_USE_METADATABUFFERTYPE := true
BOARD_USES_MFC_FPS := true

# Audio
BOARD_USES_GENERIC_AUDIO := false
BOARD_USE_TINYALSA_AUDIO := true
BOARD_USE_YAMAHA_MC1N2_AUDIO := true

# RIL
#BOARD_RIL_NO_CELLINFOLIST := true
BOARD_PROVIDES_LIBRIL := true
BOARD_MODEM_TYPE := xmm6260

# Camera
BOARD_USES_PROPRIETARY_LIBCAMERA := true
BOARD_USES_PROPRIETARY_LIBFIMC := true
BOARD_CAMERA_HAVE_ISO := true
COMMON_GLOBAL_CFLAGS += -DHAVE_ISO
COMMON_GLOBAL_CFLAGS += -DSAMSUNG_CAMERA_HARDWARE

# Bluetooth
BOARD_HAVE_BLUETOOTH := true
BOARD_HAVE_BLUETOOTH_CSR := true

# Wifi
BOARD_WLAN_DEVICE		:= ath6kl
BOARD_SOFTAP_DEVICE		:= ath6kl
WPA_SUPPLICANT_VERSION		:= VER_0_8_X
BOARD_WPA_SUPPLICANT_DRIVER	:= NL80211
BOARD_WPA_SUPPLICANT_PRIVATE_LIB := lib_driver_cmd_ath6kl
BOARD_HOSTAPD_DRIVER		:= NL80211
BOARD_HOSTAPD_PRIVATE_LIB	:= lib_driver_cmd_ath6kl
WIFI_DRIVER_MODULE_PATH		:= "/system/lib/modules/ath6kl.ko"
WIFI_DRIVER_MODULE_NAME		:= "ath6kl"
WIFI_DRIVER_LOADER_DELAY	:= 1000000
BOARD_HAVE_SAMSUNG_WIFI		:= true
# no firmware
WIFI_FIRMWARE_LOADER		:= ""
WIFI_DRIVER_FW_PATH_STA 	:= ""
WIFI_DRIVER_FW_PATH_AP 		:= ""
WIFI_DRIVER_FW_PATH_P2P 	:= ""
WIFI_DRIVER_FW_PATH_PARAM 	:= ""
CONFIG_P2P			:= true
CONFIG_P2P_MANAGER		:= true
CONFIG_DRIVER_NL80211		:= true
CONFIG_CTRL_IFACE		:= true
CONFIG_AP			:= true
CONFIG_WPS			:= true
CONFIG_IEEE80211N		:= true
CONFIG_IEEE80211AC		:= true
#USES_TI_MAC80211		:= true

# Sepolicy
BOARD_SEPOLICY_DIRS += \
    device/samsung/smdk4210-tab/sepolicy

BOARD_SEPOLICY_UNION += \
    device.te \
    domain.te \
    drmserver.te \
    file.te \
    file_contexts \
    rild.te \
    ueventd.te \
    vold.te \
    wpa_supplicant.te

# Charging Mode (LPM)
BOARD_CHARGING_MODE_BOOTING_LPM := "/sys/class/power_supply/battery/batt_lp_charging"
BOARD_BATTERY_DEVICE_NAME := "battery"
#BOARD_CHARGER_RES := "device/samsung/smdk4210-tab/charger_res/images"

# Override healthd HAL
BOARD_HAL_STATIC_LIBRARIES := libhealthd.exynos4

# Recovery
BOARD_CUSTOM_GRAPHICS := ../../../device/samsung/smdk4210-tab/recovery/graphics.c
BOARD_UMS_LUNFILE := "/sys/class/android_usb/android0/f_mass_storage/lun0/file"
TARGET_RECOVERY_PIXEL_FORMAT := "BGRA_8888"
BOARD_USE_CUSTOM_RECOVERY_FONT := \"roboto_15x24.h\"
BOARD_USES_MMCUTILS := true
BOARD_HAS_NO_MISC_PARTITION := true
BOARD_HAS_NO_SELECT_BUTTON := true
# Many shipped smdk4210 devices have defective eMMC chips (VYL00M fwrev 0x19)
# Prevent usage of ERASE commands in recovery on these boards.
# This is redundant for our recovery since the kernel has MMC_CAP_ERASE
# disabled for mshci.c, however it makes nightly ZIPs safer to flash
# from kernels that still have MMC_CAP_ERASE enabled.
BOARD_SUPPRESS_EMMC_WIPE := true

TARGET_RECOVERY_FSTAB := device/samsung/smdk4210-tab/rootdir/fstab.smdk4210
RECOVERY_FSTAB_VERSION := 2 

# for TWRP
ifeq ($(TARGET_SCREEN_HEIGHT),800) 
# 7.7
DEVICE_RESOLUTION := 1280x800
else
# 7.0
DEVICE_RESOLUTION := 1024x600
endif
BOARD_HAS_NO_REAL_SDCARD := true
RECOVERY_SDCARD_ON_DATA := true
TW_EXTERNAL_STORAGE_PATH := "/external_sd"
TW_EXTERNAL_STORAGE_MOUNT_POINT := "external_sd"

# Releasetools
# TODO: use standard BOOTIMG_MK
BOARD_CUSTOM_BOOTIMG_MK := device/samsung/smdk4210-tab/bootimg.mk
TARGET_RELEASETOOL_OTA_FROM_TARGET_SCRIPT := ./device/samsung/smdk4210-tab/releasetools/ota_from_target_files
TARGET_RELEASETOOL_IMG_FROM_TARGET_SCRIPT := ./device/samsung/smdk4210-tab/releasetools/img_from_target_files

