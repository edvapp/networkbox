#!/bin/bash

. ../OPTIONS.conf

# calculate reverse lookup - zone
if [ $STATIC_NETMASK = 255.255.255.0.0 ];
then
	echo "ss"
	REVERSE=$(echo $IP | awk 'BEGIN { FS = "." } { print $3"."$2"."$1 }')
elif [ $STATIC_NETMASK = 255.255.0.0 ];
then
	REVERSE=$(echo $IP | awk 'BEGIN { FS = "." } { print $2"."$1 }')
elif [ $STATIC_NETMASK = 255.0.0.0 ];
then
	REVERSE=$(echo $IP | awk 'BEGIN { FS = "." } { print $1 }')
fi

