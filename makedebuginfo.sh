#!/bin/bash

#version number 0.02

#changes:
#added bind config data
#added resolv.conf

#todo:
#write readme


echo "hallo, ich trage alles zusammen um den nwb server zu checken :)"
rm debugInfo.txt
date >> debugInfo.txt

echo "----------------------------------" >> debugInfo.txt
echo ifconfig >> debugInfo.txt
ifconfig >> debugInfo.txt
echo "----------------------------------" >> debugInfo.txt
echo "host ns01" >> debugInfo.txt
host ns01 >> debugInfo.txt
echo "----------------------------------" >> debugInfo.txt
echo "host tftp01" >> debugInfo.txt
host tftp01 >> debugInfo.txt
echo "----------------------------------" >> debugInfo.txt
echo "ping 192.168.0.1" >> debugInfo.txt
ping 192.168.0.1 -c3 >> debugInfo.txt
echo "----------------------------------" >> debugInfo.txt
echo "ping 192.168.0.2" >> debugInfo.txt
ping 192.168.0.2 -c3 >> debugInfo.txt
echo "----------------------------------" >> debugInfo.txt
echo "/etc/init.d/bind9 status" >> debugInfo.txt
/etc/init.d/bind9 status >> debugInfo.txt
echo "----------------------------------" >> debugInfo.txt
echo "/etc/init.d/isc-dhcp-server status" >> debugInfo.txt
/etc/init.d/isc-dhcp-server status >> debugInfo.txt
echo "----------------------------------" >> debugInfo.txt
echo "service isc-dhcp-server status" >> debugInfo.txt
service isc-dhcp-server status >> debugInfo.txt
echo "----------------------------------" >> debugInfo.txt
echo "/etc/init.d/tftpd-hpa status" >> debugInfo.txt
/etc/init.d/tftpd-hpa status >> debugInfo.txt
echo "----------------------------------" >> debugInfo.txt
mkdir debugInfoConfigFiles
cp /etc/bind/named.conf debugInfoConfigFiles/
cp ./OPTIONS.conf debugInfoConfigFiles/
cp /etc/dhcp/dhcpd.conf debugInfoConfigFiles/
cp /etc/resolv.conf debugInfoConfigFiles/
cp -r /etc/bind  debugInfoConfigFiles/bind/
cp /var/log/syslog debugInfoConfigFiles/
tar -czf debugInfoConfigFiles.tar.gz debugInfoConfigFiles
rm -rf debugInfoConfigFiles


#useful comands

#/var/log/upstart/isc-dhcp-server.log

#tail /var/log/syslog
#welcher unterschied ist zwischen service isc-dhcp-server status und /etc/init.d/isc-dhcp-server status ?

#anleitung zum forken und git
#https://www.atlassian.com/git/tutorials/comparing-workflows/forking-workflow
#http://marklodato.github.io/visual-git-guide/index-de.html
#https://rogerdudler.github.io/git-guide/index.de.html
