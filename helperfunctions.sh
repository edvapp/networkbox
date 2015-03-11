#!/bin/bash

# save file with "filename" to "filename.original"

function saveOriginal()
{
	cp $1 $1.history.$(date +%Y%m%d-%N)
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
		cp $1.original $1
	fi
}

function getReverseNETAndIP()
{
	IP=$1
	NETMASK=$2
	if [ $NETMASK = "255.255.255.0" ];
	then
		REVERSE_NET=$(echo $IP | awk 'BEGIN { FS = "." } { print $3"."$2"."$1 }')
		REVERSE_IP=$(echo $IP | awk 'BEGIN { FS = "." } { print $4 }')
	elif [ $NETMASK = "255.255.0.0" ];
	then
		REVERSE_NET=$(echo $IP | awk 'BEGIN { FS = "." } { print $2"."$1 }')
		REVERSE_IP=$(echo $IP | awk 'BEGIN { FS = "." } { print $4"."$3 }')
	elif [ $NETMASK = "255.0.0.0" ];
	then
		REVERSE_NET=$(echo $IP | awk 'BEGIN { FS = "." } { print $1 }')
		REVERSE_IP=$(echo $IP | awk 'BEGIN { FS = "." } { print $4"."$3"."$2 }')
	fi
}

function getCIDRsubnetmask()
{
	NETMASK=$1
	if [ $NETMASK = "255.255.255.0" ];
	then
		CIDR_NETMASK=24
	elif [ $NETMASK = "255.255.0.0" ];
	then
		CIDR_NETMASK=16
	elif [ $NETMASK = "255.0.0.0" ];
	then
		CIDR_NETMASK=8
	fi
}


