#!/bin/bash

# source helper functions
. ../helperfunctions.sh

# source configuration
. ../OPTIONS.conf

restoreOriginal /etc/network/interfaces

restoreOriginal /etc/hostname
# set hostname for running system
hostname $(hostname)

restoreOriginal /etc/hosts

# restart network interface
ifdown eth0
ifup eth0





