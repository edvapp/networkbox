#!/bin/bash

# uninstall bind9 DNS dns_nameservers

# uninstall bind9 dpkg - package
apt-get -y purge bind9

echo "remove bind directories"

rm -R -v /etc/bind

rm -R -v /var/lib/bind
