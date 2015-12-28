#!/bin/bash

# source helper functions
. ../helperfunctions.sh

# source configuration
. ../OPTIONS.conf

# manipulated file
file=/etc/hostname
printAndLogMessage "Manipulated file: " $file

if  [ $(hostname) = $HOSTNAME ];
then
	printAndLogMessage "hostname" $(hostname) "already OK!"
	exit
fi

OLD_HOSTNAME=$(hostname)

printAndLogMessage "Save original file: " $file
saveOriginal $file
logFile $file

printAndLogMessage "Change hostname for runnig system"
hostname $HOSTNAME

printAndLogMessage "Change file: " $file
sed -e "{
	/$OLD_HOSTNAME/ s/$OLD_HOSTNAME/$HOSTNAME/
}" -i $file
logFile $file

# manipulated file
file=/etc/hosts
printAndLogMessage "Manipulated file: " $file

printAndLogMessage "Save original file: " $file
saveOriginal $file
logFile $file

printAndLogMessage "Change file: " $file
sed -e "{
	/$OLD_HOSTNAME/ s/$OLD_HOSTNAME/$HOSTNAME/
}" -i $file
logFile $file
