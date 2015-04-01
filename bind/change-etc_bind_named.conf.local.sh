#!/bin/bash

# source helper functions
. ../helperfunctions.sh

# source configuration
. ../OPTIONS.conf

# manipulated file
file=/etc/bind/named.conf.local

# save original.conf.options
saveOriginal $file

# write zone files to /etc/bind/named.conf.local
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
