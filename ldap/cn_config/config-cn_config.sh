#!/bin/bash

# source helper functions
. ../../helperfunctions.sh

# source configuration
. ../../OPTIONS.conf


printAndLogMessage "add admin to cn=config for external access"

/bin/bash add-admin_to_cn_config.sh

printAndLogMessage "set password for admin account for ldap-database"

/bin/bash correct-ldapadmin_passwd.sh
