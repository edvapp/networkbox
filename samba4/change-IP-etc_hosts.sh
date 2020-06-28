#!/bin/bash

# source helper functions
. ../helperfunctions.sh

# source configuration
. ../OPTIONS.conf


printAndLogMessage "SET STATIC IP IN /etc/hosts" 
## manipulated file /etc/hosts
file="/etc/hosts"

printAndLogMessage "Manipulated file: " $file
printAndLogMessage "Save original file: " $file
saveOriginal $file
logFile $file

printAndLogMessage "Change file: " $file
# set 172.01.1 to STATIC IP
sed -e "{
    /$(hostname)/ s/127.0.1.1/${STATIC_IP}/
}" -i $file 

logFile $file

