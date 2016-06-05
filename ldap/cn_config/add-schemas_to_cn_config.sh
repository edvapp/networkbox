#!/bin/bash

# source helper functions
. ../../helperfunctions.sh

# source configuration
. ../../OPTIONS.conf


printAndLogMessage "add schema samba to cn=schema,cn=config"

file=./schemas/samba.ldif

ldapadd -v -Y EXTERNAL -H ldapi:/// -f $file

printAndLogMessage "add schema kerberos to cn=schema,cn=config"

file=./schemas/kerberos.ldif

ldapadd -v -Y EXTERNAL -H ldapi:/// -f $file

printAndLogMessage "add schema dhcp to cn=schema,cn=config"

file=./schemas/dhcp.ldif

ldapadd -v -Y EXTERNAL -H ldapi:/// -f $file

