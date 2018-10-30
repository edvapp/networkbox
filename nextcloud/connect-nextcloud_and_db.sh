#!/bin/bash

# source helper functions
. ../helperfunctions.sh

# source configuration
. ../OPTIONS.conf

printAndLogMessage "Connect nextcloud with database via php occ ..."
cd /var/www/nextcloud/

if  [ "$OC_DATA_PATH" == ""  ];
then
	printAndLogMessage "no datapath for nextcloud set using default datapath"
	sudo -u www-data php occ maintenance:install --verbose --database "mysql" --database-name "$DB"  --database-user "$DB_ADMIN" --database-pass "$DB_ADMIN_PASSWORD" --admin-user "$CLOUD_ADMIN" --admin-pass "$CLOUD_ADMIN_PASSWORD"
else
	printAndLogMessage "OWN datapath $OC_DATA_PATH for nextcloud set"
	if ! [ -d $OC_DATA_PATH  ];
	then
		printAndLogMessage "create directory $OC_DATA_PATH"
		mkdir -p $OC_DATA_PATH

	fi
	printAndLogMessage "set owner and permissions for  $OC_DATA_PATH"
	chown -R www-data:www-data $OC_DATA_PATH
	chmod -R 770 $OC_DATA_PATH
	sudo -u www-data php occ maintenance:install --verbose --database "mysql" --database-name "$DB"  --database-user "$DB_ADMIN" --database-pass "$DB_ADMIN_PASSWORD" --admin-user "$CLOUD_ADMIN" --admin-pass "$CLOUD_ADMIN_PASSWORD" --data-dir "$OC_DATA_PATH"
fi
