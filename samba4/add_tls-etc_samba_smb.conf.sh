#!/bin/bash

# source helper functions
. ../helperfunctions.sh

# source configuration
. ../OPTIONS.conf


if [ ! ${ENABLE_SSL} == "yes" ];
then
        printAndLogMessage "SSL/TLS will not be enabled"
        exit
fi

## extract certifikate from pkcs12 file, which has to be placed in 
## /var/lib/samba/private/tls

KEYSTORE_FILE=$(ls /var/lib/samba/private/tls/*.p12)

file="/var/lib/samba/private/tls/cert.pem"
printAndLogMessage "Save original file: " ${file}
saveOriginal ${file}
logFile ${file}

openssl pkcs12 -in ${KEYSTORE_FILE} -out ${file} -nodes -nokeys

file="/var/lib/samba/private/tls/key.pem"
printAndLogMessage "Save original file: " ${file}
saveOriginal ${file}
logFile ${file}

openssl pkcs12 -in ${KEYSTORE_FILE} -out key.pem -nodes -nocerts

## manipulated file /etc/samba/smb.conf
file=/etc/samba/smb.conf
if grep -q "tls enabled" ${file};
then
        printAndLogMessage "SSL/TLS already enabled, we do nothing!"
        exit
fi

printAndLogMessage "WRITE NEW ${file}"
printAndLogMessage "Manipulated file: " ${file}

printAndLogMessage  "STOP samba-ad-dc"
systemctl stop samba-ad-dc

printAndLogMessage "Save original file: " ${file}
saveOriginal ${file}
logFile ${file}

printAndLogMessage "Change file: " ${file}

sed -e '/idmap_ldb*/a  \ \ttls enabled = yes \n \ttls keyfile = tls/key.pem \n \ttls certfile = tls/cert.pem \n \ttls cafile  =' -i ${file}

logFile ${file}

printAndLogMessage  "START samba-ad-dc"
systemctl start samba-ad-dc






