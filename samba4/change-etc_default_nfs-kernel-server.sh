#!/bin/bash

# source helper functions
. ../helperfunctions.sh

# source configuration
. ../OPTIONS.conf

# manipulated file
file="/etc/default/nfs-kernel-server"
printAndLogMessage "Manipulated file: " ${file}

printAndLogMessage "Save original file: " ${file}
saveOriginal $file
logFile $file

printAndLogMessage "Write to file: " ${file}

# single quotes because double qutes inside !
sed -e '{
	/NEED_SVCGSSD=""/ s/NEED_SVCGSSD=""/NEED_SVCGSSD="yes"/
}' -i $file

logFile ${file}


