#!/bin/bash

# source helper functions
. ../helperfunctions.sh

# source configuration
. ../SAMBA4.conf

# manipulated file
file=/etc/bind/named.conf.local
printAndLogMessage "Manipulated file: " ${file}

printAndLogMessage "Save original file: " ${file}
saveOriginal ${file}
logFile ${file}

printAndLogMessage "Write to file: " ${file}

echo "
include \"/var/lib/samba/bind-dns/named.conf\";
" > ${file}

logFile ${file}

