#!/bin/bash

# source helper functions
. ../helperfunctions.sh

# source configuration
. ../OPTIONS.conf

# manipulated file
file=/opt/autoinstall/laus/hostsToClasses

echo "
# set HOSTCLASSES variable
# check works like tftp:
# for hostname r001pc12
# test following Strings:
# #1: r001pc12
# #2: r001pc1
# #3. r001pc
# ...
# #8: r
#
# and collect all information in:
# HOSTCLASSES
#
#
# hostsToClasses in format:
# HOSTNAME:<List of Pathes>
#
# Example:
# r001pc50:UBUNTU1404 UBUNTU1404/GNOME BEAMER
# r001;R001
#
# => HOSTCLASSES for PC with hostname r001pc50: UBUNTU1404 UBUNTU1404/GNOME BEAMER R001
# 
$DHCP_HOST_1_HOSTNAME:NETWORKBOX
$DHCP_HOST_2_HOSTNAME:NETWORKBOX
" >> $file
