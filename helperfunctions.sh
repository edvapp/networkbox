#!/bin/bash

# save file with "filename" to "filename.original"

function saveOriginal()
{
	cp $1 $1.history.$(date +%Y%m%d-%N )
	if ! [ -f $1.original ];
	then
		cp $1 $1.original
	fi
}

function restoreOriginal()
{
	if  [ -f $1.original ];
	then
		rm $1
		rm $.history.*
		cp $1.original $1
	fi
}

function getReverseNETAndIP()
{
	_IP=$1
	_NETMASK=$2
	if [ $_NETMASK = "255.255.255.0" ];
	then
		REVERSE_NET=$(echo $_IP | awk 'BEGIN { FS = "." } { print $3"."$2"."$1 }')
		REVERSE_IP=$(echo $_IP | awk 'BEGIN { FS = "." } { print $4 }')
	elif [ $_NETMASK = "255.255.0.0" ];
	then
		REVERSE_NET=$(echo $_IP | awk 'BEGIN { FS = "." } { print $2"."$1 }')
		REVERSE_IP=$(echo $_IP | awk 'BEGIN { FS = "." } { print $4"."$3 }')
	elif [ $_NETMASK = "255.0.0.0" ];
	then
		REVERSE_NET=$(echo $_IP | awk 'BEGIN { FS = "." } { print $1 }')
		REVERSE_IP=$(echo $I_P | awk 'BEGIN { FS = "." } { print $4"."$3"."$2 }')
	fi
}

function getCIDRsubnetmask()
{
	_NETMASK=$1
	if [ $_NETMASK = "255.255.255.0" ];
	then
		CIDR_SUB_NETMASK=24
	elif [ $_NETMASK = "255.255.0.0" ];
	then
		CIDR_SUB_NETMASK=16
	elif [ $_NETMASK = "255.0.0.0" ];
	then
		CIDR_SUB_NETMASK=8
	fi
}


