#!/bin/bash

# source helper functions
. ../helperfunctions.sh

# source configuration
. ../OPTIONS.conf

# manipulated file
file=/etc/network/interfaces

# reset original.conf.options
restoreOriginal $file

# restart network interface
ifdown eth0
ifup eth0





