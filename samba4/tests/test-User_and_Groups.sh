#!/bin/bash

# source helper functions
. ../helperfunctions.sh

# source configuration
. ../OPTIONS.conf

## test Users:
echo "TEST ALL USERS"
getent passwd
echo "TEST DOMAIN USERS"
wbinfo -u

## test Groups
echo "TEST ALL GROUPS"
getent group
echo "TEST DOMAIN GROUPS"
wbinfo -g
