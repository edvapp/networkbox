#!/bin/bash

# source helper functions
. ../../helperfunctions.sh

# source configuration
. ../../OPTIONS.conf

SMB_FS_NAME=ad01f1
USERNAME=tsn
UID_NUMBER=750789918

## with UNIX attributes
samba-tool user create ${USERNAME} Passw0rd --home-drive H: --home-directory \\\\${SMB_FS_NAME}\\users\\701036\\s\\2010\\${USERNAME} --nis-domain ${SAMBA4_NIS_DOMAIN} --uid ${USERNAME} --uid-number ${UID_NUMBER} --login-shell /bin/bash --unix-home /home/users/701036/s/2010/${USERNAME} --gid-number 2000


