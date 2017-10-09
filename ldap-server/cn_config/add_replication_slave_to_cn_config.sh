#!/bin/bash

# source helper functions
. ../../helperfunctions.sh

# source configuration
. ../../OPTIONS.conf

# 
file=./ldif/add_replication_to_cn_config.ldif

echo "
# activate LDAP -tree replication
dn: olcDatabase={1}mdb,cn=config
changetype: modify
add: olcSyncrepl
olcSyncrepl: {0}rid=2 provider=ldap://10.100.100.193
  type=refreshOnly
  bindmethod=simple
  binddn="cn=ldapsync,dc=$LDAP_DOMAIN_SUFFIX_FIRST,dc=$LDAP_DOMAIN_SUFFIX_SECOND"
  credentials=$LDAP_SYNC_PASSWORD
  interval="00:00:03:00"
  retry="30 10 300 +"
  timeout=1
  tls_reqcert=never
  schemachecking=off
  searchbase="dc=$LDAP_DOMAIN_SUFFIX_FIRST,dc=$LDAP_DOMAIN_SUFFIX_SECOND"

# Konfigurationsreplikation aktivieren
dn: olcDatabase={0}config,cn=config
changetype: modify
add: olcSyncrepl
olcSyncrepl: {0}rid=1 provider=ldap://10.100.100.193
  type=refreshOnly
  bindmethod=simple
  binddn="cn=ldapsync,dc=$LDAP_DOMAIN_SUFFIX_FIRST,dc=$LDAP_DOMAIN_SUFFIX_SECOND"
  credentials=$LDAP_SYNC_PASSWORD
  interval="00:00:03:00"
  retry="30 10 300 +"
  timeout=1
  tls_reqcert=never
  schemachecking=off
  searchbase="cn=config"
" > $file

printAndLogMessage "add ldif to cn=config database"
ldapadd -v -Y EXTERNAL -H ldapi:/// -f $file
