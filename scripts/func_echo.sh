#!/bin/bash
#echo funs
function echo_green()
{
	echo -ne "\e[32m"
	echo -n $*
	echo -e "\e[0m"
}

function echo_red()
{
	echo -ne "\e[31m"
	echo -n $*
	echo -e "\e[0m"
}

function echo_white()
{
	echo -ne "\e[0m"
	echo -n $*
	echo -e "\e[0m"
}

function echo_green_n()
{
	echo -ne "\e[32m"
	echo -n $*
	echo -e "\r"
	echo -ne "\e[0m"
	echo 
}

function echo_red_n()
{
	echo -ne "\e[31m"
	echo -n $*
	echo -e "\r"
	echo -ne "\e[0m"
}

function echo_white_n()
{
	echo -ne "\e[0m"
	echo -n $*
	echo -e "\r"
	echo -ne "\e[0m"
}

function notice_pause_g()
{
	echo_green_n $*
	echo_green_n " press ENTER to continue!"
	read
}

function notice_pause_r()
{
	echo_red_n $*
	echo_red_n " press ENTER to continue!"
	read
}

function notice_pause_w()
{
	echo_white_n $*
	echo_white_n " press ENTER to continue!"
	read
}

function echo_exec()
{
	echo_white_n $*
	$*
}