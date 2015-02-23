#!/bin/bash

# source helper functions
. ../helperfunctions.sh

# source configuration
. ../OPTIONS.conf

# manipulated file
file=named.conf.local

# save original.conf.options
saveOriginal $file

# calculate reverse lookup - zone
if [ $NETMASK=255.255.255.0 ];
then
	echo "255.255.255.0"
	REVERSE=$(echo $IP | awk 'BEGIN { FS = "." } { print $3"."$2"."$1 }')
fi


# write zone files to /etc/bind/named.conf.local
echo ""							>> $file
echo "zone \"${DOMAIN_NAME}\" {"			>> $file
echo "     type master;"				>> $file
echo "     file \"/etc/bind/db.${DOMAIN_NAME}\";"	>> $file
echo "};"						>> $file

echo "zone \"${REVERSE}.in-addr.arpa\" {"		>> $file
echo "        type master;"				>> $file
echo "        file \"/etc/bind/db.${REVERSE}\";"	>> $file
echo "};"						>> $file
