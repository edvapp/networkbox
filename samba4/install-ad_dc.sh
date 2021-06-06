#!/bin/bash

# source helper functions
. ../helperfunctions.sh

# source configuration
. ../SAMBA4.conf

# install samba4 ad controller
if [ ! "$FULLINSTALL" = "true" ];
then
	echo "FULLINSTALL=false"
	apt-get -y update
fi

printAndLogStartMessage "START: INSTALLATION OF SAMBA4 AD - CONTROLLER"

export DEBIAN_FRONTEND=noninteractive

printAndLogStartMessage "CHECK /etc/hosts FOR FQDN & STATIC IP"
## check if FQDN exists in /etc/hosts
if [ $(hostname) = $(hostname --fqdn) ];
then
        /bin/bash change-FQHN-etc_hosts.sh
fi
## set the static IP in /etc/hosts
/bin/bash change-IP-etc_hosts.sh

printAndLogMessage "INSTALL PACKAGES"
printAndLogMessage "apt-get install -y acl attr samba samba-dsdb-modules samba-vfs-modules winbind krb5-config krb5-user bind9 bind9-dnsutils ldb-tools adcli nfs-common autofs"
## from samba - wiki: acl attr samba samba-dsdb-modules samba-vfs-modules winbind krb5-config krb5-user
## acl, attr: exteded acls
## bind9: dns - server
## bind9-dnsutils: dig, nslookup
## to have a look at the ldb-databases: ldb-tools
## to preset computer-accounts: adcli
## to act as an nfs-client: nfs-common autofs
apt-get install -y acl attr samba samba-dsdb-modules samba-vfs-modules winbind krb5-config krb5-user bind9 bind9-dnsutils ldb-tools adcli nfs-common autofs

printAndLogMessage  "MASK, DISABLE & STOP smbd nmbd winbind"
systemctl mask smbd nmbd winbind
systemctl disable smbd nmbd winbind
systemctl stop smbd nmbd winbind

printAndLogMessage "CLEAN SAMBA & KERBEROS CONFIGURATION FILES"
printAndLogMessage "mv /etc/samba/smb.conf /etc/samba/smb.conf.orig"
printAndLogMessage "mv /etc/krb5.conf /etc/krb5.conf.orig"
mv /etc/samba/smb.conf /etc/samba/smb.conf.orig
mv /etc/krb5.conf /etc/krb5.conf.orig

## SET TIMEZONE to ${SAMBA4_TIMEZONE}
printAndLogMessage "SET TIMEZONE TO ${SAMBA4_TIMEZONE}"
timedatectl set-timezone ${SAMBA4_TIMEZONE}

printAndLogMessage "PROVISION ACTIVE DIRECTORY SERVER"
printAndLogMessage "samba-tool domain provision --server-role=dc --use-rfc2307 --dns-backend=SAMBA_INTERNAL --realm=${SAMBA4_REALM_DOMAIN_NAME} --domain=${SAMBA4_DOMAIN} --adminpass=${SAMBA4_ADMINISTRATOR_PASSWORD}"
#samba-tool domain provision --server-role=dc --use-rfc2307 --dns-backend=SAMBA_INTERNAL --realm=${SAMBA4_REALM_DOMAIN_NAME} --domain=${SAMBA4_DOMAIN} --adminpass=${SAMBA4_ADMINISTRATOR_PASSWORD}
samba-tool domain provision --server-role=dc --use-rfc2307 --dns-backend=BIND9_DLZ --realm=${SAMBA4_REALM_DOMAIN_NAME} --domain=${SAMBA4_DOMAIN} --adminpass=${SAMBA4_ADMINISTRATOR_PASSWORD}

printAndLogMessage "INSTALL KERBEROS CONFIGURATION FROM SAMBA4"
printAndLogMessage "cp /var/lib/samba/private/krb5.conf /etc"
cp /var/lib/samba/private/krb5.conf /etc

## "STOP AND DISABLE systemd-resolved & SET OWN IP AS NAMESERVER IN NEW $file"
## has to be done AFTER
## * apt-get install
## * samba-tool domain provision
## because DNS lookup is brocken
/bin/bash change-etc_resolv.conf.sh

## SET FORWARDER IN /etc/samba/smb.conf
## DNS lookup should work now again 
## BUT:
## dns forwarder = ddd.ddd.ddd.ddd 
## at the moment not found in /etc/samba/smb.conf
## because only needed with "internal" dns-server
## /bin/bash change-etc_samba_smb.conf.sh

## CONFIGURE BIND9 DNS Server
printAndLogMessage "CONFIGURE BIND9 DNS Server"
printAndLogMessage "STOP bind9 - DNS server"
systemctl stop bind9.service

## write new named.conf.options file, with all parameters
/bin/bash write-etc_bind_named.conf.options.sh
## add include to /var/lib/samba/bind-dns/named.conf
/bin/bash change-etc_bind_named.conf.local.sh
## uncomment in /var/lib/samba/bind-dns/named.conf
## database "dlopen /usr/lib/x86_64-linux-gnu/samba/bind9/dlz_bind9_12.so";
/bin/bash change-var_lib_samba_bind_dns_named.conf.sh

printAndLogMessage "START bind9 - DNS server"
systemctl start bind9.service
systemctl status bind9.service

printAndLogMessage "UMASK, START & ENABLE samba-ad-dc"
systemctl unmask samba-ad-dc
systemctl start samba-ad-dc
systemctl enable samba-ad-dc

## CREATE REVERSE LOOK UP in DNS
printAndLogMessage "CREATE REVERSE LOOK UP in DNS"
/bin/bash create-dns_reverse_zone.sh

## ADD CERTIFICATES TO DOMAIN CONTROLLER
printAndLogMessage  "ADD CERTIFICATES TO DOMAIN CONTROLLER"
/bin/bash add_tls-etc_samba_smb.conf.sh

## SIMPLE NETLOGON.BAT TO /var/lib/samba/sysvol/${SAMBA4_DNS_DOMAIN_NAME}/scripts
printAndLogMessage  "copy simple netlogon.bat to /var/lib/samba/sysvol/${SAMBA4_DNS_DOMAIN_NAME}/scripts"
cp files/netlogon.bat /var/lib/samba/sysvol/${SAMBA4_DNS_DOMAIN_NAME}/scripts

## UPGRADE NORMAL WINDOWS GROUPS TO UNIX GROUPS
printAndLogMessage  "upgrade normal windows-groups to unix-groups"
/bin/bash upgrade-normal_windowsgroups_to_unixgroups.sh

## ADD COMPUTER DOMAIN MANAGEMENT
printAndLogMessage  "add computer domain management"
/bin/bash add_domain_computer_management.sh

## ADD TSN SYNC
printAndLogMessage  "add TSN sync"
/bin/bash add_sync_to_tsn.sh

## COPY HELPER SCRIPT
printAndLogMessage "copy helperscript add_host.sh to /usr/local/sbin"
cp -v helper_scripts/add_host.sh /usr/local/sbin



printAndLogEndMessage "FINISH: INSTALLATION OF SAMBA4 AD - CONTROLLER"


