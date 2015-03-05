#!/bin/bash

# source helper functions
. ../helperfunctions.sh

# source configuration
. ../OPTIONS.conf

# source code for $REVERSE
#. ./calculateReverse.sh

getReverseNETAndIP $DNS_IP $DNS_NETMASK
# file /etc/bind/db.reversenet
file=/etc/bind/db.$REVERSE_NET

if [ -f $file ];
then
	echo "file" $file "alread exists!"
	exit
fi

echo ";
; BIND reverse data file for domain $DNS_DOMAIN_NAME
;
\$TTL    604800
@   IN SOA   $DNS_HOSTNAME.$DNS_DOMAIN_NAME.    root  (
                              1         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
			IN	NS        $DNS_HOSTNAME.$DNS_DOMAIN_NAME.


$REVERSE_IP	IN	PTR	$DNS_HOSTNAME.$DNS_DOMAIN_NAME.
" >> $file
# add ip address of gateway 
getReverseNETAndIP $DNS_GATEWAY $DNS_NETMASK
echo "
$REVERSE_IP	IN	PTR	gateway.$DNS_DOMAIN_NAME.
" >> $file