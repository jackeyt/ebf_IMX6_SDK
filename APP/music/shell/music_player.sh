#!/bin/bash
export GPLAY=gplay-1.0

if [ `pwd | awk -F "/" '{print $NF}'` == "all_test" ];then
	res_path=$(dirname $(pwd))
else
	res_path=$(pwd)
fi

$GPLAY --repeat $res_path/resource/music.mp3
