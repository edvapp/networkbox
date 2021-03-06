#! /bin/bash

# source helper functions
. ../helperfunctions.sh

# source configuration
. ../OPTIONS.conf

if [ ! "$FULLINSTALL" = "true" ];
then
	echo "FULLINSTALL=false"
	apt-get -y update
fi

printAndLogStartMessage "START: INSTALLATION OF AD - CLIENT"

export DEBIAN_FRONTEND=noninteractive

## check if FQDN exists in /etc/hosts
if [ $(hostname) = $(hostname --fqdn) ];
then
        /bin/bash change-FQDN-etc_hosts.sh
fi

printAndLogMessage "apt-get -y install sssd-ad sssd-tools realmd adcli samba-common krb5-user"
## krb5−user: users get a kerberos ticket
apt-get -y install sssd-ad sssd-tools realmd adcli samba-common krb5-user

## write new /etc/krb5.conf with needed rdns = false
/bin/bash write-etc_krb5.conf.sh

printAndLogMessage "join domain ${SAMBA4_REALM_DOMAIN_NAME}"
realm join -v --one-time-password=secret1234 ${SAMBA4_REALM_DOMAIN_NAME}

## stop user and password caching and id mapping
## because home dirs will served via nfs
## and absence from network will break any network login at all :-(
/bin/bash change-etc_sssd_sssd.conf.sh

printAndLogMessage "enable automatic home-directory creation"
printAndLogMessage "pam-auth-update --enable mkhomedir"
pam-auth-update --enable mkhomedir

printAndLogStartMessage "STOP: INSTALLATION OF AD - CLIENT"

