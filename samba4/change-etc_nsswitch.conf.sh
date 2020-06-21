#! /bin/bash

# source helper functions
. ../helperfunctions.sh

# source configuration
. ../OPTIONS.conf


file=/etc/nsswitch.conf
printAndLogMessage "Manipulated file: " $file
saveFile $file
logFile $file

# Set Right Parameters in /etc/nsswitch.conf
# passwd:         files winbind
# group:          files winbind

printAndLogMessage "Change file: " $file
sed -e "{
	/^passwd:/ s/systemd/winbind/
}" -e "{
	/^group:/ s/systemd/winbind/
}" -i $file

logFile $file
