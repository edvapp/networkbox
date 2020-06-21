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
# passwd:         files systemd ldap
# group:          files systemd ldap
# shadow:         files ldap

#printAndLogMessage "auth-client-config -t nss -p lac_ldap"
#auth-client-config -t nss -p lac_ldap

sed -e "{
	/^passwd:/ s/$/ ldap/
}" -e "{
	/^group:/ s/$/ ldap/
}" -e "{
	/^shadow:/ s/$/ ldap/
}" -i $file

logFile $file
