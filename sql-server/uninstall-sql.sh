#!/bin/bash

# uninstall mysql-server

apt-get remove --purge mysql-server mysql-client mysql-common

rm -rf /var/lib/mysql

 
