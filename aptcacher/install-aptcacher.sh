#!/bin/bash

# install ng-apt-cacher
if [ ! "$FULLINSTALL" = "true" ];
then
	echo "FULLINSTALL=false"
	apt-get -y update
fi


printAndLogStartMessage "START: INSTALLATION OF APT-CACHER"

printAndLogMessage "apt-get -y -y install apt-cacher-ng"
apt-get -y install apt-cacher-ng

printAndLogEndMessage "FINISH: INSTALLATION OF APT_CACHER"

