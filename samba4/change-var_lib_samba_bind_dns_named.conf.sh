#!/bin/bash

# source helper functions
. ../helperfunctions.sh

# source configuration
. ../OPTIONS.conf


printAndLogMessage "CONNECT samba4 to bind9"
printAndLogMessage "uncomment library ${DLZ_BIND9_LIBRARY} in /var/lib/samba/bind-dns/named.conf"
## manipulated file /var/lib/samba/bind-dns/named.conf
file="/var/lib/samba/bind-dns/named.conf"

printAndLogMessage "Manipulated file: " $file
printAndLogMessage "Save original file: " $file
saveOriginal $file
logFile $file

printAndLogMessage "Change file: " $file
# block host entrance, if one exists
sed -e "{
    /${DLZ_BIND9_LIBRARY}/ s/#//
}" -i $file 

logFile $file
