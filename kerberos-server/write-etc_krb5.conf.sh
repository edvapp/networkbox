#!/bin/bash

# source helper functions
. ../helperfunctions.sh

# source configuration
. ../OPTIONS.conf

# create some variables, to keep commands shorter
DIT="dc=$LDAP_DOMAIN_SUFFIX_FIRST,dc=$LDAP_DOMAIN_SUFFIX_SECOND"
KRB5_DIT="cn=$REALM_CONTAINER,$DIT"
LDAPADMIN="cn=admin,$DIT"

# manipulated file
file=/etc/krb5.conf
printAndLogMessage "Manipulated file: " $file

printAndLogMessage "Save original file: " $file
saveOriginal $file
logFile $file

rm $file

printAndLogMessage "Write new: " $file

echo "
[libdefaults]
#        default_realm = EXAMPLE.COM
        default_realm = $REALM_DOMAIN_NAME
        
[realms]
#        EXAMPLE.COM = {
#                kdc = kdc01.example.com
#                kdc = kdc02.example.com
#                admin_server = kdc01.example.com
#                admin_server = kdc02.example.com
#                default_domain = example.com
#                database_module = openldap_ldapconf
#        }

        $REALM_DOMAIN_NAME = {
                kdc = localhost
                kdc = kdc01.$DOMAIN_NAME
                admin_server = localhost
                admin_server = kdc01.$DOMAIN_NAME
                default_domain = $DOMAIN_NAME
                database_module = openldap_ldapconf
        }
        
[domain_realm]
#                .example.com = EXAMPLE.COM
                .$DOMAIN_NAME = $REALM_DOMAIN_NAME
        
[dbdefaults]
#        ldap_kerberos_container_dn = dc=example,dc=com
        ldap_kerberos_container_dn = $KRB5_DIT

[dbmodules]
        openldap_ldapconf = {
                db_library = kldap
#                ldap_kdc_dn = "cn=admin,dc=example,dc=com"
                ldap_kdc_dn = "$LDAPADMIN"

                # this object needs to have read rights on
                # the realm container, principal container and realm sub-trees
#                ldap_kadmind_dn = "cn=admin,dc=example,dc=com"
                ldap_kadmind_dn = "$LDAPADMIN"

                # this object needs to have read and write rights on
                # the realm container, principal container and realm sub-trees
                ldap_service_password_file = /etc/krb5kdc/service.keyfile
#                ldap_servers = ldaps://ldap01.example.com ldaps://ldap02.example.com
                ldap_servers = ldap://localhost
                ldap_conns_per_server = 5
        }
" > $file


printAndLogMessage "restart service krb5-kdc"
service krb5-kdc restart
