#!/bin/bash

# uninstall mariadb-server

apt-get remove -y --purge mariadb-server
apt-get -y autoremove
