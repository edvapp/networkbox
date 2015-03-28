#!/bin/bash

# source helper functions
. ../helperfunctions.sh

# source configuration
. ../OPTIONS.conf

# generate MD5 - hash from clear text password with "salt" mUxl
PRESEED_ADMIN_ACCOUNT_PASSWORD_HASH=$(openssl passwd -1 -salt mUxl $PRESEED_ADMIN_ACCOUNT_PASSWORD)

for file in $(ls /var/lib/tftpboot/preseed);
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
done