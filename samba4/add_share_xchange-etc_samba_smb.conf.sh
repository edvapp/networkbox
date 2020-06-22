#!/bin/bash

# source helper functions
. ../helperfunctions.sh

# source configuration
. ../OPTIONS.conf

## manipulated file /etc/samba/smb.conf
file=/etc/samba/smb.conf
printAndLogMessage "WRITE NEW ${file}"
printAndLogMessage "Manipulated file: " ${file}

printAndLogMessage  "STOP smbd nmbd winbind"
systemctl stop smbd nmbd winbind

printAndLogMessage "Save original file: " ${file}
saveOriginal ${file}
logFile ${file}

printAndLogMessage "Change file: " ${file}

echo "
[xchange]
    # an xchange share for testing
    path = /home/xchange/ 
    public = yes
    writable = yes
    comment = exchange share on $(hostname)
    printable = no
    guest ok = yes

" >> ${file}

logFile ${file}

printAndLogMessage  "START smbd nmbd winbind"
systemctl start smbd nmbd winbind

mkdir -p /home/xchange/

chgrp -R "${SAMBA4_DOMAIN}\Domain Users" /home/xchange/

printAndLogMessage "change mode for directory /home/xchange/"
chmod 2777 /home/xchange/




