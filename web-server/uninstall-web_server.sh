#!/bin/bash

# uninstall web-server

apt-get -q -y purge apache2

rm -R /var/www/html

apt-get -q -y autoremove
