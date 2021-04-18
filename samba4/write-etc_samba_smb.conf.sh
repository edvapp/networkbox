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
[global]
   workgroup = ${SAMBA4_DOMAIN}
   security = ADS
   realm = ${SAMBA4_REALM_DOMAIN_NAME}

   winbind refresh tickets = Yes
   vfs objects = acl_xattr
   map acl inherit = Yes
   store dos attributes = Yes
   
   # Setting the default back end is mandatory.
   # Default ID mapping configuration for local BUILTIN accounts
   # and groups on a domain member. The default (*) domain:
   # - must not overlap with any domain ID mapping configuration!
   # - must use a read-write-enabled back end, such as tdb.
   idmap config * : backend = tdb
   idmap config * : range = 3000-7999
   
   # - You must set a DOMAIN backend configuration
   # idmap config for the ${SAMBA4_DOMAIN} domain
   idmap config ${SAMBA4_DOMAIN} : backend = ad
   idmap config ${SAMBA4_DOMAIN} : schema_mode = rfc2307
   # we have to avoid the internal used range: 3 000 0000 - 4 000 000 
   # and start with    5 000 000
   # and end with: 2 147 483 647 = 2^31 - 1
   # for uids created from IPs: 10.3.12.105 -> 2 003 012 105 have to stay beyond 10.147. !
   # https://wiki.samba.org/index.php/Setting_up_Samba_as_a_Domain_Member
   idmap config ${SAMBA4_DOMAIN} : range = 5000000-2147483647
   idmap config ${SAMBA4_DOMAIN} : unix_nss_info = yes
   idmap config ${SAMBA4_DOMAIN} : unix_primary_group = yes

   # If you are creating a new smb.conf on an unjoined machine and add these lines, 
   # a keytab will be created during the join:
   dedicated keytab file = /etc/krb5.keytab
   kerberos method = secrets and keytab
   
   # To disable printing completely, add these lines:
   load printers = no
   printing = bsd
   printcap name = /dev/null
   disable spoolss = yes
   
[users]
    # .../users IS a standard for MS Windows 
    path = ${SAMBA4_HOMES_BASE_DIR}/
    read only = no
    force create mode = 0600
    force directory mode = 0700

" > ${file}

logFile ${file}

printAndLogMessage  "START smbd nmbd winbind"
systemctl start smbd nmbd winbind



