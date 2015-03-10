#!/bin/bash

# install isc-dhcp-server
apt-get -y update
apt-get -y install tftpd-hpa

## Configuration tftp -server
# copy files to /var/lib/tftpboot
cp -R pxelinux.cfg	/var/lib/tftpboot/
cp -R preseed		/var/lib/tftpboot/
cp -R ubuntu-installer	/var/lib/tftpboot/

# download ubuntu - kernel - images 
/bin/bash wget-Ubuntu.sh


 
