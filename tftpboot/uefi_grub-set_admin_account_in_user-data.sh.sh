#!/bin/bash

# source helper functions
. ../helperfunctions.sh

# source configuration
. ../OPTIONS.conf

# "Generate MD5 - hash from clear text password with salt: mUxl"
# "save special characters / with \ => \/"
# "from http://www.grymoire.com/Unix/Sed.html"
# "original: arg=`echo "$1" | sed 's:[]\[\^\$\.\*\/]:\\\\&:g'` quotes more than one character"
ADMIN_ACCOUNT_PASSWORD_HASH=$(openssl passwd -1 -salt mUxl ${ADMIN_ACCOUNT_PASSWORD} | sed 's:[\/]:\\&:g')

cd ${HTTP_ISO_YAML_LAUS_DIR}\2P1F2F
for file in $(ls);
do
	# set admin user: realname
	sed -e "{
		/realname:/ s/realname:/realname: ${ADMIN_ACCOUNT_FULLNAME}/
	}" -i $file
 	# set admin user: name
	sed -e "{
		/username:/ s/username:/username: ${ADMIN_ACCOUNT_NAME}/
	}" -i $file
	# set admin user: password - hash
	sed -e "{
		/password:/ s/password:/password: ${ADMIN_ACCOUNT_PASSWORD_HASH}/
	}" -i $file
	printAndLogMessage "Set admin realname, name & password in user-data: " ${HTTP_ISO_YAML_LAUS_DIR}/2P1F2F/${file}
done

cd ${HTTP_ISO_YAML_LAUS_DIR}\2P1F
for file in $(ls);
do
	# set admin user: realname
	sed -e "{
		/realname:/ s/realname:/realname: ${ADMIN_ACCOUNT_FULLNAME}/
	}" -i $file
 	# set admin user: name
	sed -e "{
		/username:/ s/username:/username: ${ADMIN_ACCOUNT_NAME}/
	}" -i $file
	# set admin user: password - hash
	sed -e "{
		/password:/ s/password:/password: ${ADMIN_ACCOUNT_PASSWORD_HASH}/
	}" -i $file
	printAndLogMessage "Set admin realname, name & password in user-data: " ${HTTP_ISO_YAML_LAUS_DIR}/2P1F/${file}
done
