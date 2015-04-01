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
@   IN SOA    $HOSTNAME   root  (
                              1         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
		IN		NS        $HOSTNAME

$HOSTNAME	IN	A	$DNS_IP
dhcp01		IN	CNAME	$HOSTNAME

nfs01		IN	CNAME	$HOSTNAME
nfs02		IN	CNAME	$HOSTNAME
nfs03		IN	CNAME	$HOSTNAME

ldap01		IN	CNAME	$HOSTNAME

cups01		IN	CNAME	$HOSTNAME

laus01		IN	CNAME	$HOSTNAME
apca01		IN	CNAME	$HOSTNAME
tftp01		IN	CNAME	$HOSTNAME

gateway		IN	A	$DNS_GATEWAY
" >> $file