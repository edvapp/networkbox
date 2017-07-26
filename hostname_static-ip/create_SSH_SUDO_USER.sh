#!/bin/bash

# source helper functions
. ../helperfunctions.sh

# source configuration
. ../OPTIONS.conf

printAndLogMessage "create sudo user $LXD_SSH_SUDO_USER in Container"
useradd --shell=/bin/bash --uid=1020 -G sudo -p $(openssl passwd -1 $LXD_SSH_SUDO_USER_PASSWORD) $LXD_SSH_SUDO_USER

# manipulated file
file=/etc/ssh/sshd_config

printAndLogMessage "Save original file: " $file
saveOriginal $file
logFile $file
	
printAndLogMessage "enable ssh login with password into Container"
# change PasswordAuthentication no -> default=yes
sed -e "{
	/PasswordAuthentication no/ s/PasswordAuthentication no/#PasswordAuthentication no/
}" -i $file


	
