#!/bin/bash


#calls functions for files
. ${SDK_PATH}/scripts/func_echo.sh

# boot.src build
function boot_src_buuild()
{
	${uboot_dir}/tools/mkimage -A arm -T script -O linux -d ${boot_script} ${boot_scr}
}


#uboot config
function uboot_config()
{
    echo_green_n Select uboot configs:
    echo_green "1:configs for nand"
    echo_green "2:configs for emmc"
    echo_green "3:configs for SD Card"

    read -p "please select configs for uboot: " para

    case  $para in 
    1)
        echo_red_n "configs for nand"
		uboot_deconfig=mx6ull_14x14_evk_nand_defconfig
        ;;
    2)
        echo_red_n "configs for emmc"
		uboot_deconfig=mx6ull_14x14_evk_emmc_defconfig
        ;;
    3)
        echo_red_n "configs for SD Card"
        uboot_deconfig=mx6ull_14x14_evk_defconfig
        ;;				
    *)
        echo "Please select again!"
        uboot_config
        ;;
esac
    if [ -z "$uboot_deconfig" ]; then
            echo_red_n "Please configure again!"
            uboot_config
    else
            pushd $UBOOT_DIR
            echo_exec "make ARCH=${ARCH} CROSS_COMPILE=${CROSS_COMPILE}  ${uboot_deconfig}"
            if [ $? -eq 0 ]; then
                echo_green_n "Configured $uboot_deconfig to uboot success!"
                popd
            else
                echo_red_n "Configured $uboot_deconfig to uboot failed!"
                popd
                exit 1
            
            fi
    fi
}

#uboot clean
function uboot_clean()
{
    pushd ${UBOOT_DIR}
	echo_exec "make ARCH=${ARCH} CROSS_COMPILE=${CROSS_COMPILE} clean"
    if [ $? -eq 0 ]; then
                echo_green_n "====Clean uboot ok!===="
        else
                echo_red_n "====Clean uboot failed!===="
                exit 1
        fi
	popd
}

#uboot distclean
function uboot_distclean()
{
	pushd ${UBOOT_DIR}
	echo_exec "make ARCH=${ARCH} CROSS_COMPILE=${CROSS_COMPILE} distclean"
    if [ $? -eq 0 ]; then
                echo_green_n "====distclean uboot ok!===="
        else
                echo_red_n "====distclean uboot failed!===="
                exit 1
        fi
	popd
}

#uboot build
function uboot_build()
{
	pushd ${UBOOT_DIR}
    echo_red_n "Using Confiugre file:$uboot_deconfig"
	echo_exec "make ARCH=${ARCH} CROSS_COMPILE=${CROSS_COMPILE}  -j${JOBS}"
    if [ $? -eq 0 ]; then
            echo_green_n "====Build uboot ok!===="
            cp -vf ./u-boot.imx ${OUT_UBOOT}
        else
            echo_red_n "====Build uboot failed!===="
            exit 1
        fi
	popd
}

#uboot build
function uboot_menuconfig()
{
	pushd ${UBOOT_DIR}
    echo_red_n "Using Confiugre file:$uboot_deconfig"
	echo_exec "make ARCH=${ARCH} CROSS_COMPILE=${CROSS_COMPILE}  menuconfig"
    if [ $? -eq 0 ]; then
            echo_green_n "====menuconfig uboot ok!===="
        else
            echo_red_n "====menuconfig uboot failed!===="
            exit 1
        fi
	popd
}


