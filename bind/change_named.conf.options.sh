#!/bin/bash

# source helper functions
. ../helperfunctions.sh

# source configuration
. ../OPTIONS.conf

# manipulated file
file=named.conf.options

# save original.conf.options
saveOriginal $file

# enable forwarding
sed -e "{
	/forwarders/ s/\/\/ //
}" -e "{
	/0.0.0.0/ s/\/\///
}" -e "{
	/\/\/ };/ s/\/\/ //
}" -e "{
	/0.0.0.0/ s/0.0.0.0;/${DNS_1};\n\t\t${DNS_2};\n\t\t${DNS_3};/
}" -i $file


