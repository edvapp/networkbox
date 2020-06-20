#!/bin/bash

# source helper functions
. ../helperfunctions.sh

# source configuration
. ../OPTIONS.conf

# install samba4 ad controller
if [ ! "$FULLINSTALL" = "true" ];
then
	echo "FULLINSTALL=false"
	apt-get -y update
fi


printAndLogStartMessage "START: UNINSTALLATION OF SAMBA4"

export DEBIAN_FRONTEND=noninteractive

printAndLogMessage "UNINSTALL PACKAGES"
printAndLogMessage "apt-get install -y acl attr samba samba-dsdb-modules samba-vfs-modules winbind krb5-config krb5-user bind9-dnsutils ldb-tools"
## from samba - wiki: acl attr samba samba-dsdb-modules samba-vfs-modules winbind krb5-config krb5-user
## acl, attr: exteded acls
## bind9-dnsutils: dig, nslookup
## to have a look at the ldb-databases: ldb-tools
apt-get purge -y acl attr samba samba-dsdb-modules samba-vfs-modules winbind krb5-config krb5-user bind9-dnsutils ldb-tools

printAndLogMessage "create directory for users ${SAMBA4_HOMES_BASE_DIR}/users/"
rm -R ${SAMBA4_HOMES_BASE_DIR}/users/

printAndLogMessage "restore /etc/samba/smb.conf"
restoreOriginal /etc/samba/smb.conf

printAndLogMessage "remove /usr/local/samba"
rm -R /usr/local/samba

printAndLogEndMessage "FINISH:  UNINSTALLATION OF SAMBA4"


