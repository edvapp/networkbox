#!/bin/bash

#version number 0.02

#changes:
#added bind config data
#added resolv.conf

#version number 0.03

#changes:
# changed name
# added variable for seperator and filename
# change multiple echos to one echo at beginning and commands to $(...) command substition


#todo:
#write readme

FILE_DEBUG_INFO=debugInfo.txt
SEPERATOR=----------------------------------


echo collecting all information to debug networkbox configuration
if [ -f $FILE_DEBUG_INFO ];
then
	rm $FILE_DEBUG_INFO
fi

echo "
$(date)

$SEPERATOR 
ifconfig
$(ifconfig)

$SEPERATOR
host ns01
$(host ns01)

$SEPERATOR
host dhcp01
$(host dhcp01)

$SEPERATOR
host tftp01
$(host tftp01)

$SEPERATOR
host gateway
$(host gateway)

$SEPERATOR
ping ns01
$(ping ns01 -c3)

$SEPERATOR
ping gateway
$(ping gateway -c3)

$SEPERATOR
/etc/init.d/bind9 status
$(/etc/init.d/bind9 status)

$SEPERATOR
/etc/init.d/isc-dhcp-server status
$(/etc/init.d/isc-dhcp-server status)

$SEPERATOR
service isc-dhcp-server status
$(service isc-dhcp-server status)

$SEPERATOR
/etc/init.d/tftpd-hpa status
$(/etc/init.d/tftpd-hpa status)

$SEPERATOR
" >> $FILE_DEBUG_INFO

COLLECTION_DIR=debugInfoConfigFiles
mkdir $COLLECTION_DIR

cp /etc/bind/named.conf $COLLECTION_DIR/
cp ./OPTIONS.conf $COLLECTION_DIR/
cp /etc/dhcp/dhcpd.conf $COLLECTION_DIR/
cp /etc/resolv.conf $COLLECTION_DIR/
cp -r /etc/bind  $COLLECTION_DIR/bind/
cp /var/log/syslog $COLLECTION_DIR/
tar -czf $COLLECTION_DIR.tar.gz $COLLECTION_DIR
rm -rf $COLLECTION_DIR


#useful comands

#/var/log/upstart/isc-dhcp-server.log

#tail /var/log/syslog
#welcher unterschied ist zwischen service isc-dhcp-server status und /etc/init.d/isc-dhcp-server status ?

#anleitung zum forken und git
#https://www.atlassian.com/git/tutorials/comparing-workflows/forking-workflow
#http://marklodato.github.io/visual-git-guide/index-de.html
#https://rogerdudler.github.io/git-guide/index.de.html
