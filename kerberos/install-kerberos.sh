#!/bin/bash

# source helper functions
. ../helperfunctions.sh

# source configuration
. ../OPTIONS.conf

# create some variables, to keep commands shorter
DIT="dc=$LDAP_DOMAIN_SUFFIX_FIRST,dc=$LDAP_DOMAIN_SUFFIX_SECOND"
KRB5_DIT="cn=$REALM_CONTAINER,$DIT"
LDAPADMIN="cn=admin,$DIT"


# install kerberos-server
if [ ! "$FULLINSTALL" = "true" ];
then
	echo "FULLINSTALL=false"
	apt-get -y update
fi

printAndLogStartMessage "START: INSTALLATION OF MIT-KERBEROS - SERVER"

export DEBIAN_FRONTEND=noninteractive

if [ ! -d /etc/ldap/slapd.d ];
then
    printAndLogMessage "INSTALL LDAP- BACKEND FOR KERBEROS"
    cd ../ldap-server
    /bin/bash install-slapd.sh
    cd ../kerberos
fi

printAndLogMessage "apt-get -y install krb5-kdc krb5-admin-server krb5-kdc-ldap"
apt-get -y install krb5-kdc krb5-admin-server krb5-kdc-ldap

printAndLogMessage "WRITE KRB5 CONFIGURATION in /etc/krb5.conf"
/bin/bash write-etc_krb5.conf.sh

printAndLogMessage "CREATE REALM IN LDAP-TREE $DIT"
kdb5_ldap_util -D $LDAPADMIN -w $LDAP_DOMAIN_ADMIN_PASSWORD create -subtrees $KRB5_DIT -r $REALM_DOMAIN_NAME -s -H ldap://localhost

# Create a stash of the password used to bind to the LDAP server. 
# This password is used by the ldap_kdc_dn and ldap_kadmin_dn options in /etc/krb5.conf:
printAndLogMessage "CREATE PASSWORD STASH TO CONNECT KRB5 TO LDAP"

kdb5_ldap_util -D $LDAPADMIN -w $LDAP_DOMAIN_ADMIN_PASSWORD stashsrvpw -f /etc/krb5kdc/service.keyfile $LDAPADMIN

printAndLogMessage "CREATE TESTUSERS IN REALM"
/bin/bash create-TestUsers.sh

printAndLogEndMessage "FINISH: INSTALLATION OF MIT-KERBEROS - SERVER"
