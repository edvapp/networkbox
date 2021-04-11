#!/bin/bash

## get own domain (short version: brg.tsn -> BRG)
OWN_DOMAIN=$(wbinfo --own-domain)

## directory to save unused homedirectories
SAVED_OLD_HOMEDIRS="xxxOLD"

## directory names for different groups
## l -> Lehrer*innen
## s -> Schüler*innen
## v -> Verwaltung
## we take, what is on this server
USER_GROUPS=$(ls /home/users/701036)
echo $USER_GROUPS

for GROUP in ${USER_GROUPS};
do
    ## set path to directory, where user-homedirectories live
    HOME_DIR_PATH="/home/users/701036/${GROUP}"
    echo "processing ${HOME_DIR_PATH}"

    ## get actual user list from homediréctory names
    LOCAL_USER_LIST=$(ls ${HOME_DIR_PATH})

    for USER in ${LOCAL_USER_LIST};
    do
        ## we will not check $HOME_DIR_PATH/$SAVED_OLD_HOMEDIRS
        if [ ! "${USER}" == "${SAVED_OLD_HOMEDIRS}" ]
        then
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
        fi
    done
done
