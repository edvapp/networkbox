#!/bin/bash

# source helper functions
. ../../helperfunctions.sh

# source configuration
. ../../OPTIONS.conf

printAndLogMessage "All generated LDIF-files can be found in subdirectory ldap-server/cn_config/ldif"

printAndLogMessage "add admin to cn=config for external access"
/bin/bash add-admin_to_cn_config.sh

printAndLogMessage "set password for admin account for ldap-database"
/bin/bash correct-ldapadmin_passwd.sh

printAndLogMessage "add schemas to cn=schema,cn=config"
/bin/bash add-schemas_to_cn_config.sh

printAndLogMessage "add indices to cn=schema,cn=config"
/bin/bash add-indices_to_cn_config.sh

printAndLogMessage "correct acls in cn=schema,cn=config"
/bin/bash correct-acls_in_cn_config.sh

printAndLogMessage "add sycnmodule to cn=schema,cn=config"
/bin/bash add_syncmodul_to_cn_config.sh

if [ $LDAP_IS_SLAVE_SERVER = yes ];
then
    printAndLogMessage "add slave information to cn=schema,cn=config"
    /bin/bash add_replication_slave_to_cn_config.sh
fi


