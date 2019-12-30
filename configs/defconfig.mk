#!/bin/bash

#path config
export SDK_PATH=$(pwd)
UBOOT_DIR=$SDK_PATH/uboot/ebf_6ull_uboot
KERNEL_DIR=$SDK_PATH/kernel/ebf_6ull_linux/
KERNEL_MODULES_DIR=$KERNEL_DIR/modules
OUT_DIR=$SDK_PATH/output

DTB_OUTPATH=$OUT_DIR/dtbs
MOD_OUTPATH=$OUT_DIR/modules
PKG_OUTPATH=$OUT_DIR/packages
APP_OUTPATH=$OUT_DIR/APPs
IMAGE_PATH=$OUT_DIR/images
KERNEL_OUTPATH=$OUT_DIR/kernel
UBOOT_OUTPATH=$OUT_DIR/uboot
ROOTFS_OUTPATH=$OUT_DIR/rootfs

#out kernel dtbs uboot files
OUT_UBOOT=$UBOOT_OUTPATH/u-boot.imx
OUT_KERNEL=$KERNEL_OUTPATH/zImage
OUT_DTB=$DTB_OUTPATH/imx6ull-14x14-evk.dtb

FS_DIR=$SDK_PATH/filesystems
FS_MOUNT_DIR=$SDK_PATH/temp_rootfs
BASE_FS_DIR=$FS_DIR/base_fs
DEBIAN9_FS_DIR=$FS_DIR/debian9
DEBIAN10_FS_DIR=$FS_DIR/debian10
EBF_FS_DIR=$FS_DIR/ebf_rootfs
EBF-SATO_FS_DIR=$FS_DIR/ebf_sato
QT5_FS_DIR=$FS_DIR/qt5_fs
UBUNTU16_FS_DIR=$FS_DIR/ubuntu_core/ubuntu16.04
UBUNTU18_FS_DIR=$FS_DIR/ubuntu_core/ubuntu18.04
TEMP_ROOTFS_DIR=$FS_DIR/temp_rootfs

#build config
export ARCH=arm
export CROSS_COMPILE=arm-linux-gnueabihf-
JOBS=8

#uboot build config
uboot_deconfig=mx6ull_14x14_evk_nand_defconfig
uboot_verbose=2
boot_script=${UBOOT_DIR}/../boot.script.SDCARD
boot_scr=${UBOOT_DIR}/../boot.scr

#kernel build config
kernel_deconfig=imx6_v7_ebf_defconfig
kernel_verbose=2

#fs build config
#1:base_fs
#2:debian 9 Stretch
#3:debian 10 Buster
#4:ebf_rootfs
#5:ebf sato
#6:qt5 fs
#7:ubuntu 16.04 core
#8:ubuntu 18.04 core
fs_deconfig=1

#output image
SD_IMG_NAME=EBF_SDCard_Image_forIMX6
EMMC_IMG_NAME=EBF_EMMC_Image_forIMX6
NAND_IMG_NAME=EBF_NAND_Image_forIMX6

SD_IMG_PATH=$IMAGE_PATH/sd
EMMC_IMG_PATH=$IMAGE_PATH/emmc
NAND_IMG_PATH=$IMAGE_PATH/nand

#config parti
SD_IMG_STARTSIZE=10	#M
SD_IMG_FATSIZE=64	#M
SD_IMG_EXTSIZE=400	#M
