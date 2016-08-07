#!/bin/bash

# source helper functions
. ../helperfunctions.sh

# source configuration
. ../OPTIONS.conf

# create some variables, to keep commands shorter
DIT="dc=$LDAP_DOMAIN_SUFFIX_FIRST,dc=$LDAP_DOMAIN_SUFFIX_SECOND"
KRB5_DIT="cn=$REALM_CONTAINER,$DIT"
LDAPADMIN="cn=admin,$DIT"


# install samba3-server
if [ ! "$FULLINSTALL" = "true" ];
then
	echo "FULLINSTALL=false"
	apt-get -y update
fi

printAndLogStartMessage "START: INSTALLATION OF SAMBA-3 - SERVER"

export DEBIAN_FRONTEND=noninteractive

if [ ! -d /etc/ldap/slapd.d ];
then
    printAndLogMessage "INSTALL LDAP- BACKEND FOR SAMBA-3"
    cd ../ldap-server
    /bin/bash install-slapd.sh
    cd ../samba3-server
fi

grep pam_ldap.so  /etc/pam.d/common-session
if [ $? -ne 0  ];
then
    printAndLogMessage "INSTALL LDAP- CLIENT FOR SAMBA-3"
    cd ../ldap-client
    /bin/bash install-ldap_client.sh
    cd ../samba3-server
fi


printAndLogMessage "apt-get -y install samba"
apt-get -y install samba

printAndLogMessage "stop smbd.service nmbd.service"
systemctl stop smbd.service
systemctl stop nmbd.service

printAndLogMessage "WRITE SAMBA3 CONFIGURATION in /etc/samba/smb.conf"
/bin/bash write-etc_samba_smb.conf.sh

printAndLogMessage "start smbd.service nmbd.service"
systemctl start smbd.service
systemctl start nmbd.service

printAndLogMessage "GIVE LDAP - ADMIN PASSWORD TO SAMBA-3"
smbpasswd -w $LDAP_DOMAIN_ADMIN_PASSWORD

printAndLogEndMessage "FINISH: INSTALLATION OF SAMBA-3 - SERVER"
