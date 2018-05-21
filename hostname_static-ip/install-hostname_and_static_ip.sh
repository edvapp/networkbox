#!/bin/bash

# source helper functions
. ../helperfunctions.sh

# source configuration
. ../OPTIONS.conf

printAndLogStartMessage "START: INSTALL FIX IP AND SET HOSTNAME"

if [ "$LXD_CONTAINER" = "yes" ];
then
	printAndLogMessage "CREATE SSH-SUDO USER IN CONTAINER"
	/bin/bash create_SSH_SUDO_USER.sh
fi

printAndLogMessage "CHANGE HOSTNAME"
if [ -d /etc/cloud ];
then
	/bin/bash change-etc_cloud_cloud.cfg.sh
fi
	/bin/bash change-etc_hostname_hosts.sh

printAndLogMessage "CHANGE NETWORK INTERFACE FIX IP"
if [ -d /etc/netplan ];
then
	/bin/bash change-etc_netplan_interfaces.sh
else
	/bin/bash change-etc_network_interfaces.sh
fi

printAndLogEndMessage "FINISH: INSTALL FIX IP AND SET HOSTNAME"
