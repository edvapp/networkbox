#!/bin/bash

# set path to directory, where user-homedirectories life
HOME_DIR_PATH="/home/users/701036/l"
SAVED_OLD_HOMEDIRS="xxxOLD"
# get own domain (short version: brg.tsn -> BRG)
OWN_DOMAIN=$(wbinfo --own-domain)

LOCAL_USER_LIST=$(ls ${HOME_DIR_PATH})
echo $LOCAL_USER_LIST

for USER in ${LOCAL_USER_LIST};
do
        ## we will not check $HOME_DIR_PATH/$SAVED_OLD_HOMEDIRS
        if [ "${USER}" == "${SAVED_OLD_HOMEDIRS}" ]
        then
                exit
        fi
        ## check if user with same name as ${USER} exists
        wbinfo --user-info ${OWN_DOMAIN}\\${USER} 2> /dev/null
        ## check if user was found
        if [ ! "$?" == "0" ];
        then
                echo "user ${USER} not found in AD, homedirectory will be moved to directory ${SAVED_OLD_HOMEDIRS}"
                if [ ! -d ${HOME_DIR_PATH}/${SAVED_OLD_HOMEDIRS} ];
                then
                        mkdir -p ${HOME_DIR_PATH}/${SAVED_OLD_HOMEDIRS}
                fi
                cp -r ${HOME_DIR_PATH}/${USER} ${HOME_DIR_PATH}/${SAVED_OLD_HOMEDIRS}/${USER}
        fi
done



