#!/bin/bash

# source helper functions
. ../helperfunctions.sh

# source configuration
. ../OPTIONS.conf

# source code for $REVERSE
. ./calculateReverse.sh

# file /etc/bind/db.DOMAIN_NAME
file=db.$REVERSE".in-addr.arpa"

if [ -f $file ];
then
	echo "file" $file "alread exists!"
	exit
fi

echo ";"								>> $file
echo "; BIND reverse data file for domain" $DOMAIN_NAME			>> $file
echo ";"								>> $file
echo "\$TTL    604800"							>> $file
echo "@   IN SOA   " $NAME_DNS"."$DOMAIN_NAME".    root  ("		>> $file
echo "                              1         ; Serial"			>> $file
echo "                         604800         ; Refresh"		>> $file
echo "                          86400         ; Retry"			>> $file
echo "                        2419200         ; Expire"			>> $file
echo "                         604800 )       ; Negative Cache TTL" 	>> $file
echo ";"								>> $file
echo "		IN		NS        "$NAME_DNS"."$DOMAIN_NAME"."	>> $file

echo ""									>> $file

echo $REVERSE"		IN	A	"$NAME_DNS"."$DOMAIN_NAME"."	>> $file
echo ""									>> $file
