#! /bin/bash

# source helper functions
. ../helperfunctions.sh

# source configuration
. ../OPTIONS.conf

# https://help.ubuntu.com/community/LDAPClientAuthentication
# https://help.ubuntu.com/lts/serverguide/openldap-server.html

# has to be one line
DEBIAN_FRONTEND=noninteractive apt-get -y -q install ldap-auth-client nscd libpam-cracklib

# Nscd is a daemon that provides a cache for the most common name service requests
# pam_cracklib.so <= needed for passwordchange!!

printAndLogMessage "set new resolv order in /etc/nsswitch.conf"
/bin/bash change-etc_nsswitch.conf.sh

printAndLogMessage "add pam_mkhomedir.so to /etc/pam.d/common-session"
/bin/bash change-etc_pam.d_common_session.sh

printAndLogMessage "set our LDAP hosts and ldapread user in /etc/ldap.conf"
/bin/bash change-etc_ldap.conf.sh


systemctl restart nscd.service 

