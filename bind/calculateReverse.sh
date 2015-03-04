#!/bin/bash

. ../OPTIONS.conf

# calculate reverse lookup - zone
if [ $DNS_NETMASK = "255.255.255.0" ];
then
	REVERSE_NET=$(echo $DNS_IP | awk 'BEGIN { FS = "." } { print $3"."$2"."$1 }')
	REVERSE_IP=$(echo $DNS_IP | awk 'BEGIN { FS = "." } { print $4 }')
elif [ $DNS_NETMASK = "255.255.0.0" ];
then
	REVERSE_NET=$(echo $DNS_IP | awk 'BEGIN { FS = "." } { print $2"."$1 }')
	REVERSE_IP=$(echo $DNS_IP | awk 'BEGIN { FS = "." } { print $4"."$3 }')
elif [ $DNS_NETMASK = "255.0.0.0" ];
then
	REVERSE_NET=$(echo $DNS_IP | awk 'BEGIN { FS = "." } { print $1 }')
	REVERSE_IP=$(echo $DNS_IP | awk 'BEGIN { FS = "." } { print $4"."$3"."$2 }')
fi
