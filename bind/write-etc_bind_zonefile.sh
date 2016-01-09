#!/bin/bash

# source helper functions
. ../helperfunctions.sh

# source configuration
. ../OPTIONS.conf

# file /etc/bind/db.DOMAIN_NAME
file=/etc/bind/db.$DOMAIN_NAME
printAndLogMessage "Manipulated file: " $file

if [ -f $file ];
then
	printAndLogMessage "File" $file "alread exists!"
	exit
fi

printAndLogMessage "Write file: " $file
echo ";
; BIND data file for domain $DOMAIN_NAME
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

$HOSTNAME	IN	A	$DNS_IP_LOCAL_NETWORK
dhcp01		IN	CNAME	$HOSTNAME

nfs01		IN	CNAME	$HOSTNAME
nfs02		IN	CNAME	$HOSTNAME
nfs03		IN	CNAME	$HOSTNAME

ldap01		IN	CNAME	$HOSTNAME

cups01		IN	CNAME	$HOSTNAME

laus01		IN	CNAME	$HOSTNAME
apca01		IN	CNAME	$HOSTNAME
tftp01		IN	CNAME	$HOSTNAME

owncloud01	IN	CNAME	$HOSTNAME

gateway		IN	A	$GATEWAY
" >> $file

logFile $file