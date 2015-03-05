#!/bin/bash

# install isc-dhcp-server
apt-get -y update
apt-get -y install isc-dhcp-server

service bind9 stop

## Configuration dhcp -server
# add own ip to dns_nameservers in /etc/network/interfaces
/bin/bash change-etc_network_interfaces.sh
# add dns - servers to forwarders in /etc/bind/named.conf.options
/bin/bash change-etc_bind_named.conf.options.sh
# add zone files to /etc/bind/named.conf.local
/bin/bash change-etc_bind_named.conf.local.sh
# write zone - files
/bin/bash write-zonefile.sh
# write reverse - zone - files
/bin/bash write-reversezonefile.sh

/etc/init.d/isc-dhcp-server restart

service bind9 start
 
