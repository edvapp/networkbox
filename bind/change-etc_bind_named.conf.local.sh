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
echo ""							>> $file
echo "zone \"${DNS_DOMAIN_NAME}\" {"			>> $file
echo "     type master;"				>> $file
echo "     file \"/etc/bind/db.${DNS_DOMAIN_NAME}\";"	>> $file
echo "};"						>> $file
echo ""							>> $file
# source code for $REVERSE
getReverseNETAndIP $DNS_IP $DNS_NETMASK
echo "zone \"${REVERSE_NET}.in-addr.arpa\" {"		>> $file
echo "        type master;"				>> $file
echo "        file \"/etc/bind/db.${REVERSE_NET}\";"	>> $file
echo "};"						>> $file
