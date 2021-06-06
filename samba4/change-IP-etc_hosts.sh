#!/bin/bash

# source helper functions
. ../helperfunctions.sh

# source configuration
. ../SAMBA4.conf


printAndLogMessage "SET STATIC IP IN /etc/hosts" 
## manipulated file /etc/hosts
file="/etc/hosts"

printAndLogMessage "Manipulated file: " $file
printAndLogMessage "Save original file: " $file
saveOriginal $file
logFile $file

printAndLogMessage "Change file: " $file
# set 127.0.1.1 to STATIC IP
sed -e "{
    /$(hostname)/ s/127.0.1.1/${SAMBA4_STATIC_IP}/
}" -i $file 

logFile $file

