#!/bin/bash

# source helper functions
. ../helperfunctions.sh

# source configuration
. ../OPTIONS.conf

# source code for $REVERSE
#. ./calculateReverse.sh

getReverseNETAndIP $DNS_IP_LOCAL_NETWORK $NETMASK
# file /etc/bind/db.reversenet
file=/etc/bind/db.$REVERSE_NET
printAndLogMessage "Manipulated file: " $file

if [ -f $file ];
then
	printAndLogMessage "File" $file "alread exists!"
	exit
fi

printAndLogMessage "Write file: " $file
echo ";
; BIND reverse data file for domain $DOMAIN_NAME
;
\$TTL    604800
@   IN SOA   $HOSTNAME.$DOMAIN_NAME.    root  (
                              1         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
			IN	NS        $HOSTNAME.$DOMAIN_NAME.


$REVERSE_IP	IN	PTR	$HOSTNAME.$DOMAIN_NAME.
" >> $file

# add ip address of gateway 
getReverseNETAndIP $GATEWAY $NETMASK
echo "
$REVERSE_IP	IN	PTR	gateway.$DOMAIN_NAME.
" >> $file

logFile $file