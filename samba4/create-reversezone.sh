#!/bin/bash

# source helper functions
. ../helperfunctions.sh

# source configuration
. ../OPTIONS.conf

## we get reverse network-IP in: REVERSE_NET Example: 10 for 10.0.0.0/255.0.0.0
## and own reverse IP in:        REVERSE_IP Example: 19.0.0.10 for 10.0.0.19 
getReverseNETAndIP $DNS_IP_LOCAL_NETWORK $NETMASK

printAndLogMessage "we create reverse zone ${REVERSE_NET}.in-addr.arpa"
samba-tool dns zonecreate $(hostname) ${REVERSE_NET}.in-addr.arpa -UAdministrator --password=${SAMBA4_ADMINISTRATOR_PASSWORD}

printAndLogMessage "we add $(hostname) to ${REVERSE_NET}.in-addr.arpa"
samba-tool dns add $(hostname) ${REVERSE_NET}.in-addr.arpa ${REVERSE_IP} PTR $(hostname).brg.tsn -UAdministrator --password=${SAMBA4_ADMINISTRATOR_PASSWORD}

