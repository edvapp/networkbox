#!/bin/bash

# source helper functions
. ../helperfunctions.sh

# source configuration
. ../OPTIONS.conf

## manipulated file /etc/samba/smb.conf
file=/etc/samba/smb.conf
printAndLogMessage "SET FORWARDER IN ${file}"
printAndLogMessage "Manipulated file: " ${file}
printAndLogMessage "Save original file: " ${file}
saveOriginal ${file}
logFile ${file}

printAndLogMessage "Change file: " ${file}

## HINTS to understand sed:
## 1: we have to use " instead ' because of ${...} variable substitution
## 2: remove all quoting \ in s/.../.../ and you get a readable regex
sed -e "/dns/ s/\([[:digit:]]\{1,3\}\.\)\{3\}[[:digit:]]\{1,3\}/${SAMBA4_AD_DNS_FORWARDER_IP}/" -i ${file}

logFile ${file}

