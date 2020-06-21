#!/bin/bash

# source helper functions
. ../../helperfunctions.sh

# source configuration
. ../../OPTIONS.conf

## test processes
echo "TESTING PROCESSES"
ps ax | grep samba

## test name resolving
echo "TESTING DNS LOOKUP"
host ${HOSTNAME}
host -t SRV _kerberos._tcp.${SAMBA4_DNS_DOMAIN_NAME}
host -t SRV _ldap._tcp.${SAMBA4_DNS_DOMAIN_NAME}
host -t SRV _gc._tcp.${SAMBA4_DNS_DOMAIN_NAME}


