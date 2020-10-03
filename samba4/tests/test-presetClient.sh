#!/bin/bash

# source helper functions
. ../../helperfunctions.sh

# source configuration
. ../../OPTIONS.conf

## test Users:
COMPUTER_NAME=$1
if [ "$COMPUTER_NAME" == "" ];
then
        echo "run with Client Name, e.g. r001pc04"
        exit 0
fi
echo $SAMBA4_ADMINISTRATOR_PASSWORD | adcli -v delete-computer $COMPUTER_NAME --stdin-password

echo $SAMBA4_ADMINISTRATOR_PASSWORD | adcli -v preset-computer --service-name=nfs --one-time-password=secret1234 $COMPUTER_NAME --stdin-password


