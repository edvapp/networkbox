#!/bin/bash

USER_LIST=$(wbinfo -u)

for USER in ${USER_LIST};
do
        ## get user info in format
        ## DOMAIN\username:*:uidNUmber:gidNumber::homedirectory_path:/bin/bash
        echo "processing ${USER}"
        wbinfo --user-info ${USER}
        if [ "$?" == "0" ];
        then
                USER_HOME_DIR_PATH=$(wbinfo --user-info ${USER} | awk 'BEGIN {FS = ":" } { print $6 } ')
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
                fi
        fi
done

