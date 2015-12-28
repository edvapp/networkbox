#!/bin/bash

# source helper functions
. ../helperfunctions.sh

# source configuration
. ../OPTIONS.conf

# manipulated file
file=/etc/bind/named.conf.options
printAndLogMessage "Manipulated file: " $file

# save original.conf.options
printAndLogMessage "Save original file: " $file
saveOriginal $file
logFile $file

printAndLogMessage "Enable forwarding in file: " $file
sed -e "{
	/forwarders/ s/\/\/ forwarders/forwarders/
}" -e "{
	/0.0.0.0/ s/\/\///
}" -e "{
	/\/\/ \};/ s/\/\/ \};/\};/
}" -e "{
	/0.0.0.0/ s/0.0.0.0;/${DNS_IP_PROVIDER};\n\t\t${DNS_IP_WWW};/
}" -i $file

logFile $file

