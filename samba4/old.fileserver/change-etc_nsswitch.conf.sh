#! /bin/bash

# source helper functions
. ../helperfunctions.sh

# source configuration
. ../OPTIONS.conf


file=/etc/sssd/sssd.conf
printAndLogMessage "Manipulated file: " $file
saveFile $file
logFile $file

## use_fully_qualified_names = False
## we don not want peter@domain.com as username
##
## krb5_store_password_if_offline = False
## do not store password


printAndLogMessage "Change file: " $file
sed -e "{
	/use_fully_qualified_names/ s/use_fully_qualified_names/#use_fully_qualified_names/
}" -e "{
	/krb5_store_password_if_offline/ s/krb5_store_password_if_offline/#krb5_store_password_if_offline/
}"  -e "{
	/cache_credentials/ s/cache_credentials/#cache_credentials/
}" -e "{
	/krb5_store_password_if_offline/ s/krb5_store_password_if_offline = True/krb5_store_password_if_offline = False/
}" -e "{
	/krb5_store_password_if_offline/ s/krb5_store_password_if_offline = True/krb5_store_password_if_offline = False/
}" -e "{
	/krb5_store_password_if_offline/ s/krb5_store_password_if_offline = True/krb5_store_password_if_offline = False/
}" -i $file

logFile $file
