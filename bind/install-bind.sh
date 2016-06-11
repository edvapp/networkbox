#!/bin/bash

# source helper functions
. ../helperfunctions.sh

# source configuration
. ../OPTIONS.conf

# install bind9 DNS dns_nameservers

# install bind9 dpkg - package
if [ ! "$FULLINSTALL" = "true" ];
then
	echo "FULLINSTALL=false"
	apt-get -y update
fi

printAndLogStartMessage "START: INSTALLATION OF DNS - SERVER"

printAndLogMessage "apt-get -y -y install bind9"
apt-get -y install bind9

service bind9 stop

printAndLogMessage "ADD DNS - SERVERS TO FORWARDERS"
/bin/bash change-etc_bind_named.conf.options.sh

printAndLogMessage "ADD ZONE-FILES FOR DOMAIN"
/bin/bash change-etc_bind_named.conf.local.sh

if [ "$DNS_GIT_REPOSITORY" = "" ];
then
    printAndLogMessage "WRITE ZONE-FILES"
    /bin/bash write-etc_bind_zonefile.sh

    printAndLogMessage "WRITE REVERSE-ZONE-FILES"
    / bin/bash write-etc_bind_reversezonefile.sh
else
    printAndLogMessage "pull DNS - db files from $DNS_GIT"
    /bin/bash pull-etc_bind_db.conf.sh
fi

service bind9 start

printAndLogEndMessage "FINISH: INSTALLATION OF DNS - SERVER"

