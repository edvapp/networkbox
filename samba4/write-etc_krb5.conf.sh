#!/bin/bash

# source helper functions
. ../helperfunctions.sh

# source configuration
. ../OPTIONS.conf

## manipulated file /etc/krb5.conf 
file=/etc/krb5.conf 

printAndLogMessage "WRITE NEW CLEAN KERBEROS CONFIGURATION FILES"
printAndLogMessage "Save original file: " ${file}
saveOriginal ${file}
logFile ${file}

rm ${file}

printAndLogMessage "Write file: " ${file}

echo "
[libdefaults]
	default_realm = ${SAMBA4_REALM_DOMAIN_NAME}
	dns_lookup_realm = false
	dns_lookup_kdc = true

" > ${file}

logFile ${file}




