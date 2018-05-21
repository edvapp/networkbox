#!/bin/bash

# source helper functions
. ../helperfunctions.sh

# source configuration
. ../OPTIONS.conf

# manipulated file
file=/etc/cloud/cloud.cfg 
printAndLogMessage "Manipulated file: " $file

printAndLogMessage "Save original file: " $file
saveOriginal $file
logFile $file

printAndLogMessage "Enable change of hostname in: " $file

printAndLogMessage "Change file: " $file
sed -e "{
    /preserve_hostname/ s/false/true/
}" -i $file
logFile $file
