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


printAndLogStartMessage "START: INSTALLATION OF SAMBA4 AD - CONTROLLER"

export DEBIAN_FRONTEND=noninteractive

## check if FQDN exists in /etc/hosts
if [ $(hostname) = $(hostname --fqdn) ];
then
        /bin/bash change-etc_hosts.sh
fi

printAndLogMessage "INSTALL PACKAGES"
printAndLogMessage "apt-get install -y acl attr samba samba-dsdb-modules samba-vfs-modules winbind krb5-config krb5-user bind9-dnsutils ldb-tools"
## from samba - wiki: acl attr samba samba-dsdb-modules samba-vfs-modules winbind krb5-config krb5-user
## acl, attr: exteded acls
## bind9-dnsutils: dig, nslookup
## to have a look at the ldb-databases: ldb-tools
apt-get install -y acl attr samba samba-dsdb-modules samba-vfs-modules winbind krb5-config krb5-user bind9-dnsutils ldb-tools


printAndLogMessage "CLEAN SAMBA & KERBEROS CONFIGURATION FILES"
printAndLogMessage "mv /etc/samba/smb.conf /etc/samba/smb.conf.orig"
printAndLogMessage "mv /etc/krb5.conf /etc/krb5.conf.orig"
mv /etc/samba/smb.conf /etc/samba/smb.conf.orig
mv /etc/krb5.conf /etc/krb5.conf.orig

printAndLogMessage "PROVISION ACTIVE DIRECTORY SERVER"
printAndLogMessage "samba-tool domain provision --server-role=dc --use-rfc2307 --dns-backend=SAMBA_INTERNAL --realm=${SAMBA4_REALM_DOMAIN_NAME} --domain=${SAMBA4_DOMAIN} --adminpass=${SAMBA4_ADMINISTRATOR_PASSWORD}"
samba-tool domain provision --server-role=dc --use-rfc2307 --dns-backend=SAMBA_INTERNAL --realm=${SAMBA4_REALM_DOMAIN_NAME} --domain=${SAMBA4_DOMAIN} --adminpass=${SAMBA4_ADMINISTRATOR_PASSWORD}

printAndLogMessage "INSTALL KERBEROS CONFIGURATION FROM SAMBA4"
printAndLogMessage "cp /var/lib/samba/private/krb5.conf /etc"
cp /var/lib/samba/private/krb5.conf /etc

## "STOP AND DISABLE systemd-resolved & SET OWN IP AS NAMESERVER IN NEW $file"
/bin/bash change-etc_resolv.conf.sh

printAndLogMessage  "MASK, DISABLE & STOP smbd nmbd winbind"
systemctl mask smbd nmbd winbind
systemctl disable smbd nmbd winbind
systemctl stop smbd nmbd winbind

## SET FORWARDER IN /etc/samba/smb.conf
/bin/bash change-etc_samba_smb.conf.sh

printAndLogMessage  "UMASK, START & ENABLE samba-ad-dc"
systemctl unmask samba-ad-dc
systemctl start samba-ad-dc
systemctl enable samba-ad-dc

printAndLogEndMessage "FINISH: INSTALLATION OF SAMBA4 AD - CONTROLLER"


