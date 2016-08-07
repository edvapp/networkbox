#!/bin/bash

# source helper functions
. ../helperfunctions.sh

# source configuration
. ../OPTIONS.conf

# install ldap - server

apt-get -y purge slapd ldap-utils

rm cn_config/ldif/*.ldif

rm -R /etc/ldap/schema