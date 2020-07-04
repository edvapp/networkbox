#!/bin/bash

# source helper functions
. ../helperfunctions.sh

# source configuration
. ../OPTIONS.conf

# manipulated directory
NETWORKBOX_LAUS_DIR=/opt/autoinstall/laus/scriptsForClasses/NETWORKBOX
printAndLogMessage "Manipulated directory " $NETWORKBOX_LAUS_DIR

printAndLogMessage "mkdir " $NETWORKBOX_LAUS_DIR
mkdir $NETWORKBOX_LAUS_DIR

printAndLogMessage "cp /opt/autoinstall/laus/scriptsForClasses/INSTALL_U2004/010-update.sh " $NETWORKBOX_LAUS_DIR
cp /opt/autoinstall/laus/scriptsForClasses/INSTALL_U2004/010-update.sh $NETWORKBOX_LAUS_DIR

printAndLogMessage "cp /opt/autoinstall/laus/scriptsForClasses/INSTALL_U2004/020-install_UBUNTU_Desktop.sh " $NETWORKBOX_LAUS_DIR
cp /opt/autoinstall/laus/scriptsForClasses/INSTALL_U2004/020-install_UBUNTU_Desktop.sh $NETWORKBOX_LAUS_DIR
