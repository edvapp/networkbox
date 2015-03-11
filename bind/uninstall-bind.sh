#!/bin/bash

# install bind9 DNS dns_nameservers

# uninstall bind9 dpkg - package
apt-get -y purge bind9

rm -R /etc/bind