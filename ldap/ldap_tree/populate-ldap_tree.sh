#!/bin/bash

# source helper functions
. ../../helperfunctions.sh

# source configuration
. ../../OPTIONS.conf

printAndLogMessage "add ldapread - object with password "nurlesen" to LDAP - tree"
/bin/bash add-ldapread_to_ldap_tree.sh



