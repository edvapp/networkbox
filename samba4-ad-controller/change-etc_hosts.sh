#!/bin/bash

# source helper functions
. ../helperfunctions.sh

# source configuration
. ../OPTIONS.conf


printAndLogMessage "SET FQDN IN /etc/hosts" 
## manipulated file /etc/hosts
file="/etc/hosts"

printAndLogMessage "Manipulated file: " $file
printAndLogMessage "Save original file: " $file
saveOriginal $file
logFile $file

printAndLogMessage "Change file: " $file
# block host entrance, if one exists
sed -e "{
    /$(hostname)/ s/^/#/
}" -i $file 

# write host entrance with our LDAP suffixes
echo "${SAMBA4_STATIC_IP} $(hostname).${SAMBA4_DNS_DOMAIN_NAME} $(hostname)" >> $file

logFile $file

