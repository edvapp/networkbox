#!/bin/bash

# uninstall web-server

apt-get -q -y purge apache2 libapache2-mod-php php-common php-cli php-curl php-fileinfo php-gd php-gmp php-gmagick php-imagick php-intl php-json php-mbstring php-mysql php-xmlrpc php-xml php-zip

rm -R /etc/apache2

rm -R /var/www/html

apt-get -q -y autoremove
