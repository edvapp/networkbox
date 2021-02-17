#!/bin/bash

# uninstall tftp - server

# source /etc/default/
. /etc/default/tftpd-hpa
# to get variable $TFTP_DIRECTORY
# configured in /etc/default/tftpd-hpa
# save variable $TFTP_DIRECTORY, 
# because after purge it will lost
SAVE_TFTP_DIRECTORY=$TFTP_DIRECTORY

apt-get -y purge tftpd-hpa

rm -R $SAVE_TFTP_DIRECTORY

apt-get -y purge apache2

rm -R /var/www/html



 
