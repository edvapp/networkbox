#!/bin/bash

# source helper functions
. ../../helperfunctions.sh

# source configuration
. ../../OPTIONS.conf

file=./ldif/encrease_max_for_queries_in_DOMAIN_database.ldif

echo "
# encrease max limit for queries in DOMAIN database
dn: olcDatabase={1}mdb,cn=config
changeType: modify
add: olcSizeLimit
olcSizeLimit: 5000

" > $file

printAndLogMessage "add ldif to cn=config database"
ldapadd -v -Y EXTERNAL -H ldapi:/// -f $file
