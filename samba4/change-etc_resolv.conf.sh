#!/bin/bash

# source helper functions
. ../helperfunctions.sh

# source configuration
. ../SAMBA4.conf


printAndLogMessage "STOP AND DISABLE systemd-resolved"
## manipulated file /etc/resolv.conf
file=/etc/resolv.conf
printAndLogMessage "Manipulated file: " ${file}
printAndLogMessage "Save original file: " ${file}
saveOriginal ${file}
logFile ${file}

systemctl stop systemd-resolved
systemctl disable systemd-resolved
rm ${file}

printAndLogMessage "SET AD - DC IP AS NAMESERVER IN NEW ${file}"
echo "nameserver ${SAMBA4_AD_DNS_STATIC_IP}
search ${SAMBA4_DNS_DOMAIN_NAME}
"> ${file}
logFile ${file}

printAndLogMessage "RESTART NETPLAN"
netplan apply

