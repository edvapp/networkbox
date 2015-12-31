#!/bin/bash

# uninstall mysql-server

apt-get remove -y --purge mysql-server mysql-client mysql-common

rm -rf /var/lib/mysql
rm -rf /etc/mysql*
