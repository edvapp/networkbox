#!/bin/bash

# source helper functions
. ../helperfunctions.sh

# source configuration
. ../OPTIONS.conf

samba-tool user create zuw01

samba-tool user create zuw02 --home-drive H: --home-directory \\\\SMB01\\users\\zuw02

samba-tool user create zuwl01 --home-drive H: --home-directory \\\\SMB01\\users\\zuwl01 --nis-domain fisc --uid zuwl01 --uid-number 11111 --login-shell /bin/bash --unix-home /home/users/zuwl01 --gid-number 2000

