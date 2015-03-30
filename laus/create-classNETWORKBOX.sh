#!/bin/bash

# source helper functions
. ../helperfunctions.sh

# source configuration
. ../OPTIONS.conf

# manipulated file
networkbox=/opt/autoinstall/laus/scriptsForClasses/NETWORKBOX

mkdir $networkbox

cp /opt/autoinstall/laus/scriptsForClasses/UBUNTU1404/020-installUbuntuDesktop.sh $networkbox
cp /opt/autoinstall/laus/scriptsForClasses/UBUNTU1404/030-installLibreOffice.sh $networkbox
