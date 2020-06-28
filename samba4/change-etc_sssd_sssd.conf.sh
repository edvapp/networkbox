#! /bin/bash

# source helper functions
. ../helperfunctions.sh

# source configuration
. ../OPTIONS.conf


file=/etc/sssd/sssd.conf
printAndLogMessage "Manipulated file: " $file
saveFile $file
logFile $file

## all set back to standard:
##
## use_fully_qualified_names = False
## we don not want peter@domain.com as username
##
## krb5_store_password_if_offline = False
## do not store password
##
## cache_credentials = False
## do not store user credentials
##
## ldap_id_mapping = False
## use UID ad GID from AD-Controller
## if users on AD do NOT have these attributes 
## set to True and they will get domain comprehensive UIDs and GIDs


printAndLogMessage "Change file: " $file
sed -e "{
	/use_fully_qualified_names/ s/use_fully_qualified_names/#use_fully_qualified_names/
}" -e "{
	/krb5_store_password_if_offline/ s/krb5_store_password_if_offline/#krb5_store_password_if_offline/
}"  -e "{
	/cache_credentials/ s/cache_credentials/#cache_credentials/
}" -e "{
	/ldap_id_mapping/ s/ldap_id_mapping/#ldap_id_mapping/
}" -i $file

logFile $file

printAndLogMessage "restart sssd daemon"
systemctl restart sssd
