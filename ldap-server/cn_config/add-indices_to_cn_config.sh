#!/bin/bash

# source helper functions
. ../../helperfunctions.sh

# source configuration
. ../../OPTIONS.conf

# set olcRootDN: and olcRootPW: 
file=./ldif/add-indices_to_cn_config.ldif

echo "
# samba... for SAMBA Fileserver
# krb.... for KERBEROS Server
# entry.. for REPLICATION to backup LDAP Servers
#
dn: olcDatabase={1}mdb,cn=config
changetype: modify
add: olcDbIndex
olcDbIndex: sambaSID eq
olcDbIndex: sambaPrimaryGroupSID eq
olcDbIndex: sambaGroupType eq
olcDbIndex: sambaSIDList eq
olcDbIndex: sambaDomainName eq
olcDbIndex: krbPrincipalName eq,pres,sub
olcDbIndex: uniqueMember eq
olcDbIndex: entryUUID,entryCSN eq
olcDbIndex: default sub
" > $file

printAndLogMessage "add ldif to cn=config database"
ldapadd -v -Y EXTERNAL -H ldapi:/// -f $file
