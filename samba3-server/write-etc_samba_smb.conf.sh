#!/bin/bash

# source helper functions
. ../helperfunctions.sh

# source configuration
. ../OPTIONS.conf


# manipulated file
file=/etc/samba/smb.conf

printAndLogMessage "Save original file: " $file
saveOriginal $file
logFile $file

rm $file

printAndLogMessage "Write new: " $file

echo "
#======================= Global Settings =======================

[global]
    workgroup = $SAMBA3_WORKGROUP
    # be carefull $SAMBA3_NETBIOS_NAME has to be the hostname
    netbios name = $SAMBA3_NETBIOS_NAME

    domain master = yes
    ### next 3 options:
    ### samba wins all elections to become
    ### domain master browser
    preferred master = yes
    local master = yes
    os level = 255

    wins support = yes
    dns proxy = yes

    time server = yes
    domain logons = yes
    server string = %h
    
    # unix extensions = yes # standard
    name resolve order = lmhosts host wins bcast

####### Networking #######

    
####### Debugging/Accounting #######

    log file = /var/log/samba/log.%m
    max log size = 1000
    syslog = 0
    panic action = /usr/share/samba/panic-action %d
    # support for the Windows privilege mode
    enable privileges = yes

####### LDAP Settings #######

    passdb backend = ldapsam:ldap://$SAMBA3_LDAP_SERVER
    ldap suffix = dc=$LDAP_DOMAIN_SUFFIX_FIRST,dc=$LDAP_DOMAIN_SUFFIX_SECOND
    ldap user suffix = ou=users
    ldap group suffix = ou=groups 
    ldap machine suffix = ou=hosts
    ldap admin dn = cn=admin,dc=$LDAP_DOMAIN_SUFFIX_FIRST,dc=$LDAP_DOMAIN_SUFFIX_SECOND
    # 'smbpasswd -w passwd'
    ldap ssl = off

####### Authentication #######

    security = user

    ## pam configuration
    # samba will pass pam modules auth
    encrypt passwords = true
    # nessesary for pam - stack modules: account session
    # pam_mkhomedir.so will not work with
    # without obey pam restrictions = yes
    obey pam restrictions = yes

    # should be defaults, WAS NOT!!
    # for LibreOffice 4.1; LibreOffice 3.6 has been working without (not perfektly testet!)
    kernel oplocks = no
    oplocks = yes

    null passwords = yes
    ldap passwd sync = yes
    map to guest = bad user

########## Domains ###########


########## Printing ##########
    # stop error messages in /var/log/samba/*
    load printers = no
    printing = bsd
    printcap name = /dev/null
    disable spoolss = yes


############ Misc ############


#======================= Share Definitions =======================

[homes]
    comment = home
    browseable = no
    read only = no
    create mask = 0700
    directory mask = 0700
    # show Vollzugriff on Windows Client
    acl map full control = yes
    hide dot files = yes
    valid users = %S


[netlogon]
    comment = Network Logon Service
    path = /home/samba/netlogon
    write list = 
    guest ok = yes
    read only = yes


[programmes]
    comment = Programme
    path = /home/samba/shares/programmes
    write list = 
    read only = yes
    

[lehrmaterial]
    comment = Lehrmaterial
    path = /home/samba/shares/lehrmaterial
    read only = no
    force create mode = 0775
    force directory mode = 0775
    write list = 
    # show Vollzugriff on Windows Client
    acl map full control = yes


[schueler]
    comment = Schüler & Lehrer
    path = /home/samba/shares/schueler
    read only = no
    guest ok = yes
    force create mode = 0777
    force directory mode = 0777
    # show Vollzugriff on Windows Client
    acl map full control = yes

" >> $file

logFile $file
