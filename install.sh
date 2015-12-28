#!/bin/bash

printAndLogStartMessage "START: FULLINSTALL NETWORKBOX at: " $(date)
# execute apt-get -y update just once
FULLINSTALL=true
export FULLINSTALL

apt-get -y update

INSTALL_ROOT_DIR=$(pwd)

cd hostname_static-ip
/bin/bash install-hostname_and_static_ip.sh
cd $INSTALL_ROOT_DIR

cd bind
/bin/bash install-bind.sh
cd $INSTALL_ROOT_DIR

cd dhcp
/bin/bash install-dhcp.sh
cd $INSTALL_ROOT_DIR

cd aptcacher
/bin/bash install-aptcacher.sh
cd $INSTALL_ROOT_DIR

cd tftpboot
/bin/bash install-tftpboot.sh
cd $INSTALL_ROOT_DIR

cd nfs-server
/bin/bash install-nfs_server.sh
cd $INSTALL_ROOT_DIR

cd laus
/bin/bash install-laus_server.sh
cd $INSTALL_ROOT_DIR

cd owncloud
/bin/bash install-owncloud.sh
cd $INSTALL_ROOT_DIR

printAndLogStartMessage "FINISH: FULLINSTALL NETWORKBOX at: " $(date)

reboot


