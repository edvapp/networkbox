#!/bin/bash

# source helper functions
. ../helperfunctions.sh

# source configuration
. ../OPTIONS.conf

# manipulated directory
directory=/etc/bind

printAndLogMessage "new GIT directory " $directory

cd $directory

printAndLogMessage "git init in $directory"
git init

printAndLogMessage "config user.name $DNS_GIT_USER_NAME"
git config user.name "$DNS_GIT_USER_NAME"

printAndLogMessage "config user.email $DNS_GIT_USER_NAME"
git config user.email "$DNS_GIT_USER_EMAIL"

printAndLogMessage "git remote add origin $DNS_GIT_REPOSITORY"
git remote add origin "$DNS_GIT_REPOSITORY"
git remote -v

printAndLogMessage "pull db for lookup"
git pull origin master

#printAndLogMessage "create .gitignore"
#ls -1 >> $directory/.gitignore
#sed -e "{
#	/$file/d
#}" -i .gitignore
