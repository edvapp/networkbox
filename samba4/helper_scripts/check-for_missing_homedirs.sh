#!/bin/bash

## directory to save unused homedirectories
SAVED_OLD_HOMEDIRS="zzzOLD"

USER_LIST=$(wbinfo -u)

for USER in ${USER_LIST};
do
        ## get user info in format
        ## username:*:uidNUmber:gidNumber::homedirectory_path:/bin/bash
        echo "processing ${USER}"
        wbinfo --user-info ${USER}
        ## check if $? <=> exit-status of wbinfo --user-info is 0 <=> success
        ## because wbinfo --user-info does not work for build in users like administrator 
        if [ "$?" == "0" ];
        then
                ## we get homedirpath from wbinfo
                USER_HOME_DIR_PATH=$(wbinfo --user-info ${USER} | awk 'BEGIN {FS = ":" } { print $6 } ')
                ## we have to handle test accounts seperate
                ## because homedir looks like /tmp/testee_701036_001
                if [ "$(dirname ${USER_HOME_DIR_PATH})" == "/tmp" ];
                then
                        ## we extract SCHOOLNUMBER from username testee_701036_001
                        SCHOOL_NUMBER=${USER:7:6}
                        ## we build new new USER_HOME_DIR_PATH 
                        ## which is for Windows
                        USER_HOME_DIR_PATH="/home/users/${SCHOOL_NUMBER}/t/${USER}"
                fi
                echo "checking ${USER_HOME_DIR_PATH} for ${USER}"
                if [ ! -d ${USER_HOME_DIR_PATH} ];
                then
                        
                        echo "creating homedir ${USER_HOME_DIR_PATH} for ${USER}"
                        USER_UID_NUMBER=$(wbinfo --user-info ${USER} | awk 'BEGIN {FS = ":" } { print $3 } ')
                        USER_GID_NUMBER=$(wbinfo --user-info ${USER} | awk 'BEGIN {FS = ":" } { print $4 } ')
                        ## TODO:
                        ## check if ${USER_UID_NUMBER} exists in unused homedirs and move to ${USER_HOME_DIR_PATH}
                        mkdir -p ${USER_HOME_DIR_PATH}
                        echo "setting owner to ${USER_UID_NUMBER}:${USER_GID_NUMBER}"
                        chown ${USER_UID_NUMBER}:${USER_GID_NUMBER} ${USER_HOME_DIR_PATH}
                        echo "setting permission to 700 for ${USER_UID_NUMBER}:${USER_GID_NUMBER}"
                        chmod 700 ${USER_HOME_DIR_PATH}
                fi
        fi
done

