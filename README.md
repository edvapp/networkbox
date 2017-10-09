# N E T W O R K B O X
Open Source Linux Network out of the Box

## Introduction
This repository contains a couple of scripts, which will set up an easy Linux (Ubuntu) network.

You will be able to control different groups of clients, distinguished by their hostname.. 

## You need:

### 1. Network:
1.1 physical:

concrete:

- cables	we want to boot with tftp.
- control	we want to control our own unique dhcp – server.

or

1.2 virtual:

hint:

Virtualbox with:

pfsense (https://www.pfsense.org/) with 2 connections
- nat 
- internal network (this is the place, where you build your networkbox)

and 2 snapshots for easy switching dhcp on/off
- dhcp ON in iternal network (for easy startup)
- dhcp OFF in internal network (when your dhcp server is runnig)

a virtual network:

### 2. Two "normal" computers.
- a server and
- one lonely :-) client.

### 3. A bit of interest in:
- servers, to understand what you are doing
- scripting, if you like to have full control and all possibilities of linux.

## You will get

An automatic installed network with one server and as many automatic installed clients as you like.
On your server you will find following services:

### 1.DNS - nameserver:
- name & ip resolution
- dns forwarding

### 2. DHCP - server:
- serving ip's
- serving location of boot images

### 3. TFTP - server:
- serving boot images

### 4. APT-CACHER:
- caching all dpkg – packages for client installation

### 5. NFS - server
- serving nfs4 shares over the network
- needed by LAUS - server

### 5. LAUS - server: (https://github.com/edvapp/autoinstall)
a collection of bash - scripts, which:
- finishing installation and
    - installing all programms not in ubuntu-minimal
    - installing a standard user
    - turn PC into an ldap-client
- installing printers for different groups of hosts.
- and all other configuration stuff 
    - enable clone screens on PCs with beamer
    - enable turn internet off if testee users log in

and run on every system start.

### 6. LDAP server
LDAP - directory with basic installation:
- admin user for config tree
- admin user for your data tree
- ldapread user to read ldap-tree for client authentication (therefor no root password needed on the clients :-)
- ldapsync user to replicate to backup ldap-server

### 7. KERBEROS - server:
- basic installation into LDAP, just to make it running (mistake in ubuntu server docu) and see how it works :-| 

### 8. SAMBA - file server
- SAMBA - server with connection to LDAP - Server, these meens has to be an 
- LDAP - Client

- worker	for sudo work on the clients
- manager	to manage a “read only” share
- user		the standard user for everybody

### 9. OWNCLOUD/NEXTCLOUD -server
Your own cloud :-) using:
- SQL - server
- SQL - database
- WEBSERVER

ATTENTION:

Nearly all installation stuff is done, EXCEPT:
- fix your domain/IP:

    'trusted_domains' =>
    array (
        'demo.example.org',
        'otherdomain.example.org',
    ),
    
  
in /var/html/owncloud-nextcloud/config/config.php


