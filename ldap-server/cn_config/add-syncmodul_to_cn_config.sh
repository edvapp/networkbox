#!/bin/bash

# source helper functions
. ../../helperfunctions.sh

# source configuration
. ../../OPTIONS.conf

file=./ldif/add_syncmodul_to_cn_config.ldif

echo "
# activate Sync-Modul
dn: cn=module{0},cn=config
changetype: modify
add: olcModuleLoad
olcModuleLoad: syncprov

" > $file

printAndLogMessage "add ldif to cn=config database"
ldapadd -v -Y EXTERNAL -H ldapi:/// -f $file


