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
zone \"${DOMAIN_NAME}\" {
     type master;
     file \"/etc/bind/db.${DOMAIN_NAME}\";
};


zone \"${REVERSE_NET}.in-addr.arpa\" {
        type master;
        file \"/etc/bind/db.${REVERSE_NET}\";
};
" >> $file

logFile $file