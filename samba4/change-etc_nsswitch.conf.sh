#! /bin/bash

# source helper functions
. ../helperfunctions.sh

# source configuration
. ../OPTIONS.conf


file=/etc/nsswitch.conf
printAndLogMessage "Manipulated file: " $file
logFile $file
saveFile $file

printAndLogMessage "Change file: " $file
# Set Right Parameters in /etc/nsswitch.conf
# passwd:         files systemd winbind
# group:          files systemd winbind
# shadow:         files 

#printAndLogMessage "auth-client-config -t nss -p lac_ldap"
#auth-client-config -t nss -p lac_ldap

sed -e "{
	/^passwd:/ s/$/ winbind/
}" -e "{
	/^group:/ s/$/ winbind/
}" -i $file

logFile $file
