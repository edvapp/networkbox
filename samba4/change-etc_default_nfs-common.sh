#!/bin/bash

# source helper functions
. ../helperfunctions.sh

# source configuration
. ../OPTIONS.conf

# manipulated file
file="/etc/default/nfs-common"
printAndLogMessage "Manipulated file: " ${file}

printAndLogMessage "Save original file: " ${file}
saveOriginal $file
logFile $file

printAndLogMessage "Write to file: " ${file}

# single quotes because double qutes inside !
sed -e '{
	/NEED_GSSD=$/ s/NEED_GSSD=/NEED_GSSD="yes"/
}' -i $file


logFile ${file}


