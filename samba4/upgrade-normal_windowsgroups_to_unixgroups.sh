#!/bin/bash

# source helper functions
. ../helperfunctions.sh

# source configuration
. ../OPTIONS.conf


## Info from:
## https://docs.microsoft.com/en-us/troubleshoot/windows-server/identity/security-identifiers-in-windows
##
## https://wiki.samba.org/index.php/Administer_Unix_Attributes_in_AD_using_samba-tool_and_ldb-tools
## but we just add the gidNumber

printAndLogMessage "add gidNumber S-1-5-21domain-512 Domain Admins"
## A global group whose members are authorized to administer the domain. 
## By default, the Domain Admins group is a member of the Administrators group on all computers that have joined a domain, 
## including the domain controllers. Domain Admins is the default owner of any object that is created by any member of the group.
## GID = 4 294 966 512
echo "
dn: CN=Domain Admins,CN=Users,${SAMBA4_ROOT_DN}
changetype: modify
add: gidNumber
gidNumber: 4294966512
" > /tmp/Domain_Admins_Group.ldif

ldbmodify -H /var/lib/samba/private/sam.ldb /tmp/Domain_Admins_Group.ldif --user=Administrator --password=${SAMBA4_ADMINISTRATOR_PASSWORD}


printAndLogMessage "add gidNumber S-1-5-21domain-513  Domain Users"
## A global group that, by default, includes all user accounts in a domain. When you create a user account in a domain, it's added to this group by default.
## GID = 4 294 966 513
echo "
dn: CN=Domain Users,CN=Users,${SAMBA4_ROOT_DN}
changetype: modify
add: gidNumber
gidNumber: 4294966513
" > /tmp/Domain_Users_Group.ldif

ldbmodify -H /var/lib/samba/private/sam.ldb /tmp/Domain_Users_Group.ldif --user=Administrator --password=${SAMBA4_ADMINISTRATOR_PASSWORD}


printAndLogMessage "add gidNumber S-1-5-21domain-514 Domain Guests"
## A global group that, by default, has only one member, the domain's built-in Guest account.
## GID = 4 294 966 514
echo "
dn: CN=Domain Guests,CN=Users,${SAMBA4_ROOT_DN}
changetype: modify
add: gidNumber
gidNumber: 4294966514
" > /tmp/Domain_Guests_Group.ldif

ldbmodify -H /var/lib/samba/private/sam.ldb /tmp/Domain_Guests_Group.ldif --user=Administrator --password=${SAMBA4_ADMINISTRATOR_PASSWORD}


printAndLogMessage "add gidNumber S-1-5-21domain-515 Domain Computers"	
## A global group that includes all clients and servers that have joined the domain.
## GID = 4 294 966 515
echo "
dn: CN=Domain Computers,CN=Users,${SAMBA4_ROOT_DN}
changetype: modify
add: gidNumber
gidNumber: 4294966515
" > /tmp/Domain_Computers_Group.ldif

ldbmodify -H /var/lib/samba/private/sam.ldb /tmp/Domain_Computers_Group.ldif --user=Administrator --password=${SAMBA4_ADMINISTRATOR_PASSWORD}


printAndLogMessage "add gidNumber S-1-5-21domain-516 Domain Controllers"	
## A global group that includes all domain controllers in the domain. New domain controllers are added to this group by default.
## GID = 4 294 966 516
echo "
dn: CN=Domain Controllers,CN=Users,${SAMBA4_ROOT_DN}
changetype: modify
add: gidNumber
gidNumber: 4294966516
" > /tmp/Domain_Controllers_Group.ldif

ldbmodify -H /var/lib/samba/private/sam.ldb /tmp/Domain_Controllers_Group.ldif --user=Administrator --password=${SAMBA4_ADMINISTRATOR_PASSWORD}


