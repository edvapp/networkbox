#!/bin/bash

# install bind9 DNS dns_nameservers

# install bind9 dpkg - package
apt-get update
apt-get install bind9

# add own ip to dns_nameservers in /etc/network/interfaces
/bin/bash change-etc_interfaces.sh
# add dns - servers to forwarders in /etc/bind/named.conf.options
/bin/bash change-etc_bind_named.conf.options.sh
# add zone files to /etc/bind/named.conf.local
/bin/bash change-etc_bind_named.conf.local.sh
# write zone - files
/bin/bash write-reversezonefile.sh
# write reverse - zone - files
/bin/bash write-reversezonefile.sh


