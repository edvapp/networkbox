#!/bin/bash

# source helper functions
. ../../helperfunctions.sh

# source configuration
. ../../OPTIONS.conf


printAndLogMessage "add admin to cn=config for external access"
/bin/bash add-admin_to_cn_config.sh

printAndLogMessage "set password for admin account for ldap-database"
/bin/bash correct-ldapadmin_passwd.sh

printAndLogMessage "add schemas to cn=schema,cn=config"
/bin/bash add-schemas_to_cn_config.sh

printAndLogMessage "add indices to cn=schema,cn=config"
/bin/bash add-indices_to_cn_config.sh

