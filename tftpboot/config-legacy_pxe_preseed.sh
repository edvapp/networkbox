#!/bin/bash

# source helper functions
. ../helperfunctions.sh

# source configuration
. ../OPTIONS.conf

# "Generate MD5 - hash from clear text password with salt: mUxl"
# "save special characters / with \ => \/"
# "from http://www.grymoire.com/Unix/Sed.html"
# "original: arg=`echo "$1" | sed 's:[]\[\^\$\.\*\/]:\\\\&:g'` quotes more than one character"
PRESEED_ADMIN_ACCOUNT_PASSWORD_HASH=$(openssl passwd -1 -salt mUxl $PRESEED_ADMIN_ACCOUNT_PASSWORD | sed 's:[\/]:\\&:g')

# source /etc/default/
. /etc/default/tftpd-hpa
# to get variable $TFTP_DIRECTORY
# configured in /etc/default/tftpd-hpa

cd $TFTP_DIRECTORY/preseed
for file in $(ls);
do
	# set admin user: fullname
	sed -e "{
		/d-i passwd\/user-fullname string/ s/d-i passwd\/user-fullname string/d-i passwd\/user-fullname string $PRESEED_ADMIN_ACCOUNT_FULLNAME/
	}" -i $file
 	# set admin user: name
	sed -e "{
		/d-i passwd\/username string/ s/d-i passwd\/username string/d-i passwd\/username string $PRESEED_ADMIN_ACCOUNT_NAME/
	}" -i $file
	# set admin user: password - hash
	sed -e "{
		/d-i passwd\/user-password-crypted password/ s/d-i passwd\/user-password-crypted password/d-i passwd\/user-password-crypted password $PRESEED_ADMIN_ACCOUNT_PASSWORD_HASH/
	}" -i $file
	printAndLogMessage "Set admin fullname, name & password in preseed-file: " $TFTP_DIRECTORY/preseed/$file

done
