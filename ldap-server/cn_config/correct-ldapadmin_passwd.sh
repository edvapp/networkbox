#!/bin/bash

# source helper functions
. ../../helperfunctions.sh

# source configuration
. ../../OPTIONS.conf


printAndLogMessage "create ssha hash for ldap:$LDAP_DOMAIN_ADMIN_NAME"
# version for sed to save / for s ///
#LDAP_DOMAIN_ADMIN_PASSWORD_HASH=$(slappasswd -h {SSHA} -s $LDAP_DOMAIN_ADMIN_PASSWORD | sed 's:[\/]:\\&:g')
LDAP_DOMAIN_ADMIN_PASSWORD_HASH=$(slappasswd -h {SSHA} -s $LDAP_DOMAIN_ADMIN_PASSWORD)


# set olcRootDN: and olcRootPW in cn=config: 
file=./ldif/correct-ldapadmin_passwd_in_cn_config.ldif

printAndLogMessage "write hash to $file"
echo "
# Set admin password for LDAP-database in cn=config
dn: olcDatabase={1}mdb,cn=config
changeType: modify
replace: olcRootPW
olcRootPW: $LDAP_DOMAIN_ADMIN_PASSWORD_HASH
" > $file

printAndLogMessage "add ldif to cn=config database"
ldapadd -v -Y EXTERNAL -H ldapi:/// -f $file


# set olcRootDN: and olcRootPW in ldap-database: 
file=./ldif/correct-ldapadmin_passwd_in_ldap_mdb.ldif

printAndLogMessage "write name and hash to $file"
echo "
# Set admin password for LDAP-database in dc=$LDAP_DOMAIN_SUFFIX_FIRST,dc=$LDAP_DOMAIN_SUFFIX_SECOND database
dn: cn=admin,dc=$LDAP_DOMAIN_SUFFIX_FIRST,dc=$LDAP_DOMAIN_SUFFIX_SECOND
changeType: modify
replace: userPassword
userPassword: $LDAP_DOMAIN_ADMIN_PASSWORD_HASH
" > $file

printAndLogMessage "add ldif to dc=$LDAP_DOMAIN_SUFFIX_FIRST,dc=$LDAP_DOMAIN_SUFFIX_SECOND database"
ldapmodify -D "cn=admin,dc=$LDAP_DOMAIN_SUFFIX_FIRST,dc=$LDAP_DOMAIN_SUFFIX_SECOND" -w $LDAP_DOMAIN_ADMIN_PASSWORD -f $file
