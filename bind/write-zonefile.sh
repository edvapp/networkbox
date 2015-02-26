#!/bin/bash

# source helper functions
. ../helperfunctions.sh

# source configuration
. ../OPTIONS.conf

# file /etc/bind/db.DOMAIN_NAME
file=/etc/bind/db.$DOMAIN_NAME

if [ -f $file ];
then
	echo "file" $file "alread exists!"
	exit
fi

echo ";"								>> $file
echo "; BIND data file for domain" $DNS_DOMAIN_NAME			>> $file
echo ";"								>> $file
echo "\$TTL    604800"							>> $file
echo "@   IN SOA   " $DNS_HOSTNAME "  root  ("				>> $file
echo "                              1         ; Serial"			>> $file
echo "                         604800         ; Refresh"		>> $file
echo "                          86400         ; Retry"			>> $file
echo "                        2419200         ; Expire"			>> $file
echo "                         604800 )       ; Negative Cache TTL" 	>> $file
echo ";"								>> $file
echo "		IN		NS        "$DNS_HOSTNAME		>> $file
echo ""									>> $file
echo $DNS_HOSTNAME"		IN	A	"$DNS_IP		>> $file
echo "dhcp01		IN	CNAME	"$DNS_HOSTNAME			>> $file
echo ""									>> $file
echo "nfs01		IN	CNAME	"$DNS_HOSTNAME			>> $file
echo "nfs02		IN	CNAME	"$DNS_HOSTNAME			>> $file
echo "nfs03		IN	CNAME	"$DNS_HOSTNAME			>> $file
echo ""									>> $file
echo "ldap01		IN	CNAME	"$DNS_HOSTNAME			>> $file
echo ""									>> $file
echo "cups01		IN	CNAME	"$DNS_HOSTNAME			>> $file
echo ""									>> $file
echo "laus01		IN	CNAME	"$DNS_HOSTNAME			>> $file
echo "apca01		IN	CNAME	"$DNS_HOSTNAME			>> $file
echo "tftp01		IN	CNAME	"$DNS_HOSTNAME			>> $file
echo ""									>> $file
echo "gateway		IN	A	"$DNS_GATEWAY			>> $file
 