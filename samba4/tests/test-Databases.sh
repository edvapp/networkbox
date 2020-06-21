#!/bin/bash

# source helper functions
. ../helperfunctions.sh

# source configuration
. ../OPTIONS.conf

# list databases
ldbsearch -H /var/lib/samba/private/sam.ldb
ldbsearch -H /var/lib/samba/private/secrets.ldb
ldbsearch -H /var/lib/samba/private/share.ldb

# look for speziall entrances
ldbsearch -H /var/lib/samba/private/sam.ldb 'CN=Administrator'


