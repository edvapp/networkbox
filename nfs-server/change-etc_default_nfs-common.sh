#!/bin/bash

# source helper functions
. ../helperfunctions.sh

# source configuration
. ../OPTIONS.conf


# manipulated file
file=/etc/default/nfs-common
printAndLogMessage "Manipulated file: " $file

printAndLogMessage "Save original file: " $file
saveOriginal $file
logFile $file

printAndLogMessage "Change file: " $file
sed -e "{
	/NEED_IDMAPD=/ s/NEED_IDMAPD=/NEED_IDMAPD=yes/
}" -i $file
logFile $file
