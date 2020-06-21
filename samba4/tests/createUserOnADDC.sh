#!/bin/bash

# source helper functions
. ../../helperfunctions.sh

# source configuration
. ../../OPTIONS.conf

## create user "zuw01" with password "Passw0rd"
samba-tool user create zuw01 Passw0rd

## with assigned home-directory
samba-tool user create zuw02 Passw0rd --home-drive H: --home-directory \\\\SMB01\\users\\zuw02

## with UNIX attributes
samba-tool user create zuwl01 Passw0rd --home-drive H: --home-directory \\\\SMB01\\users\\zuwl01 --nis-domain fisc --uid zuwl01 --uid-number 11111 --login-shell /bin/bash --unix-home /home/users/zuwl01 --gid-number 2000




