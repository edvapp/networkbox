#!/bin/bash

# source helper functions
. ../helperfunctions.sh

# source configuration
. ../OPTIONS.conf

CURRENT_DIR=$(pwd)
cd hostname_static-ip
/bin/bash uninstall-hostname_and_static_ip.sh
$CURRENT_DIR

cd bind
/bin/bash uninstall-bind.sh
cd $CURRENT_DIR

cd dhcp
/bin/bash uninstall-dhcp.sh
cd $CURRENT_DIR

cd aptcacher
/bin/bash uninstall-aptcacher.sh
cd $CURRENT_DIR

cd tftpboot
/bin/bash uninstall-tftpboot.sh
cd $CURRENT_DIR

cd nfs-server
/bin/bash uninstall-nfs_server.sh
cd $CURRENT_DIR

cd laus
/bin/bash uninstall-laus_server.sh
cd $CURRENT_DIR

reboot


