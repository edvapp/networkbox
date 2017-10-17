#!/bin/bash

# source helper functions
. ../../helperfunctions.sh

# source configuration
. ../../OPTIONS.conf

# set olcRootDN: and olcRootPW: 
file=./ldif/disable-write_to_DOMAIN_database_for_slave.ldif

echo "
# disable password change for users
dn: olcDatabase={1}mdb,cn=config
changeType: modify
delete: olcAccess
olcAccess: {3}
-
add: olcAccess
olcAccess: {3}to attrs=userPassword,shadowLastChange,krbPrincipalKey,sambaNTPassword,sambaLMPassword by anonymous auth by self read by * none

" > $file

printAndLogMessage "add ldif to cn=config database"
ldapadd -v -Y EXTERNAL -H ldapi:/// -f $file
