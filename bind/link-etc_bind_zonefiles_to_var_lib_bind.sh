#!/bin/bash

# source helper functions
. ../helperfunctions.sh

# source configuration
. ../OPTIONS.conf

getReverseNETAndIP $DNS_IP_LOCAL_NETWORK $NETMASK
cd /var/lib/bind
ln -s db.${DOMAIN_NAME}
ln -s db.${REVERSE_NET}
