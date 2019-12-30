#!/bin/bash


#calls functions for files
. ${SDK_PATH}/scripts/func_echo.sh


#kernel config
function kernel_config()
{
    echo_green_n Select kernel configs:
    echo_green "1:configs for LCD 4.3 inch"
    echo_green "2:configs for LCD 5.0 inch"
    echo_green "3:configs for LCD 7.0 inch"

    read -p "please select configs for kernel: " para
    echo_green $KERNEL_DIR
    case  $para in 
    1)
        echo_red_n "configs for LCD 4.3 inch"
        cp -fv $KERNEL_DIR/drivers/video/logo/logo_linux_clut224_4.3.ppm $KERNEL_DIR/drivers/video/logo/logo_linux_clut224.ppm
        ;;
    2)
        echo_red_n "configs for LCD 5.0 inch"
        cp -fv $KERNEL_DIR/drivers/video/logo/logo_linux_clut224_5.0.ppm $KERNEL_DIR/drivers/video/logo/logo_linux_clut224.ppm
        ;;
    3)
        echo_red_n "configs for SD LCD 7.0 inch"
        cp -fv $KERNEL_DIR/drivers/video/logo/logo_linux_clut224_5.0.ppm $KERNEL_DIR/drivers/video/logo/logo_linux_clut224.ppm
        ;;				
    *)
        echo_red_n "Please select again!"
        kernel_config
        ;;
esac
    if [ -z "$kernel_deconfig" ]; then
            echo_red_n "Please configure again!"
            kernel_config
    else
            pushd $KERNEL_DIR
            echo_exec "make ARCH=${ARCH} CROSS_COMPILE=${CROSS_COMPILE}  ${kernel_deconfig}"
            if [ $? -eq 0 ]; then
                echo_green_n "Configured $kernel_deconfig to kernel success!"
                popd
            else
                echo_red_n "Configured $kernel_deconfig to kernel failed!"
                popd
                exit 1
            
            fi
    fi
}

#kernel clean
function kernel_clean()
{
    pushd ${KERNEL_DIR}
	echo_exec "make ARCH=${ARCH} CROSS_COMPILE=${CROSS_COMPILE} clean"
    if [ $? -eq 0 ]; then
                echo_green_n "====Clean kernel ok!===="
        else
                echo_red_n "====Clean kernel failed!===="
                exit 1
        fi
	popd
}

#kernel distclean
function kernel_distclean()
{
	pushd ${KERNEL_DIR}
	echo_exec "make ARCH=${ARCH} CROSS_COMPILE=${CROSS_COMPILE} distclean"
    if [ $? -eq 0 ]; then
                echo_green_n "====distclean kernel ok!===="
        else
                echo_red_n "====distclean kernel failed!===="
                exit 1
        fi
	popd
}

#kernel build
function kernel_build()
{
	pushd ${KERNEL_DIR}
    echo_red_n "Using Confiugre file:$kernel_deconfig"
	echo_exec "make ARCH=${ARCH} CROSS_COMPILE=${CROSS_COMPILE}  -j${JOBS}"
    if [ $? -eq 0 ]; then
            echo_green_n "====Build kernel ok!===="
            cp -rafv arch/arm/boot/zImage $KERNEL_OUTPATH
        else
            echo_red_n "====Build kernel failed!===="
            exit 1
        fi
	popd
}

#kernel build dtbs
function kernel_build_dtbs()
{
	pushd ${KERNEL_DIR}
    echo_red_n "Using Confiugre file:$kernel_deconfig"
	echo_exec "make ARCH=${ARCH} CROSS_COMPILE=${CROSS_COMPILE}  -j${JOBS} dtbs"
    if [ $? -eq 0 ]; then
            echo_green_n "====Build dtbs ok!===="
            cp -rafv arch/arm/boot/dts/imx6ull-14x14-ev*.dtb $DTB_OUTPATH
        else
            echo_red_n "====Build dtbs failed!===="
            exit 1
        fi
	popd
}

#kernel build modules
function kernel_build_modules()
{
	pushd ${KERNEL_DIR}
    echo_red_n "Using Confiugre file:$kernel_deconfig"
	echo_exec "make ARCH=${ARCH} CROSS_COMPILE=${CROSS_COMPILE}  -j${JOBS} modules_install INSTALL_MOD_PATH=$MOD_OUTPATH"
    if [ $? -eq 0 ]; then
            echo_green_n "====Build modules finished in $MOD_OUTPATH!===="
        else
            echo_red_n "====Build modules failed!===="
            exit 1
        fi
	popd
}

#kernel menuconfig
function kernel_menuconfig()
{
	pushd ${KERNEL_DIR}
    echo_red_n "Using Confiugre file:$kernel_deconfig"
	echo_exec "make ARCH=${ARCH} CROSS_COMPILE=${CROSS_COMPILE}  menuconfig"
    if [ $? -eq 0 ]; then
            echo_green_n "====kernel_menuconfig finished !===="
        else
            echo_red_n "====kernel_menuconfig failed!===="
            exit 1
        fi
	popd
}