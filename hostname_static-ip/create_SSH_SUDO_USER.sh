#!/bin/bash

# source helper functions
. ../helperfunctions.sh

# source configuration
. ../OPTIONS.conf

# manipulated file
file=/etc/ssh/sshd_config

printAndLogMessage "create sudo user $LXD_SSH_SUDO_USER in Container"
useradd --shell=/bin/bash --uid=1020 -G sudo -p $(openssl passwd -1 $LXD_SSH_SUDO_USER_PASSWORD) $LXD_SSH_SUDO_USER
	
printAndLogMessage "enable ssh login with password into Container"
# change PasswordAuthentication no -> default=yes
sed -e "{
	/PasswordAuthentication no/ s/PasswordAuthentication no/#PasswordAuthentication no/
}" -i $file


	
