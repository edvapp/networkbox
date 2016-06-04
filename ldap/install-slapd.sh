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

printAndLogMessage "create faked /etc/hosts file for setting name of ldap-database"
file=/etc/hosts
cp $file $file.tmp

sed -e "{
    /127.0.1.1/ s/127.0.1.1/127.0.1.1 $(hostname).$LDAP_DOMAIN_SUFFIX_FIRST.$LDAP_DOMAIN_SUFFIX_SECOND $(hostname)/
}" -i $file 

logFile $file

printAndLogMessage "apt-get install slapd ldap-utils"
apt-get -y install slapd ldap-utils

printAndLogMessage "restore original /etc/hosts"
rm $file
mv $file.tmp $file

logFile $file

printAndLogMessage "config cn=config database"
cd cn_config
/bin/bash config-cn_config.sh
cd ..

printAndLogMessage "config ldap tree"
cd ldap_tree
/bin/bash config-ldap_tree.sh
cd ..

printAndLogEndMessage "FINISH: INSTALLATION OF LDAP - SERVER"

