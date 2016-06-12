#!/bin/bash

# source helper functions
. ../helperfunctions.sh

# source configuration
. ../OPTIONS.conf

# create some variables, to keep commands shorter
DIT="dc=$LDAP_DOMAIN_SUFFIX_FIRST,dc=$LDAP_DOMAIN_SUFFIX_SECOND"
KRB5_DIT="cn=$REALM_CONTAINER,$DIT"
LDAPADMIN="cn=admin,$DIT"

kdb5_ldap_util -D $LDAPADMIN -w $LDAP_DOMAIN_ADMIN_PASSWORD destroy -r $REALM_DOMAIN_NAME -H ldap://localhost

apt-get -y purge krb5-kdc krb5-admin-server krb5-kdc-ldap

rm -R -f /etc/krb5kdc

