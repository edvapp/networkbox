#!/bin/bash

# source helper functions
. ../helperfunctions.sh

# source configuration
. ../OPTIONS.conf

# install samba4 ad controller
if [ ! "$FULLINSTALL" = "true" ];
then
	echo "FULLINSTALL=false"
	apt-get -y update
fi

printAndLogStartMessage "START: INSTALLATION OF SAMBA4 FILE - SERVER"

export DEBIAN_FRONTEND=noninteractive

printAndLogStartMessage "CHECK /etc/hosts FOR FQDN & STATIC IP"
## check if FQDN exists in /etc/hosts
if [ $(hostname) = $(hostname --fqdn) ];
then
        /bin/bash change-FQHN-etc_hosts.sh
fi
## set STATIC IP in /etc/hosts
/bin/bash change-IP-etc_hosts.sh

printAndLogMessage "INSTALL PACKAGES"
printAndLogMessage "acl attr samba samba-dsdb-modules samba-vfs-modules winbind krb5-config krb5-user bind9-dnsutils ldb-tools adcli"
## from samba - wiki: acl attr samba samba-dsdb-modules samba-vfs-modules winbind krb5-config krb5-user
## acl, attr: exteded acls
## bind9-dnsutils: dig, nslookup
## to get Domain Users/Groups onto Fileserver to set Directory/File Permissions: libnss-winbind
## to enable local logins for Domain Users: libpam-winbind
## to preset computer-accounts: adcli
apt-get install -y acl attr samba samba-dsdb-modules samba-vfs-modules winbind krb5-config krb5-user bind9-dnsutils libnss-winbind libpam-winbind adcli 

## STOP all services
printAndLogMessage "systemctl stop smbd"
systemctl stop smbd
printAndLogMessage "systemctl stop nmbd"
systemctl stop nmbd
printAndLogMessage "systemctl stop winbind"
systemctl stop winbind

## STOP AND DISABLE systemd-resolved & SET AD DOMAIN CONTROLLER IP AS NAMESERVER IN NEW $file"
/bin/bash change-etc_resolv.conf.sh  

### WRITE NEW CLEAN KERBEROS CONFIGURATION FILES
/bin/bash write-etc_krb5.conf.sh

## WRITE NEW /etc/samba/smb.conf
/bin/bash write-etc_samba_smb.conf.sh

## CONNECT client via nsswitch.conf and winbind to domain ${SAMBA4_DOMAIN}
/bin/bash change-etc_nsswitch.conf.sh

## START all services
printAndLogMessage "systemctl start smbd"
systemctl start smbd
printAndLogMessage "systemctl start nmbd"
systemctl start nmbd
printAndLogMessage "systemctl start winbind"
systemctl start winbind

## enable automatic home-directory creation
printAndLogMessage "enable automatic home-directory creation"
pam-auth-update --enable mkhomedir

printAndLogMessage "join domain ${SAMBA4_REALM_DOMAIN_NAME}"
# adcli join -v --one-time-password=secret1234 ${SAMBA4_REALM_DOMAIN_NAME}
# looks like adcli works only with sssd without problems :-( ??
# so we use net ads on servers
# server will also be added to DNS, if it does not exist. error message if allready in DNS
net ads join -U Administrator@${SAMBA4_DNS_DOMAIN_NAME}%${SAMBA4_ADMINISTRATOR_PASSWORD}

printAndLogMessage "create directory for users ${SAMBA4_HOMES_BASE_DIR}"
mkdir -p -v ${SAMBA4_NFS_TEACHERS_HOMEDIR}
mkdir -p -v ${SAMBA4_NFS_PUPILS_HOMEDIR}
mkdir -p -v ${SAMBA4_NFS_STAFF_HOMEDIR}

#printAndLogMessage "change group to Domain Users for ${SAMBA4_HOMES_BASE_DIR}"
#chgrp -v "${SAMBA4_DOMAIN}\Domain Admins" ${SAMBA4_HOMES_BASE_DIR}

printAndLogMessage "change mode for directory ${SAMBA4_HOMES_BASE_DIR}"
chmod -v 2775 ${SAMBA4_HOMES_BASE_DIR}

printAndLogMessage "add share /home/xchange/"
/bin/bash add_share_xchange-etc_samba_smb.conf.sh


#### ADD NFS - Server START ####
cd ../nfs-server
/bin/bash install-nfs_server.sh
cd ../samba4

printAndLogMessage "create export directories in ${NFS_EXPORT_DIR}"
mkdir -p -v ${NFS_EXPORT_TEACHERS_HOMEDIR}
mkdir -p -v ${NFS_EXPORT_PUPILS_HOMEDIR}
mkdir -p -v ${NFS_EXPORT_STAFF_HOMEDIR}

mount --bind ${SAMBA4_NFS_TEACHERS_HOMEDIR}/ ${NFS_EXPORT_TEACHERS_HOMEDIR}
mount --bind ${SAMBA4_NFS_PUPILS_HOMEDIR}/ ${NFS_EXPORT_PUPILS_HOMEDIR}
mount --bind ${SAMBA4_NFS_STAFF_HOMEDIR}/ ${NFS_EXPORT_STAFF_HOMEDIR}

printAndLogMessage "MOUNT ${SAMBA4_HOMES_BASE_DIR}/${SCHOOL_ID_NUMBER}/l s v TO EXPORTS DIRECTORY $NFS_EXPORT_DIR/${SCHOOL_ID_NUMBER}/l s v"
/bin/bash change-etc_fstab.sh

printAndLogMessage "ADD $NFS_EXPORT_DIR/l s v TO /etc/exports"
/bin/bash change-etc_exports.sh
#### ADD NFS - Server END ####


printAndLogEndMessage "FINISH:  INSTALLATION OF SAMBA4 FILE - SERVER"


