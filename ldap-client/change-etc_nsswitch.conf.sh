#! /bin/bash

# source helper functions
. ../helperfunctions.sh

# source configuration
. ../OPTIONS.conf


file=/etc/nsswitch.conf
printAndLogMessage "Manipulated file: " $file

logFile $file

printAndLogMessage "Write new: " $file
# Set Right Parameters in /etc/nsswitch.conf
# passwd:         files ldap
# group:          files ldap
# shadow:         files ldap

printAndLogMessage "auth-client-config -t nss -p lac_ldap"
auth-client-config -t nss -p lac_ldap

logFile $file
