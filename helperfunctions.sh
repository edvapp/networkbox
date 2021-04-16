#!/bin/bash

# save file with "filename" to "filename.original"

function saveOriginal()
{
	cp $1 $1.history.$(date +%Y%m%d-%N )
	if ! [ -f $1.original ];
	then
		cp $1 $1.original
	fi
}

function restoreOriginal()
{
	if  [ -f $1.original ];
	then
		rm $1
		rm $1.history.*
		cp $1.original $1
	fi
}

function getReverseNETAndIP()
{
	_IP=$1
	_NETMASK=$2
	if [ $_NETMASK = "255.255.255.0" ];
	then
		REVERSE_NET=$(echo $_IP | awk 'BEGIN { FS = "." } { print $3"."$2"."$1 }')
		REVERSE_IP=$(echo $_IP | awk 'BEGIN { FS = "." } { print $4 }')
	elif [ $_NETMASK = "255.255.0.0" ];
	then
		REVERSE_NET=$(echo $_IP | awk 'BEGIN { FS = "." } { print $2"."$1 }')
		REVERSE_IP=$(echo $_IP | awk 'BEGIN { FS = "." } { print $4"."$3 }')
	elif [ $_NETMASK = "255.0.0.0" ];
	then
		REVERSE_NET=$(echo $_IP | awk 'BEGIN { FS = "." } { print $1 }')
		REVERSE_IP=$(echo $_IP | awk 'BEGIN { FS = "." } { print $4"."$3"."$2 }')
	fi
}

function getCIDRsubnetmask()
{
	_NETMASK=$1
	if [ $_NETMASK = "255.255.255.0" ];
	then
		CIDR_SUBNETMASK=24
	elif [ $_NETMASK = "255.255.0.0" ];
	then
		CIDR_SUBNETMASK=16
	elif [ $_NETMASK = "255.0.0.0" ];
	then
		CIDR_SUBNETMASK=8
	fi
}

function createSambaOUpath()
{
        if [ "$1" == "" ];
        then
                echo "no OU set! Nothing to do! Exit!"
                exit
        fi
        ## set seperator to ','
        IFS=','
        ## get OU as array
        INPUT_OU_ARRAY=($1)
        unset IFS
        ## array.length
        INPUT_OU_ARRAY_LENGTH=${#INPUT_OU_ARRAY[@]}
        echo "processing ${INPUT_OU_ARRAY_LENGTH} OUs"
        for ((start_of_OUs = INPUT_OU_ARRAY_LENGTH - 1; start_of_OUs >=0; start_of_OUs--));
        do
                OU_TO_CREATE=""
                for ((ou = $INPUT_OU_ARRAY_LENGTH - 1; ou >= $start_of_OUs; ou--));
                do
                        OU_TO_CREATE="${INPUT_OU_ARRAY[ou]},${OU_TO_CREATE}"
                done
                ## :: -1 we remove the last , 
                echo "creating ${OU_TO_CREATE::-1}"
                samba-tool ou create ${OU_TO_CREATE::-1}
        done
}

LOGFILE="../protokoll.log"

function printAndLogStartMessage()
{
	echo ""
	echo "#####################################################################"
	echo "#####  " $@
	echo "#####################################################################"
	echo ""

	echo ""
	echo "#####################################################################" >> $LOGFILE
	echo "##### " $@ >> $LOGFILE
	echo "#####################################################################" >> $LOGFILE
	echo "" >> $LOGFILE
}

function printAndLogMessage()
{
	echo "#####  " $@
	echo $@ >> $LOGFILE
}

function printAndLogEndMessage()
{
	echo ""
	echo "#####  " $@
	echo "#####################################################################"
	echo ""
	
	echo "" >> $LOGFILE
	echo "##### " $@ >> $LOGFILE
	echo "#####################################################################" >> $LOGFILE
	echo "" >> $LOGFILE
}

function logFile()
{
	echo "#####################################################################"
	echo "FILE: " $1
	echo ""
	cat $1
	echo ""
	echo "#####################################################################"
	
	echo "#####################################################################" >> $LOGFILE
	echo "FILE: " $1 >> $LOGFILE
	echo "" >> $LOGFILE
	cat $1 >> $LOGFILE
	echo "" >> $LOGFILE
	echo "#####################################################################" >> $LOGFILE
}

