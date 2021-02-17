#!/bin/bash

# LAUS - Client - Starter
#
# Start LAUS - Client - Script
# Connects to LAUS - Server 
# to execute more Scripts
# 
## source system - functions
. /lib/init/vars.sh
. /lib/lsb/init-functions


## for testing
#file="/var/log/laus/testfile.txt"
#updatetime=$(date +%Y%m%d-%T)
#newfile=$file".laus."$updatetime
#cp $file $newfile
#exit 0

# source settings from config-file
. /etc/default/laus-setup

test "$ENABLE_AUTOUPDATE" = "yes" || exit 0

log_action_begin_msg "starting LAUS - client"
# test, if mountpath on client exists
if ! test -d $MOUNT_PATH_ON_CLIENT; 
then
	mkdir $MOUNT_PATH_ON_CLIENT;
fi

# test, if updatelog-path on client exists
if ! test -d $UPDATE_LOG_DIR; 
then
	mkdir $UPDATE_LOG_DIR
	chmod 770 $UPDATE_LOG_DIR
fi

# mount LAUS directory from LAUS Server
mount -o soft -t nfs4 $LAUS_SERVER:$PATH_ON_LAUS_SERVER $MOUNT_PATH_ON_CLIENT
if test $? -eq 0;
then
	LAST_PATH=$(pwd)
	cd $MOUNT_PATH_ON_CLIENT"/"$LAUS_PATH
	/bin/bash ./laus-server.sh $1
	cd $LAST_PATH
	umount $MOUNT_PATH_ON_CLIENT
else
	# echo "Zugriff auf "$LAUS_SERVER" ist fehlgeschlagen"
	log_warning_msg "Connection to "$LAUS_SERVER" failed!"
fi
log_action_end_msg $?
