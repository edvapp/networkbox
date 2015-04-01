#!/bin/bash

# install ng-apt-cacher
if [ ! "$FULLINSTALL" = "true" ];
then
	echo "FULLINSTALL=false"
	apt-get -y update
fi
apt-get -y install apt-cacher-ng 
