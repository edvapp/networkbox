#!/bin/bash

# install isc-dhcp-server
if [ ! "$FULLINSTALL" = "true" ];
then
	echo "FULLINSTALL=false"
	apt-get -y update
fi
apt-get -y install tftpd-hpa

## Configuration tftp -server
# copy files to /var/lib/tftpboot
cp -R pxelinux.cfg	/var/lib/tftpboot/
cp -R ubuntu-installer	/var/lib/tftpboot/
cp -R preseed		/var/lib/tftpboot/

# set password for tftp boot screen
/bin/bash config-tftp_bootmenu.sh

# config pressed - file
/bin/bash config-preseed.sh

# download ubuntu - kernel - images 
/bin/bash wget-Ubuntu.sh


 
