#!/bin/bash

#calls functions for files
. ${SDK_PATH}/scripts/func_echo.sh

function hasCommandByType(){
    if type $1 2>/dev/null; 
    then
        return 1
    else
        return 0
    fi
}

#sudo apt-get install figlet build-essential libncurses5 libncurses5-dev  lzop u-boot-tools fakeroot gawk
#sudo apt-get install lib32ncurses5 lib32tinfo5 libc6-i386 qemu-user-static debootstrap binfmt-support
function BuildingEnvCheck()
{
    echo_green_n 
    echo_green "checking packages..."
    sudo apt-get update
    sudo apt install -y figlet build-essential libncurses5 libncurses5-dev  lzop u-boot-tools fakeroot gawk
    sudo apt install -y lib32ncurses5 lib32tinfo5 libc6-i386 qemu-user-static debootstrap binfmt-support
    sudo apt install -y figlet android-tools-fsutils
    echo_green "checking CROSS_COMPILE:${CROSS_COMPILE}gcc"
    hasCommandByType ${CROSS_COMPILE}gcc
    returnVue=$?
    if [ $returnVue == 0 ];then
        echo_red_n "尚未安装${CROSS_COMPILE}gcc"
        sudo apt install -y gcc-arm-linux-gnueabihf
    fi
    if [ $? -eq 0 ]; 
        then
            echo_green_n "checking packages success!"
        else
            echo_red_n "checking packages failed!"
            exit 1   
    fi
}