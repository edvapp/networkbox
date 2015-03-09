#!/bin/bash

# source helper functions
. ../helperfunctions.sh

# source configuration
. ../OPTIONS.conf

# file /etc/bind/db.DOMAIN_NAME
file=/etc/bind/db.$DNS_DOMAIN_NAME

if [ -f $file ];
then
	echo "file" $file "alread exists!"
	exit
fi

echo ";
; BIND data file for domain $DNS_DOMAIN_NAME
;
\$TTL    604800
@   IN SOA    $DNS_HOSTNAME   root  (
                              1         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
		IN		NS        $DNS_HOSTNAME

$DNS_HOSTNAME		IN	A	$DNS_IP
dhcp01		IN	CNAME	$DNS_HOSTNAME

nfs01		IN	CNAME	$DNS_HOSTNAME
nfs02		IN	CNAME	$DNS_HOSTNAME
nfs03		IN	CNAME	$DNS_HOSTNAME

ldap01		IN	CNAME	$DNS_HOSTNAME

cups01		IN	CNAME	$DNS_HOSTNAME

laus01		IN	CNAME	$DNS_HOSTNAME
apca01		IN	CNAME	$DNS_HOSTNAME
tftp01		IN	CNAME	$DNS_HOSTNAME

gateway		IN	A	$DNS_GATEWAY
" >> $file