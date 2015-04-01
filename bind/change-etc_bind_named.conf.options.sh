#!/bin/bash

# source helper functions
. ../helperfunctions.sh

# source configuration
. ../OPTIONS.conf

# manipulated file
file=/etc/bind/named.conf.options

# save original.conf.options
saveOriginal $file

# enable forwarding
sed -e "{
	/forwarders/ s/\/\/ forwarders/forwarders/
}" -e "{
	/0.0.0.0/ s/\/\///
}" -e "{
	/\/\/ \};/ s/\/\/ \};/\};/
}" -e "{
	/0.0.0.0/ s/0.0.0.0;/${DNS_IP_PROVIDER};\n\t\t${DNS_IP_WWW};/
}" -i $file


