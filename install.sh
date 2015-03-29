#!/bin/bash


CURRENT_DIR=$(pwd)
cd hostname_static-ip
/bin/bash install-hostname_and_static_ip.sh
cd $CURRENT_DIR

cd bind
/bin/bash install-bind.sh
cd $CURRENT_DIR

cd dhcp
/bin/bash install-dhcp.sh
cd $CURRENT_DIR

cd aptcacher
/bin/bash install-aptcacher.sh
cd $CURRENT_DIR

cd tftpboot
/bin/bash install-tftpboot.sh
cd $CURRENT_DIR

cd nfs-server
/bin/bash install-nfs_server.sh
cd $CURRENT_DIR

cd laus
/bin/bash install-laus_server.sh
cd $CURRENT_DIR

reboot


