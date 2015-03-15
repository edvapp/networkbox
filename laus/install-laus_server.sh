#!/bin/bash

# create LAUS - autoinstall - directory
cd /opt
git clone http://github.com/edvapp/autoinstall.git

# create export directory
mkdir -p /export/autoinstall

# mount /opt/autoinstall to export directory /export/autoinstall
/bin/bash change-etc_fstab.sh

# add /export/autoinstall to exports
/bin/bash change-etc_exports.sh

