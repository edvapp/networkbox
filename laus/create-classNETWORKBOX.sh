#!/bin/bash

# source helper functions
. ../helperfunctions.sh

# source configuration
. ../OPTIONS.conf

# manipulated directory
networkbox=/opt/autoinstall/laus/scriptsForClasses/NETWORKBOX
printAndLogMessage "Manipulated directory " $networkbox

printAndLogMessage "mkdir " $networkbox
mkdir $networkbox

printAndLogMessage "cp /opt/autoinstall/laus/scriptsForClasses/UBUNTU1404/020-installUbuntuDesktop.sh " $networkbox
printAndLogMessage "cp /opt/autoinstall/laus/scriptsForClasses/UBUNTU1404/030-installLibreOffice.sh " $networkbox
cp /opt/autoinstall/laus/scriptsForClasses/UBUNTU1404/020-installUbuntuDesktop.sh $networkbox
cp /opt/autoinstall/laus/scriptsForClasses/UBUNTU1404/030-installLibreOffice.sh $networkbox