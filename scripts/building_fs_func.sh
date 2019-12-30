#!/bin/bash


#calls functions for files
. ${SDK_PATH}/scripts/func_echo.sh

function fs_mount()
{
    sudo mount --bind /dev $TEMP_ROOTFS_DIR/dev/
    sudo mount --bind /sys $TEMP_ROOTFS_DIR/sys/
    sudo mount --bind /proc $TEMP_ROOTFS_DIR/proc/
    sudo mount --bind /dev/pts $TEMP_ROOTFS_DIR/dev/pts/
}

function fs_unmount()
{
    sudo umount $TEMP_ROOTFS_DIR/sys/
    sudo umount $TEMP_ROOTFS_DIR/proc/
    sudo umount $TEMP_ROOTFS_DIR/dev/pts/
    sudo umount $TEMP_ROOTFS_DIR/dev/
}

#fs readme
function fs_readme()
{   
    echo_green "readme:"
    echo_green "1:base_fs:"
    echo_green "2:debian 9 Stretch:"
    echo_green "3:debian 10 Buster:"
    echo_green "4:ebf_rootfs:"
    echo_green "5:ebf_sato:"
    echo_green "6:qt5 fs:"
    echo_green "7:ubuntu 16.04 core:"
    echo_green "8:ubuntu 18.04 core:"
    fs_config
}

#fs config
function fs_config()
{
    echo_green_n Select which type fs you want to build:
    echo_green "0:readme"
    echo_green "1:base_fs"
    echo_green "2:debian 9 Stretch"
    echo_green "3:debian 10 Buster"
    echo_green "4:ebf_rootfs"
    echo_green "5:ebf sato"
    echo_green "6:qt5 fs"
    echo_green "7:ubuntu 16.04 core"
    echo_green "8:ubuntu 18.04 core"

    read -p "please select configs for filesystem: " para
    echo_green $FS_DIR
    case  $para in
    0)
        echo_red_n "readme for filesystems"
        fs_readme
        ;; 
    1)
        echo_red_n "configs base_fs"
        fs_deconfig=1
        ;;
    2)
        echo_red_n "configs debian 9 Stretch"
        fs_deconfig=2
        ;;
    3)
        echo_red_n "configs debian 10 Buster"
        fs_deconfig=3
        ;;
    4)
        echo_red_n "configs ebf_rootfs"
        fs_deconfig=4
        ;;
    5)
        echo_red_n "configs ebf sato"
        fs_deconfig=5
        ;;
    6)
        echo_red_n "configs qt5 fs"
        fs_deconfig=6
        ;;
    7)
        echo_red_n "configs ubuntu 16.04"
        fs_deconfig=7
        ;;
    8)
        echo_red_n "configs ubuntu 18.04"
        fs_deconfig=8
        ;;
			
    *)
        echo_red_n "Please select again!"
        fs_config
        ;;
esac
    if [ -z "$fs_deconfig" ]; then
        echo_red_n "Please configure again!"
        fs_config
    fi
}

#base_fs build
function base_fs_build()
{
    echo_green_n "base_fs build start!"
}

#sourcelist & install pkgs
function update_deb()
{
    #chroot
    sudo LC_ALL=C LANGUAGE=C LANG=C chroot $TEMP_ROOTFS_DIR <<EOF
    echo "proc /proc proc defaults 0 0" >> /etc/fstab
    echo "nameserver 127.0.0.53" > /etc/resolv.conf
    mknod /dev/console c 5 1
    ln -s /lib/systemd/system/getty@.service /etc/systemd/system/getty.target.wants/getty@ttymxc0.service
    mkdir -p /run/sshd
    echo auto eth0 > /etc/network/interfaces.d/eth0
    echo iface eth0 inet dhcp >> /etc/network/interfaces.d/eth0
    echo "ebf_imx6ull" > /etc/hostname
    echo "127.0.0.1 localhost" >> /etc/hosts
    echo "127.0.1.1 ebf_imx6ull" >> /etc/hosts
    apt update
    apt install -y sudo net-tools vim net-tools ethtool  ifupdown iputils-ping openssh-server
    apt-get clean
    useradd -s '/bin/bash' -m -G adm,sudo fire
    echo "fire:fire" |chpasswd
    echo "root:fire" |chpasswd
    exit
EOF
}

#debian build
debian_build()
{
    ISSUE=buster

    case  $1 in 
	9)
		echo_green_n "debian9 build start!"
        ISSUE=stretch
		;;
    10)
        echo_green_n "debian10 build start!"
        ISSUE=buster
        ;;			
    *)
        echo_green_n "debian10 build start!"
        ISSUE=buster
        ;;
esac
    
    if [ "`ls -A $TEMP_ROOTFS_DIR`" = "" ]; then
        echo_green_n "$TEMP_ROOTFS_DIR is  empty!"
    else
        echo_red_n "$TEMP_ROOTFS_DIR is not empty"
        sudo rm -Rf $TEMP_ROOTFS_DIR/*
    fi

    sudo debootstrap --foreign --verbose --arch=armhf  $ISSUE $TEMP_ROOTFS_DIR http://ftp2.cn.debian.org/debian
    if [ $? -eq 0 ]; then
        echo_green_n "download $ISSUE success!"
    else
        echo_red_n "download $ISSUE failed!"
        exit 1    
    fi
    #change
    fs_mount
    sudo mkdir -p $TEMP_ROOTFS_DIR/usr/share/man/man1/
    sudo cp -f /usr/bin/qemu-arm-static $TEMP_ROOTFS_DIR/usr/bin
    if [ $TEMP_ROOTFS_DIR -eq 'stretch' ]; then
        echo_exec "sudo cp -f $DEBIAN9_FS_DIR/sources.list  $TEMP_ROOTFS_DIR/etc/apt/"
    else
        echo_exec "sudo cp -f $DEBIAN10_FS_DIR/sources.list $TEMP_ROOTFS_DIR/etc/apt/"
    fi
    #first chroot
    sudo DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true LC_ALL=C LANGUAGE=C LANG=C chroot $TEMP_ROOTFS_DIR debootstrap/debootstrap --second-stage
    #update
    update_deb
    fs_unmount
}

#ebf_rootfs build
function ebf_rootfs_build()
{
    echo_green_n "ebf_rootfs build start!"
}

#ebf_sato build
function ebf_sato_build()
{
    echo_green_n "ebf_sato build start!"
}

#qt5 fs build
function qt5_fs_build()
{
    echo_green_n "qt5 fs build start!"
}

#ubuntu build
function ubuntu_build()
{
    ISSUE=bionic
    echo_green_n "building ubuntu start!"
    if [ "`ls -A $TEMP_ROOTFS_DIR`" = "" ]; then
        echo_green_n "$TEMP_ROOTFS_DIR is  empty!"
    else
        echo_red_n "$TEMP_ROOTFS_DIR is not empty"
        sudo rm -Rf $TEMP_ROOTFS_DIR/*
    fi

    case  $1 in 
	xenial)
		echo_green_n "ubuntu16 build start!"
        ISSUE=xenial
        pushd ${UBUNTU16_FS_DIR}
        if [ ! -f ubuntu-base-16.04.6-base-armhf.tar.gz ];then
            wget https://mirrors.tuna.tsinghua.edu.cn/ubuntu-cdimage/ubuntu-base/releases/16.04/release/ubuntu-base-16.04.6-base-armhf.tar.gz
            if [ $? -eq 0 ]; then
                    echo_green_n "download ubuntu-base-16.04.6-base-armhf.tar.gz success!"
            else
                    echo_red_n "download ubuntu-base-16.04.6-base-armhf.tar.gz failed!"
                    exit 1
            fi
	    fi
        echo_exec "sudo tar xzf ubuntu-base-16.04.6-base-armhf.tar.gz -C $TEMP_ROOTFS_DIR"
        if [ $? -eq 0 ]; then
            echo_green_n "unpacked ubuntu-base-16.04 success!"
            else
                echo_red_n "unpacked ubuntu-base-16.04 failed!"
                exit 1
        fi
        popd
        echo_exec "sudo cp -f $UBUNTU16_FS_DIR/sources.list  $TEMP_ROOTFS_DIR/etc/apt/"
        echo_exec "sudo cp -f $UBUNTU16_FS_DIR/resolv.conf  $TEMP_ROOTFS_DIR/etc/apt/"
		;;
    bionic)
        echo_green_n "ubuntu18 build start!"
        ISSUE=bionic
        pushd ${UBUNTU18_FS_DIR}
        if [ ! -f ubuntu-base-18.04-base-armhf.tar.gz ];then
            wget https://mirrors.tuna.tsinghua.edu.cn/ubuntu-cdimage/ubuntu-base/releases/18.04/release/ubuntu-base-18.04-base-armhf.tar.gz
            if [ $? -eq 0 ]; then
                    echo_green_n "download ubuntu-base-18.04-base-armhf.tar.gz success!"
            else
                    echo_red_n "download ubuntu-base-18.04-base-armhf.tar.gz failed!"
                    exit 1
            fi
	    fi
        echo_exec "sudo tar xzf ubuntu-base-18.04-base-armhf.tar.gz -C $TEMP_ROOTFS_DIR"
        if [ $? -eq 0 ]; then
            echo_green_n "unpacked ubuntu-base-18.04 success!"
        else
            echo_red_n "unpacked ubuntu-base-18.04 failed!"
            exit 1
        fi
	    popd
        echo_exec "sudo cp -f $UBUNTU18_FS_DIR/sources.list  $TEMP_ROOTFS_DIR/etc/apt/"
        echo_exec "sudo cp -f $UBUNTU18_FS_DIR/resolv.conf  $TEMP_ROOTFS_DIR/etc/apt/"
        ;;			
    *)
        echo_green_n "debian10 build start!"
        ISSUE=bionic
        ;;
esac

    fs_mount
    sudo mkdir -p $TEMP_ROOTFS_DIR/usr/share/man/man1/
    sudo cp -f /usr/bin/qemu-arm-static $TEMP_ROOTFS_DIR/usr/bin
    update_deb
    fs_unmount
}

function packing_fs()
{
    TIMESTAMP=`date +%Y%m%d%H%m%S`

    pushd $FS_DIR
    sudo tar cjf  $1-${TIMESTAMP}.tar.gz temp_rootfs/
    sudo mv -f $1-${TIMESTAMP}.tar.gz $ROOTFS_OUTPATH
    pushd
}
function fs_build()
{
    case  $fs_deconfig in
    1)
        base_fs_build
        ;; 
	2)
        debian_build 9
        packing_fs debian9
        echo_green_n "build and packed debian9 finish!"
        ;;
    3)
        debian_build 10
        packing_fs debian10
        echo_green_n "build and packed debian10 finish!"
        ;;
    4)
        ebf_rootfs_build
        ;;
    5)
        ebf_sato_build
        ;;
    6)
        qt5_fs_build
        ;;
    7)
        ubuntu_build xenial
        packing_fs ubuntu16
        echo_green_n "build and packed ubuntu16 finish!"
        ;;
    8)
        ubuntu_build bionic
        packing_fs ubuntu18
        echo_green_n "build and packed ubuntu18 finish!"
        ;;    
    *)
        echo_red_n "Please select again!"
        fs_config
        ;;
esac
}
