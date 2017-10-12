#!/bin/bash

# source helper functions
. ../helperfunctions.sh

# source configuration
. ../OPTIONS.conf

# install ldap - server

# install slapd dpkg - package
if [ ! "$FULLINSTALL" = "true" ];
then
	echo "FULLINSTALL=false"
	apt-get -y update
fi

printAndLogStartMessage "START: SILENT INSTALLATION OF LDAP - SERVER"

export DEBIAN_FRONTEND=noninteractive

printAndLogMessage "CREATE FAKED /etc/hosts FILE FOR SETTING NAME OF LDAP DATABASE"
file=/etc/hosts
cp $file $file.tmp

# block host entrance, if one exists
sed -e "{
    /127.0.1.1/ s/127.0.1.1/#127.0.1.1/
}" -i $file 

# write host entrance with our LDAP suffixes
echo "127.0.1.1 $(hostname).$LDAP_DOMAIN_SUFFIX_FIRST.$LDAP_DOMAIN_SUFFIX_SECOND $(hostname)" >> $file

#sed -e "{
#    /127.0.1.1/ s/127.0.1.1/127.0.1.1 $(hostname).$LDAP_DOMAIN_SUFFIX_FIRST.$LDAP_DOMAIN_SUFFIX_SECOND $(hostname)/
#}" -i $file 

logFile $file

printAndLogMessage "apt-get install slapd ldap-utils"
apt-get -y install slapd ldap-utils

printAndLogMessage "RESTORE ORIGINAL /etc/hosts"
rm $file
mv $file.tmp $file

logFile $file

printAndLogMessage "CONFIG cn=config database"
cd cn_config
/bin/bash config-cn_config.sh
cd ..

## populating the database while replication sycn is running might break replication sync
## after sync will be the same anyway
if [ "$LDAP_IS_SLAVE_SERVER" != "yes" ];
then
	printAndLogMessage "POPULATE LDAP TREE"
	cd ldap_tree
	/bin/bash populate-ldap_tree.sh
	cd ..
fi

printAndLogEndMessage "FINISH: INSTALLATION OF LDAP - SERVER"

