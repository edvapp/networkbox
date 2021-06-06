#!/bin/bash

# source helper functions
. ../helperfunctions.sh

# source configuration
. ../SAMBA4.conf

## manipulated file /etc/krb5.conf 
file=/etc/krb5.conf 

printAndLogMessage "WRITE NEW CLEAN KERBEROS CONFIGURATION FILES"
printAndLogMessage "Save original file: " ${file}
saveOriginal ${file}
logFile ${file}

rm ${file}

printAndLogMessage "Write file: " ${file}

echo "
[logging]
        default = FILE:/var/log/krb5libs.log

[libdefaults]
         default_realm = ${SAMBA4_REALM_DOMAIN_NAME}
         dns_lookup_realm = true
         dns_lookup_kdc = true
         #ticket_lifetime = 24h
         #renew_lifetime = 7d
         rdns = false
         forwardable = yes

" > ${file}

logFile ${file}




