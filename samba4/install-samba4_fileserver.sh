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
apt-get install -y acl attr samba samba-dsdb-modules samba-vfs-modules winbind krb5-config krb5-user bind9-dnsutils libnss-winbind

## CONNECT client via nsswitch.conf and winbind to domain ${SAMBA4_DOMAIN}
/bin/bash change-nsswitch.conf.sh

printAndLogMessage "CLEAN KERBEROS CONFIGURATION FILES"
printAndLogMessage "mv /etc/krb5.conf /etc/krb5.conf.orig"
mv /etc/krb5.conf /etc/krb5.conf.orig

##STOP AND DISABLE systemd-resolved & SET AD DOMAIN CONTROLLER IP AS NAMESERVER IN NEW $file"
/bin/bash change-etc_resolv.conf.sh

printAndLogMessage "create directory for users ${SAMBA4_HOMES_BASE_DIR}/users/"
mkdir -p ${SAMBA4_HOMES_BASE_DIR}/users/

printAndLogMessage "create directory /home/xchange"
mkdir -p /home/xchange

## WRITE NEW /etc/samba/smb.conf
/bin/bash write-etc_samba_smb.conf.sh

net ads join -U Administrator@${SAMBA4_DNS_DOMAIN_NAME}%${SAMBA4_ADMINISTRATOR_PASSWORD}

printAndLogMessage "change group to Domain Users for ${SAMBA4_HOMES_BASE_DIR}/users/"
chgrp -R "Domain Users" ${SAMBA4_HOMES_BASE_DIR}/users/

printAndLogMessage "change mode for directory ${SAMBA4_HOMES_BASE_DIR}/users/"
chmod 2750 ${SAMBA4_HOMES_BASE_DIR}/users/

printAndLogMessage "change group to Domain Users for /home/xchange/"
chgrp -R "Domain Users" /home/xchange/

printAndLogMessage "change mode for directory /home/xchange/"
chmod 2777 /home/xchange/

printAndLogEndMessage "FINISH:  INSTALLATION OF SAMBA4 FILE - SERVER"


