#!/bin/bash

# source helper functions
. ../../helperfunctions.sh

# source configuration
. ../../OPTIONS.conf

## through LDAP - Connection from other machine  
samba-tool user create zuwl02 Passw0rd --home-drive H: --home-directory \\\\SMB01\\users\\zuwl02 --nis-domain fisc --uid zuwl01 --uid-number 11112 --login-shell /bin/bash --unix-home /home/users/zuwl02 --gid-number 2000 -H ldap:\\ad01.${SAMBA4_DNS_DOMAIN_NAME} -UAdministrator

mkdir /home/users/zuwl02
chmod 700 /home/users/zuwl02
chown 11112:2000 /home/users/zuwl02
