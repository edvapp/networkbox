#!/bin/bash

# source helper functions
. ../helperfunctions.sh

# source configuration
. ../OPTIONS.conf

printAndLogStartMessage "START: INSTALL FIX IP AND SET HOSTNAME"

printAndLogMessage "CHANGE NETWORK INTERFACE FIX IP"
/bin/bash change-etc_network_interfaces.sh

printAndLogMessage "CHANGE HOSTNAME"
/bin/bash change-etc_hostname_hosts.sh

printAndLogEndMessage "FINISH: INSTALL FIX IP AND SET HOSTNAME"
