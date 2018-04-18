#!/bin/bash

# source helper functions
. ../../helperfunctions.sh

# source configuration
. ../../OPTIONS.conf

# standard schemas loaded:
# 1: core
# 2: cosine
# 3: nis
# 4: inetorgperson

# schema list comming with ldap standard
# SCHEMA_LIST="collective corba duaconf dyngroup java misc openldap ppolicy ldapns pmi"
# added schema: samba kerberos dhcp
SCHEMA_LIST="collective corba duaconf misc openldap ldapns pmi samba kerberos dhcp"

cp ./schemas/*.schema /etc/ldap/schema
cp ./schemas/*.ldif /etc/ldap/schema

for SCHEMA in ${SCHEMA_LIST[@]};
do
    printAndLogMessage "add schema $SCHEMA to cn=schema,cn=config"
    file=/etc/ldap/schema/$SCHEMA.ldif
    ldapadd -v -Y EXTERNAL -H ldapi:/// -f $file
    printAndLogMessage "added $SCHEMA to cn=schema,cn=config"
done

