#!/bin/bash

# install bind9 DNS dns_nameservers

# install bind9 dpkg - package
apt-get -y update
apt-get -y install bind9

service bind9 stop

# add dns - servers to forwarders in /etc/bind/named.conf.options
/bin/bash change-etc_bind_named.conf.options.sh
# add zone files to /etc/bind/named.conf.local
/bin/bash change-etc_bind_named.conf.local.sh
# write zone - files
/bin/bash write-etc_bind_zonefile.sh
# write reverse - zone - files
/bin/bash write-etc_bind_reversezonefile.sh

service bind9 start
