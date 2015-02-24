#!/bin/bash

# source helper functions
. ../helperfunctions.sh

# source configuration
. ../OPTIONS.conf

# manipulated file
file=named.conf.local

# save original.conf.options
saveOriginal $file

# write zone files to /etc/bind/named.conf.local
echo ""							>> $file
echo "zone \"${DOMAIN_NAME}\" {"			>> $file
echo "     type master;"				>> $file
echo "     file \"/etc/bind/db.${DOMAIN_NAME}\";"	>> $file
echo "};"						>> $file

# source code for $REVERSE
. ./calculateReverse.sh
echo "zone \"${REVERSE}.in-addr.arpa\" {"		>> $file
echo "        type master;"				>> $file
echo "        file \"/etc/bind/db.${REVERSE}\";"	>> $file
echo "};"						>> $file
