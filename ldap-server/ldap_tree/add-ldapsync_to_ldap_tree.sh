# source helper functions
. ../../helperfunctions.sh

# source configuration
. ../../OPTIONS.conf

file=./ldif/add-ldapsync_to_ldap_tree.ldif

printAndLogMessage "create ssha hash for ldap:ldapsync"
# version for sed to save / for s ///
#LDAP_DOMAIN_ADMIN_PASSWORD_HASH=$(slappasswd -h {SSHA} -s $LDAP_DOMAIN_ADMIN_PASSWORD | sed 's:[\/]:\\&:g')
LDAP_SYNC_PASSWORD_HASH=$(slappasswd -h {SSHA} -s $LDAP_SYNC_PASSWORD)

echo "
# LDAP - SyncUser-Object
dn: cn=ldapsync,dc=$LDAP_DOMAIN_SUFFIX_FIRST,dc=$LDAP_DOMAIN_SUFFIX_SECOND
objectClass: organizationalRole
objectClass: simpleSecurityObject
objectClass: top
cn: ldapsync
userPassword: $LDAP_SYNC_PASSWORD_HASH
description: object to read LDAP - Tree, for backup LDAP - server to sync tree
"> $file

printAndLogMessage "add ldif to dc=$LDAP_DOMAIN_SUFFIX_FIRST,dc=$LDAP_DOMAIN_SUFFIX_SECOND database"
ldapmodify -a -D "cn=admin,dc=$LDAP_DOMAIN_SUFFIX_FIRST,dc=$LDAP_DOMAIN_SUFFIX_SECOND" -w $LDAP_DOMAIN_ADMIN_PASSWORD -f $file
