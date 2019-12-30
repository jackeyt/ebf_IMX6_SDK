#!/bin/bash

PWD=$(pwd)

#Config Info
Config_file=${PWD}/configs/defconfig.mk
source ${Config_file} 2>/dev/null

#calls functions for files
. ${PWD}/scripts/building_env_check.sh
. ${PWD}/scripts/building_uboot_func.sh
. ${PWD}/scripts/building_kernel_func.sh
. ${PWD}/scripts/building_fs_func.sh
. ${PWD}/scripts/building_sdcard_img.sh

# version Info
SDK_NAME=EBF_IMX6_SDK
SDK_Release_Data=2019-11-30
SDK_VERSION=0.1
SDK_Author=jackeyt
SDK_site=https://jackeyt.cn



function VerInfo_print()
{
    figlet -f slant ${SDK_NAME}
    echo_green_n SDK_Release_Data:${SDK_Release_Data}
    echo_green_n SDK_VERSION:${SDK_VERSION}
	echo_green_n SDK_Author:${SDK_Author}
	echo_green_n SDK_site:${SDK_site}
}

function uboot_menu_print()
{
	echo_white [0] uboot_configure
	echo_white [1] uboot_build
	echo_white [2] uboot_clean
	echo_white [3] uboot_distclean
	echo_white [4] uboot_menuconfig
}

function uboot_menu_select()
{
	case  $1 in 
	0)
		echo_red_n Configuring Uboot...
		uboot_config
		uboot_main
		;;
    1)
        echo_red_n Building uboot for ebf_imx6ul starting...
		uboot_build
        ;;
    2)
        echo_red_n Cleaning Uboot...
		uboot_clean
        ;;
    3)
        echo_red_n Distleaning Uboot...
		uboot_distclean
        ;;
	4)
        echo_red_n menuconfig Uboot...
		uboot_menuconfig
		uboot_main
        ;;				
    *)
        echo_red_n "Please chose again!"
		uboot_main
        ;;
esac
}

function uboot_main()
{
	uboot_menu_print
	read -p "please select: " para1
	echo_red_n "your select is: " $para1
	uboot_menu_select $para1
}

function kernel_menu_print()
{
	echo_white [0] linux_configure
	echo_white [1] linux_distclean
	echo_white [2] linux_clean
	echo_white [3] linux_build_dts_only
	echo_white [4] linux_build_modules_only
	echo_white [5] linux_build_kernel
	echo_white [6] linux_build_all
	echo_white [7] linux_kernel_menuconfig
}

function kernel_menu_select()
{
	case  $1 in 
	0)
		echo_red_n Configuring kernel...
		kernel_config
		kernel_menu_print
		read -p "configured finish!please select to build: " para1
		echo_red_n "your select is: " $para1
		kernel_menu_select $para1
		;;
    1)
        echo_red_n "kernel distclean..."
		kernel_distclean
        ;;
    2)
        echo_red_n "Cleaning kernel..."
		kernel_clean
        ;;
    3)
        echo_red_n "Building dts only..."
		kernel_build_dtbs
        ;;	
	4)
        echo_red_n "Building modules only ..."
		kernel_build_modules
        ;;
	5)
        echo_red_n "Building kenrnel all types..."
		kernel_build
		kernel_build_dtbs
		kernel_build_modules
        ;;
	6)
        echo_red_n "Building dts only..."
		kernel_build
        ;;
	7)
        echo_red_n "menuconfig starting..."
		kernel_menuconfig
		kernel_menu_print
		read -p "menuconfig finish!please select to build: " para1
		echo_red_n "your select is: " $para1
		kernel_menu_select $para1
        ;;			
    *)
        echo_red_n "Please chose again!"
		kernel_main
        ;;
esac
}

function kernel_main()
{
	kernel_menu_print
	read -p "please select: " para1
	echo_red_n "your select is: " $para1
	kernel_menu_select $para1
}

function fs_main()
{
	fs_config
	fs_build
}

function sd_main()
{
	FlashALL2Image
}

#main
function main_menu_print()
{
	echo_white_n [0] Building Env check
	echo_white_n [1] Building uboot for ebf_imx6ul
	echo_white_n [2] Building linux kernel for ebf_imx6ul
	echo_white_n [3] Building filesystems for ebf_imx6ul
	echo_white_n [4] Building QT for ebf_imx6ul
	echo_white_n [5] Building 3th packages for ebf_imx6ul
	echo_white_n [6] Building APPs for ebf_imx6ul
	echo_white_n [7] Building QT APPs for ebf_imx6ul
	echo_white_n [8] Building and Burning image to sdcard
	echo_white_n [9] Exiting SDK Building Guide!
}

function main_menu_select()
{
	case  $1 in 
	0)
		echo_red_n Building Env check starting...
		BuildingEnvCheck
		;;
    1)
        echo_red_n Building uboot for ebf_imx6ul starting...
		uboot_main
        ;;
    2)
        echo_red_n Building kernel for ebf_imx6ul starting...
		kernel_main
        ;;
    3)
        echo_red_n Building filesystems for ebf_imx6ul starting...
		fs_main
        ;;
	4)
        echo_red_n Building QT for ebf_imx6ul starting...
        ;;
	5)
        echo_red_n Building 3th packages for ebf_imx6ul...
        ;;
	6)
        echo_red_n Building APPs for ebf_imx6ul starting...
        ;;
	7)
        echo_red_n Building QT APPs for ebf_imx6ul starting...
        ;;
	8)
        echo_red_n Building and Burning image to sdcard starting...
		sd_main
        ;;
	9)
        echo_red_n Exiting SDK Building Guide!
		exit 1
        ;;				
    *)
        echo_red_n "Please select the right  option's num:0~9"
		main_menu_print
		read -p "please select again: " para
		main_menu_select $para
        ;;
esac
}

function main()
{
    VerInfo_print
	main_menu_print
	read -p "please select: " para
	echo_red_n "your select is: " $para
	main_menu_select $para
}

main