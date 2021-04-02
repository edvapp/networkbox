#!/bin/bash

# source helper functions
. ../helperfunctions.sh

# source configuration
. ../OPTIONS.conf

# manipulated file
file=/etc/bind/named.conf.options
printAndLogMessage "Manipulated file: " $file

printAndLogMessage "Save original file: " $file
saveOriginal $file
logFile $file

printAndLogMessage "Write to file: " $file

## we get CIDR subnetmask in variable ${CIDR_SUBNETMASK}
getCIDRsubnetmask $NETMASK

echo "
// Managing acls
acl internals { 127.0.0.0/8; ${NETWORK}/${CIDR_SUBNETMASK}; };

options {
      directory \"/var/cache/bind\";
      version \"Go Away 0.0.7\";
      notify no;
      empty-zones-enable no;
      auth-nxdomain yes;
      forwarders { 8.8.8.8; 8.8.4.4; };
      allow-transfer { none; };

      dnssec-validation no;
      // not nesessary any more
      // dnssec-enable no;
      // not nesessary any more
      // dnssec-lookaside no;

      // If you only use IPv4. 
      listen-on-v6 { none; };
      // listen on these ipnumbers. 
      listen-on port 53 { ${STATIC_IP}; 127.0.0.1; ::1; };

      // Added Per Debian buster Bind9. 
      // Due to : resolver: info: resolver priming query complete messages in the logs. 
      // See: https://gitlab.isc.org/isc-projects/bind9/commit/4a827494618e776a78b413d863bc23badd14ea42
      minimal-responses yes;

      //  Add any subnets or hosts you want to allow to use this DNS server
      allow-query { \"internals\";  };
      allow-query-cache { \"internals\"; };

      //  Add any subnets or hosts you want to allow to use recursive queries
      recursion yes;
      allow-recursion {  \"internals\"; };

      // https://wiki.samba.org/index.php/Dns-backend_bind
      // DNS dynamic updates via Kerberos (optional, but recommended)
      // ONE of the following lines should be enabled AFTER you provision or join a DC with bind9_dlz 
      // or AFTER upgrading your dns from internal to bind9_dlz 
      // Before Samba 4.9.0
      // tkey-gssapi-keytab \"/var/lib/samba/private/dns.keytab\";
      // From Samba 4.9.0 ( You will need to run samba_dnsupgrade if upgrading your Samba version. ) 
      tkey-gssapi-keytab \"/var/lib/samba/bind-dns/dns.keytab\";

  };
" > $file

logFile $file

