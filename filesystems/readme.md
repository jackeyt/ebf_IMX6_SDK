

# 文件系统说明：

## qt5文件系统
NXP 官方提供的qt5测试文件系统

## ebf-sato 文件系统
野火在NXP官方sato文件系统上添加qt支持，包含python等内容

如：
core-image-sato-imx6ull14x14evk.ext4
core-image-sato-imx6ull14x14evk.manifest
core-image-sato-imx6ull14x14evk.tar.bz2

## ebf_rootfs
野火在ebf-sato文件系统基础上裁剪得到的文件系统，支持qt，野火出厂GUI界面，主要是为了适配NAND FLASH的小容量而裁剪的。

## debian文件系统
debian文件系统
- ebf_debian_fs_nand_emmc.bz2：支持烧录至nand和emmc
- ebf_debian_rootfs.tar.bz2：支持烧录至sd卡

## base 文件系统
sato 文件系统只包含终端，无法运行qt等图形界面

如：
core-image-base-imx6ull14x14evk.ext4
core-image-base-imx6ull14x14evk.manifest
core-image-base-imx6ull14x14evk.tar.bz2





