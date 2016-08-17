#!/bin/bash

# source helper functions
. ../helperfunctions.sh

# source configuration
. ../OPTIONS.conf

# manipulated file
file=/etc/bind/named.conf.local
printAndLogMessage "Manipulated file: " $file

# save original.conf.options
printAndLogMessage "Save original file: " $file
saveOriginal $file
logFile $file

printAndLogMessage "write zone files to: " $file
getReverseNETAndIP $DNS_IP_LOCAL_NETWORK $NETMASK
echo "
include "/etc/bind/rndc.key";

zone \"${DOMAIN_NAME}\" {
	type master;
	file \"/var/lib/bind/db.${DOMAIN_NAME}\";
	allow-update { key rndc-key; };
};


zone \"${REVERSE_NET}.in-addr.arpa\" {
	type master;
	file \"/var/lib/bind/db.${REVERSE_NET}\";
	allow-update { key rndc-key; };
};
" >> $file

logFile $file