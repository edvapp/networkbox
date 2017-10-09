# source helper functions
. ../../helperfunctions.sh

# source configuration
. ../../OPTIONS.conf

file=./ldif/add-ldapread_to_ldap_tree.ldif

echo "
# LDAP - Read-Object
dn: cn=ldapread,dc=$LDAP_DOMAIN_SUFFIX_FIRST,dc=$LDAP_DOMAIN_SUFFIX_SECOND
objectClass: organizationalRole
objectClass: simpleSecurityObject
objectClass: top
cn: ldapread
userPassword: {SSHA}aEm8iJxqQfAoCav2pde+u0t4b+idi7np
# nurlesen
description: object to read authentification info, replaces admin account in /etc/ldap on clients
"> $file

printAndLogMessage "add ldif to dc=$LDAP_DOMAIN_SUFFIX_FIRST,dc=$LDAP_DOMAIN_SUFFIX_SECOND database"
ldapmodify -a -D "cn=admin,dc=$LDAP_DOMAIN_SUFFIX_FIRST,dc=$LDAP_DOMAIN_SUFFIX_SECOND" -w $LDAP_DOMAIN_ADMIN_PASSWORD -f $file
