#!/bin/bash

# source helper functions
. ../helperfunctions.sh

# source configuration
. ../OPTIONS.conf

# manipulated directory
directory=/etc/dhcp

printAndLogMessage "new GIT directory " $directory

# manipulated file
file=dhcpd.conf

printAndLogMessage "Manipulated file: " $directory/$file

printAndLogMessage "Save original file: " $directory/$file
saveOriginal $directory/$file
logFile $directory/$file

rm $directory/$file

cd $directory

printAndLogMessage "git init in $directory"
git init

printAndLogMessage "config user.name $DHCP_GIT_USER_NAME"
git config user.name "$DHCP_GIT_USER_NAME"

printAndLogMessage "config user.email $DHCP_GIT_USER_NAME"
git config user.email "$DHCP_GIT_USER_EMAIL"

printAndLogMessage "git remote add origin $DHCP_GIT_REPOSITORY"
git remote add origin "$DHCP_GIT_REPOSITORY"
git remote -v

printAndLogMessage "pull new: " $file
git pull origin master

#printAndLogMessage "create .gitignore"
#ls -1 >> $directory/.gitignore
#sed -e "{
#	/$file/d
#}" -i .gitignore

logFile $directory/$file