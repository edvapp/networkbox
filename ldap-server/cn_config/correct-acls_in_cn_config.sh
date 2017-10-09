#!/bin/bash

# source helper functions
. ../../helperfunctions.sh

# source configuration
. ../../OPTIONS.conf

# set olcRootDN: and olcRootPW: 
file=./ldif/correct-acls_in_cn_config.ldif

echo "
## standard acls
# olcAccess: {0}to attrs=userPassword by self write by anonymous auth by * none
# olcAccess: {1}to attrs=shadowLastChange by self write by * read
# olcAccess: {2}to * by * read

# Correct acls

# delete old acls
dn: olcDatabase={1}mdb,cn=config
changeType: modify
delete: olcAccess

#### IDEA/KONCEPT ####
# {0}: ldapread has to read shadowLastChange, otherwise a passwordchange is forced.
# {1}: allow authenification to passwords, but only admin may read, unsecure ldapread is NOT allowed to read passwords.
# {2}: allow ldapread to read the rest of the ldaptree, to get group info for example.
#      Maybe access can be restricted for ldapread even more, but hard to find out and test :-(

# needed, otherwise passworchange forced
dn: olcDatabase={1}mdb,cn=config
changeType: modify
add: olcAccess
olcAccess: {0}to attrs=shadowLastChange by dn="cn=ldapread,dc=$LDAP_DOMAIN_SUFFIX_FIRST,dc=$LDAP_DOMAIN_SUFFIX_SECOND" read

# makes auth possible
dn: olcDatabase={1}mdb,cn=config
changeType: modify
add: olcAccess
olcAccess: {1}to attrs=userPassword,shadowLastChange,krbPrincipalKey,sambaNTPassword,sambaLMPassword by anonymous auth by self write by dn="cn=admin,dc=$LDAP_DOMAIN_SUFFIX_FIRST,dc=$LDAP_DOMAIN_SUFFIX_SECOND" write by * none

# make everything else read, writeable
dn: olcDatabase={1}mdb,cn=config
changeType: modify
add: olcAccess
olcAccess: {2}to * by dn="cn=ldapread,dc=$LDAP_DOMAIN_SUFFIX_FIRST,dc=$LDAP_DOMAIN_SUFFIX_SECOND" read by dn="cn=admin,dc=$LDAP_DOMAIN_SUFFIX_FIRST,dc=$LDAP_DOMAIN_SUFFIX_SECOND" write by * none

" > $file

printAndLogMessage "add ldif to cn=config database"
ldapadd -v -Y EXTERNAL -H ldapi:/// -f $file
