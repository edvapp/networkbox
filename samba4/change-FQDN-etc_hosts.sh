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
    /$(hostname)/ s/$(hostname)/$(hostname).${SAMBA4_DNS_DOMAIN_NAME} $(hostname)/
}" -i $file 

logFile $file
