#!/bin/bash

# source helper functions
. ../helperfunctions.sh

# source configuration
. ../OPTIONS.conf

# full install check is done in install-ad_client.sh

printAndLogStartMessage "START: INSTALLATION OF SAMBA4 FILE - SERVER"

export DEBIAN_FRONTEND=noninteractive

## check if FQDN exists in /etc/hosts
if [ $(hostname) = $(hostname --fqdn) ];
then
        /bin/bash change-etc_hosts.sh
fi

printAndLogMessage "INSTALL PACKAGES"
printAndLogMessage "apt-get install -y acl attr samba samba-dsdb-modules samba-vfs-modules winbind krb5-config krb5-user bind9-dnsutils libnss-winbind"
## from samba - wiki: acl attr samba samba-dsdb-modules samba-vfs-modules winbind krb5-config krb5-user
## acl, attr: exteded acls
## bind9-dnsutils: dig, nslookup
## to get Domain Users/Groups onto Fileserver to set Directory/File Permissions: libnss-winbind
apt-get install -y acl attr samba samba-dsdb-modules samba-vfs-modules sssd−ad sssd−tools realmd adcli krb5−user bind9-dnsutils

##STOP AND DISABLE systemd-resolved & SET AD DOMAIN CONTROLLER IP AS NAMESERVER IN NEW $file"
/bin/bash change-etc_resolv.conf.sh  

### WRITE NEW CLEAN KERBEROS CONFIGURATION FILES
/bin/bash write-etc_krb5.conf.sh

printAndLogMessage "enable automatic home-directory creation"
pam−auth−update −−enable mkhomedir

printAndLogMessage "join domain ${SAMBA4_REALM_DOMAIN_NAME}"
realm join -v --one-time-password=secret1234 SAMBA4_REALM_DOMAIN_NAME

## WRITE NEW /etc/samba/smb.conf
/bin/bash write-etc_samba_smb.conf.sh

printAndLogMessage "join domain ${SAMBA4_DNS_DOMAIN_NAME}"
net ads join -U Administrator@${SAMBA4_DNS_DOMAIN_NAME}%${SAMBA4_ADMINISTRATOR_PASSWORD}

printAndLogMessage "create directory for users ${SAMBA4_HOMES_BASE_DIR}/users/"
mkdir -p ${SAMBA4_HOMES_BASE_DIR}/users/

printAndLogMessage "change group to Domain Users for ${SAMBA4_HOMES_BASE_DIR}/users/"
chgrp "${SAMBA4_DOMAIN}\Domain Admins" ${SAMBA4_HOMES_BASE_DIR}/users/

printAndLogMessage "change mode for directory ${SAMBA4_HOMES_BASE_DIR}/users/"
chmod 2775 ${SAMBA4_HOMES_BASE_DIR}/users/

printAndLogMessage "add share /home/xchange/"
/bin/bash add_share_xchange-etc_samba_smb.conf.sh

printAndLogEndMessage "FINISH:  INSTALLATION OF SAMBA4 FILE - SERVER"


