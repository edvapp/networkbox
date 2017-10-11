#!/bin/bash

# source helper functions
. ../../helperfunctions.sh

# source configuration
. ../../OPTIONS.conf


printAndLogMessage "create ssha hash for $LDAP_CN_CONFIG_ADMIN_NAME"
# version for sed to save / for s ///
#CN_CONFIG_ADMIN_PASSWORD_HASH=$(slappasswd -h {SSHA} -s $CN_CONFIG_ADMIN_PASSWORD | sed 's:[\/]:\\&:g')
LDAP_CN_CONFIG_ADMIN_PASSWORD_HASH=$(slappasswd -h {SSHA} -s $LDAP_CN_CONFIG_ADMIN_PASSWORD)

# set olcRootDN: and olcRootPW: 
file=./ldif/add-admin_to_cn_config.ldif

echo "
###########################################################
# REMOTE CONFIGURATION DEFAULTS
###########################################################
# Some defaults need to be added in order to allow remote 
# access by DN cn=$LDAP_CN_CONFIG_ADMIN_NAME,cn=config to the LDAP config 
# database. Otherwise only local root will 
# administrative access.

dn: olcDatabase={0}config,cn=config
changetype: modify
add: olcRootDN
olcRootDN: cn=$LDAP_CN_CONFIG_ADMIN_NAME,cn=config

dn: olcDatabase={0}config,cn=config
changetype: modify
add: olcRootPW
olcRootPW: $LDAP_CN_CONFIG_ADMIN_PASSWORD_HASH
" > $file

printAndLogMessage "add ldif to cn=config database"
ldapadd -v -Y EXTERNAL -H ldapi:/// -f $file
