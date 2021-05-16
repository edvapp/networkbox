#!/bin/bash

# source helper functions
. ../helperfunctions.sh

# source configuration
. ../OPTIONS.conf

# install samba4 ad file server
if [ ! "$FULLINSTALL" = "true" ];
then
	printAndLogStartMessage "FULLINSTALL=false"
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
printAndLogMessage "systemctl stop nmbd"
systemctl stop nmbd
printAndLogMessage "systemctl stop winbind"
systemctl stop winbind
printAndLogMessage "systemctl stop smbd"
systemctl stop smbd

## STOP AND DISABLE systemd-resolved & SET AD DOMAIN CONTROLLER IP AS NAMESERVER IN NEW $file"
/bin/bash change-etc_resolv.conf.sh  

### WRITE NEW CLEAN KERBEROS CONFIGURATION FILES
/bin/bash write-etc_krb5.conf.sh

## WRITE NEW /etc/samba/smb.conf
/bin/bash write-etc_samba_smb.conf.sh

## CONNECT client via nsswitch.conf and winbind to domain ${SAMBA4_DOMAIN}
/bin/bash change-etc_nsswitch.conf.sh

## START smbd winbind services
printAndLogMessage "systemctl start smbd"
systemctl start smbd
printAndLogMessage "systemctl start winbind"
systemctl start winbind
## DISABLE nmbd
printAndLogMessage "systemctl disable nmbd"
systemctl disable nmbd

## enable automatic home-directory creation
printAndLogMessage "enable automatic home-directory creation"
pam-auth-update --enable mkhomedir

## SET TIMEZONE to ${SAMBA4_TIMEZONE}
printAndLogMessage "SET TIMEZONE TO ${SAMBA4_TIMEZONE}"
timedatectl set-timezone ${SAMBA4_TIMEZONE}

printAndLogMessage "join domain ${SAMBA4_REALM_DOMAIN_NAME}"
# adcli join -v --one-time-password=secret1234 ${SAMBA4_REALM_DOMAIN_NAME}
# looks like adcli works only with sssd without problems :-( ??
# so we use net ads on servers
# server will also be added to DNS, if it does not exist. error message if allready in DNS
# but due to UNIX attributes all AD - clients should be added with special script an AD - server anyway
net ads join -U Administrator@${SAMBA4_DNS_DOMAIN_NAME}%${SAMBA4_ADMINISTRATOR_PASSWORD}

printAndLogMessage "create directory for users ${SAMBA4_HOMES_BASE_DIR}"
for CONTAINER in ${OU_TSN_SYNC_CONTAINER_LIST};
do
        # we drop OU= from container: OU=701036 -> 701036
        SCHOOL_IDENTIFIER=${CONTAINER#OU=}
        for GROUP_IDENTIFIER in ${GROUP_IDENTIFIER_LIST};
        do
                mkdir -v -p ${SAMBA4_HOMES_BASE_DIR}/${SCHOOL_IDENTIFIER}/${GROUP_IDENTIFIER}
        done
done

#printAndLogMessage "change group to Domain Users for ${SAMBA4_HOMES_BASE_DIR}"
#chgrp -v "${SAMBA4_DOMAIN}\Domain Admins" ${SAMBA4_HOMES_BASE_DIR}

#printAndLogMessage "change mode for directory ${SAMBA4_HOMES_BASE_DIR}"
#chmod -v 2775 ${SAMBA4_HOMES_BASE_DIR}

printAndLogMessage "add share /home/xchange/"
/bin/bash add_share_xchange-etc_samba_smb.conf.sh

#### ADD NFS - Server START ####

if [ "${SAMBA4_NFS_EXPORT_DIR}" != "" ];
then
        /bin/bash install-nfs_server.sh
fi

#### ADD NFS - Server END ####

printAndLogEndMessage "FINISH:  INSTALLATION OF SAMBA4 FILE - SERVER"


