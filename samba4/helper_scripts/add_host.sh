#!/bin/bash

## USAGE:
## add_host.sh HOSTNAME COMPUTEROU IP CREATOR PASSWORD
##
## Example:
## add_host.sh HOSTNAME COMPUTEROU                       IP         CREATOR       PASSWORD
## add_host.sh r213pc50 OU=hosts,OU=701036,DC=BRG,DC=TSN 10.2.13.50 Administrator Passw0rd
##
## ATTENTION:
## 1. has to run on the activ directory domain controller, because we use ldbmodify to modify directory
##
## 2. CREATOR has to have rights on the DNS - Server
##    Machines can be joined by an user, which has rights on COMPUTEROU Container
##
## 3. COMPUTEROU must already exist
##
## 4. REVERSE_IP calculation is just done for network 10.0.0.0/8

AD_HOSTNAME=$(hostname)

HOSTNAME=$1
COMPUTEROU=$2
IP=$3
CREATOR=$4
PASSWORD=$5

echo "create host ${HOSTNAME} with IP: ${IP} in ${COMPUTEROU}"
samba-tool computer create ${HOSTNAME} --computerou=${COMPUTEROU} --description=${HOSTNAME} --ip-address=${IP} --username=${CREATOR} --password=${PASSWORD}

echo "nfs service principal added"
DOMAIN_SUFFIX=$(samba-tool domain info ${AD_HOSTNAME} | grep Domain | awk '{print $NF}')
samba-tool spn add nfs/${HOSTNAME}.${DOMAIN_SUFFIX} ${HOSTNAME}$ --username=${CREATOR} --password=${PASSWORD}
samba-tool spn add nfs/${HOSTNAME^^} ${HOSTNAME}$ --username=${CREATOR} --password=${PASSWORD}

echo "add host ${HOSTNAME} to DNS reverse zone"
REVERSE_IP=$(echo $IP | awk 'BEGIN { FS = "." } { print $4"."$3"."$2 }')
samba-tool dns add ${AD_HOSTNAME} 10.in-addr.arpa ${REVERSE_IP} PTR ${HOSTNAME}.${DOMAIN_SUFFIX} --username=${CREATOR} --password=${PASSWORD}

echo "add uidNumber to machine account"
## we need 10 digits 
## we repace the first IP tripplet with 2
## and check the second to stay beyond 147 because 2^31-1 = 2 147 483 647 :-(
## 10.3.45.231 -> 2 003 045 231 -> 1003045231

CHECK=$(echo $IP | awk 'BEGIN { FS = "." } { print $2 }')
if (( $CHECK > 147 ));
then
        echo "IP can maximal be 10.147.ddd.ddd, for Info please read OPTIONS.conf"
        exit
fi

UID_NUMBER=$(echo $IP | awk 'BEGIN { FS = "." } { printf "1%.3d%.3d%.3d", $2, $3, $4 }')
echo "
dn: CN=${HOSTNAME},${COMPUTEROU}
changetype: modify
add: uidNumber
uidNumber: ${UID_NUMBER}
" > /tmp/${HOSTNAME}.ldif

ldbmodify -H /var/lib/samba/private/sam.ldb /tmp/${HOSTNAME}.ldif --user=${CREATOR} --password=${PASSWORD}



