#!/bin/bash

#calls functions for files
. ${SDK_PATH}/scripts/func_echo.sh
TIMESTAMP=`date +%Y%m%d%H%m%S`
BOOT_IMG=${SD_IMG_PATH}/boot.img
ROOTFS_IMG=${SD_IMG_PATH}/rootfs.img
OUTPUT_IMG=$SD_IMG_PATH/ebf-imx6ull-${TIMESTAMP}.img


function BurnSdcardImg()
{
    echo_green "Prepare to Burn SDcard Image!"
    read -p "please enter your sd partition,such as:/dev/sda " para1
	

}

function Build_Burn_toSdcard()
{
    echo_green_n "packing $fs_deconfig"

}

function BurnUboot2img()
{
    dd if=$1 of=$2 bs=1024 seek=1 conv=fsync,notrunc
}

function BuildRootfs_img()
{
    rm -f ${ROOTFS_IMG}
    rm -rf tmpfs
    #echo_exec "sudo make_ext4fs -s -l ${SD_IMG_EXTSIZE}M -a root  -L rootfs $ROOTFS_IMG $TEMP_ROOTFS_DIR"
    sudo mkdir -p tmpfs
    dd if=/dev/zero of=${ROOTFS_IMG} bs=1M count=$SD_IMG_EXTSIZE conv=fsync,notrunc
    mkfs.ext4 ${ROOTFS_IMG}
    echo_exec "sudo mount -t ext4 ${ROOTFS_IMG} tmpfs -o loop"
    echo_exec "sudo cp -rafp $TEMP_ROOTFS_DIR/*  tmpfs"
    echo_exec "sudo sync"
    echo_exec "sudo umount tmpfs"
    echo_exec "sudo rm -rf tmpfs"
}

function MakeImg_Partition()
{
sfdisk --force $1 << EOF
${SD_IMG_STARTSIZE}M,${SD_IMG_FATSIZE}M,c
$(expr ${SD_IMG_STARTSIZE} + ${SD_IMG_FATSIZE})M,,83
write
EOF
}


# Generate the boot image with the boot scripts and required Device Tree
function generate_boot_image() 
{ 
    FATSIZE="-F 32"
    BOOTDD_VOLUME_ID=BOOT

    rm -f ${BOOT_IMG}
	echo_exec "mkfs.vfat -n "${BOOTDD_VOLUME_ID}" -S 512 ${FATSIZE} -C ${BOOT_IMG} $(expr ${SD_IMG_FATSIZE} \* 1024)"
    
    echo "mtools_skip_check=1" > ~/.mtoolsrc
    
    # Copy boot scripts
	echo_exec "mcopy -i ${BOOT_IMG} -s ${UBOOT_OUTPATH}/boot.scr ::/boot.scr"

    # Copy zImage
	echo_exec "mcopy -i ${BOOT_IMG} -s ${OUT_KERNEL} ::/zImage"

	# Copy dtb
    echo_exec "mcopy -i ${BOOT_IMG} -s ${OUT_DTB} ::/imx6ull-14x14-evk.dtb"
}


function generate_total_image () 
{
	# Initialize a sparse file
	dd if=/dev/zero of=${OUTPUT_IMG} bs=1M count=$(expr ${SD_IMG_STARTSIZE} \+ ${SD_IMG_FATSIZE} \+ ${SD_IMG_EXTSIZE})
}

#            10MiB               64MiB           SD_IMG_EXTSIZE                  
# <--------------------> <-------------> <----------------------> 
#  ------------------------ ------------ ------------------------
# | SD_IMG_STARTSIZE   | SD_IMG_FATSIZE | SD_IMG_EXTSIZE         |     
#  ------------------------ ------------ ------------------------ 
# ^                    ^                ^                        ^                               
# |                    |                |                        |                              
# 0                   10MB              74MB                 74MB + SD_IMG_EXTSIZE  
function FlashALL2Image () 
{
    #1.generate boot image file
    echo_green_n "building boot Image:$BOOT_IMG"
    generate_boot_image
    #2.generate total image file
    generate_total_image
    #3.Build Partition
    echo_green_n "Partiting SD Image:$OUTPUT_IMG"
    MakeImg_Partition $OUTPUT_IMG
    #4.0 Burn uboot
    echo_green_n "burning uboot to $OUTPUT_IMG"
    BurnUboot2img ${OUT_UBOOT} ${OUTPUT_IMG}
	#4.1 Burn Partition fat32
    echo_green_n "burning $BOOT_IMG to $OUTPUT_IMG"
	dd if=${BOOT_IMG} of=${OUTPUT_IMG} conv=notrunc,fsync bs=1M seek=${SD_IMG_STARTSIZE}
	#4.2 Burn Partition ext4
    BuildRootfs_img
    echo_green_n "burning $ROOTFS_IMG to $OUTPUT_IMG"
    echo_exec "dd if=${ROOTFS_IMG} of=${OUTPUT_IMG} conv=notrunc,fsync bs=1M seek=$(expr ${SD_IMG_STARTSIZE} \+ ${SD_IMG_FATSIZE})"
	rm -f ${ROOTFS_IMG} #save disk space
    if [ $? -eq 0 ]; 
        then
            echo_green_n "package SD Image:$OUTPUT_IMG success!"
        else
            echo_red_n "package SD Image:$OUTPUT_IMG failed!"
            exit 1   
    fi
}

function BuildSdcardImg()
{
    echo_green_n "building SDcard Image!"

}