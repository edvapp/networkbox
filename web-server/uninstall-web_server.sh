#!/bin/bash

# uninstall web-server

apt-get -q -y purge apache2 libapache2-mod-php7.0
apt-get -q -y purge php7.0-gd php7.0-json php7.0-mysql php7.0-curl php7.0-mbstring
apt-get -q -y purge php7.0-intl php7.0-mcrypt php-imagick php7.0-xml php7.0-zip

rm -R /var/www/html

apt-get -q -y autoremove
