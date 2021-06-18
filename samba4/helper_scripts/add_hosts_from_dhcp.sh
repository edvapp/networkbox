#!/bin/bash

CREATOR="Administrator"

echo "Input Password for ${CREATOR}"
read PASSWORD

SAMBA4_ROOT_DN="DC=APP,DC=TSN"
## where to place computers
SAMBA4_TOPLEVEL_OU="OU=APP"
OU_DOMAIN_COMPUTERS_CONTAINER="OU=Computers,${SAMBA4_TOPLEVEL_OU}"

## set seperator to "end of line"
OLDIFS=${IFS}
IFS='
'

## check, if dhcp/dhcpd.conf is available

DHCP_REPOSITORY="https://github.com/edvapp/dhcp"
DHCPD_DIRECTORY="dhcp"
DHCPD_FILE="$DHCPD_DIRECTORY/dhcpd.conf"

if [ ! -d ${DHCPD_DIRECTORY} ];
then
	git clone ${DHCP_REPOSITORY}
else
	cd ${DHCPD_DIRECTORY}
	git checkout dhcpd.conf
	git pull origin master
	cd ..
fi

## store all host in an array
DHCP_HOSTARRAY=$(grep -E '^[[:space:]]+host r[[:digit:]]{3}pc[[:digit:]]{2}' ${DHCPD_FILE})

## 
for HOST in ${DHCP_HOSTARRAY[@]};
do
	# echo "processing ${HOST}"
	HOST_NAME=$(echo ${HOST} | awk '{ print $2}')
	HOST_IP=$(echo ${HOST} | awk '{ print $8}')
	## remove ";" at end of IP - string: 10.3.14.7; -> 10.3.14.7
	HOST_IP=${HOST_IP::-1}
	echo "#################################################################################"
	echo "processing ${HOST_NAME} with IP: ${HOST_IP}"
	echo "#################################################################################"
	HOST_FLOOR=${HOST_NAME:1:1}
	# echo $HOST_FLOOR
	HOST_ROOM=${HOST_NAME:1:3}
	# echo $HOST_ROOM
	## test if has to be created in AD
	samba-tool computer show ${HOST_NAME}
	if [ ! "$?" == "0" ];
	then
		echo "creating Computer ${HOST_NAME}"
		## test if container for floor has to be created
		samba-tool ou list | grep "Floor${HOST_FLOOR}"
		if [ ! "$?" == "0" ];
		then
			samba-tool ou create "OU=Floor${HOST_FLOOR},${OU_DOMAIN_COMPUTERS_CONTAINER}"
		else
			echo "OU=Floor${HOST_FLOOR},${OU_DOMAIN_COMPUTERS_CONTAINER} already exists, nothing to do :-)"
		fi
		## test if container for room has to be created
		samba-tool ou list | grep "Room${HOST_ROOM}"
		if [ ! "$?" == "0" ];
		then
			samba-tool ou create "OU=Room${HOST_ROOM},OU=Floor${HOST_FLOOR},${OU_DOMAIN_COMPUTERS_CONTAINER}"
		else
			echo "OU=Room${HOST_ROOM},OU=Floor${HOST_FLOOR},${OU_DOMAIN_COMPUTERS_CONTAINER} already exists, nothing to do :-)"
		fi
		## create host
		add_host.sh ${HOST_NAME} "OU=Room${HOST_ROOM},OU=Floor${HOST_FLOOR},${OU_DOMAIN_COMPUTERS_CONTAINER},${SAMBA4_ROOT_DN}" ${HOST_IP} ${CREATOR} ${PASSWORD}
	else
		echo "${HOST_NAME} already exists, nothing to do :-)"
	fi
	echo "#################################################################################"
	echo ""
	echo ""
	
done

