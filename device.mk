# Copyright (C) 2016 The CyanogenMod Project
# Copyright (C) 2020 The OmniRom Project
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
# This file is the build configuration for a full Android
# build for grouper hardware. This cleanly combines a set of
# device-specific aspects (drivers) with a device-agnostic
# product configuration (apps).
#

# Inherit from common AOSP config
$(call inherit-product, $(SRC_TARGET_DIR)/product/base.mk)

# Enable project quotas and casefolding for emulated storage without sdcardfs
$(call inherit-product, $(SRC_TARGET_DIR)/product/emulated_storage.mk)

# Installs gsi keys into ramdisk, to boot a GSI with verified boot.
$(call inherit-product, $(SRC_TARGET_DIR)/product/gsi_keys.mk)

LOCAL_PATH := device/motorola/hanoip

# A/B support
AB_OTA_UPDATER := true

# VNDK
PRODUCT_TARGET_VNDK_VERSION := 30

# A/B
ENABLE_VIRTUAL_AB := true
$(call inherit-product, $(SRC_TARGET_DIR)/product/virtual_ab_ota.mk)

# A/B updater updatable partitions list. Keep in sync with the partition list
# with "_a" and "_b" variants in the device. Note that the vendor can add more
# more partitions to this list for the bootloader and radio.
AB_OTA_PARTITIONS += \
    boot \
    dtbo \
    product \
    system \
    system_ext \
    vbmeta \
    vbmeta_system \
    vendor \
    vendor_boot

PRODUCT_PACKAGES += \
    otapreopt_script \
    update_engine \
    update_engine_sideload \
    update_verifier

AB_OTA_POSTINSTALL_CONFIG += \
    RUN_POSTINSTALL_system=true \
    POSTINSTALL_PATH_system=system/bin/otapreopt_script \
    FILESYSTEM_TYPE_system=ext4 \
    POSTINSTALL_OPTIONAL_system=true

# API
PRODUCT_SHIPPING_API_LEVEL := 30

# tell update_engine to not change dynamic partition table during updates
# needed since our qti_dynamic_partitions does not include
# vendor and odm and we also dont want to AB update them
TARGET_ENFORCE_AB_OTA_PARTITION_LIST := true

# Boot control HAL
PRODUCT_PACKAGES += \
    android.hardware.boot@1.1-impl-qti.recovery \
    bootctrl.$(PRODUCT_PLATFORM).recovery \

# Dynamic partitions
PRODUCT_USE_DYNAMIC_PARTITIONS := true

# fastbootd
PRODUCT_PACKAGES += \
    android.hardware.fastboot@1.0-impl-mock \
    fastbootd

# qcom decryption
PRODUCT_PACKAGES += \
    qcom_decrypt \
    qcom_decrypt_fbe

# Soong namespaces
PRODUCT_SOONG_NAMESPACES += \
    $(LOCAL_PATH) \
    hardware/qcom-caf/bootctrl \
    vendor/qcom/opensource/commonsys-intf/display
    
    
# Copy modules for depmod
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/recovery/root/vendor/lib/modules/1.1/exfat.ko:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/lib/modules/1.1/exfat.ko \
    $(LOCAL_PATH)/recovery/root/vendor/lib/modules/1.1/fpc1020_mmi.ko:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/lib/modules/1.1/fpc1020_mmi.ko \
    $(LOCAL_PATH)/recovery/root/vendor/lib/modules/1.1/ilitek_v3_mmi.ko:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/lib/modules/1.1/ilitek_v3_mmi.ko \
    $(LOCAL_PATH)/recovery/root/vendor/lib/modules/1.1/mmi_annotate.ko:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/lib/modules/1.1/mmi_annotate.ko \
    $(LOCAL_PATH)/recovery/root/vendor/lib/modules/1.1/mmi_info.ko:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/lib/modules/1.1/mmi_info.ko \
    $(LOCAL_PATH)/recovery/root/vendor/lib/modules/1.1/mmi_sys_temp.ko:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/lib/modules/1.1/mmi_sys_temp.ko \
    $(LOCAL_PATH)/recovery/root/vendor/lib/modules/1.1/moto_f_usbnet.ko:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/lib/modules/1.1/moto_f_usbnet.ko \
    $(LOCAL_PATH)/recovery/root/vendor/lib/modules/1.1/mpq-adapter.ko:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/lib/modules/1.1/mpq-adapter.ko \
    $(LOCAL_PATH)/recovery/root/vendor/lib/modules/1.1/qpnp_adaptive_charge.ko:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/lib/modules/1.1/qpnp_adaptive_charge.ko \
    $(LOCAL_PATH)/recovery/root/vendor/lib/modules/1.1/sensors_class.ko:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/lib/modules/1.1/sensors_class.ko \
    $(LOCAL_PATH)/recovery/root/vendor/lib/modules/1.1/sx933x_sar.ko:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/lib/modules/1.1/sx933x_sar.ko \
    $(LOCAL_PATH)/recovery/root/vendor/lib/modules/1.1/utags.ko:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/lib/modules/1.1/utags.ko \



