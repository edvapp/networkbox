#!/bin/bash

# source helper functions
. ../helperfunctions.sh

# source configuration
. ../OPTIONS.conf

# create some variables, to keep commands shorter
DIT="dc=$LDAP_DOMAIN_SUFFIX_FIRST,dc=$LDAP_DOMAIN_SUFFIX_SECOND"
KRB5_DIT="cn=$REALM_CONTAINER,$DIT"
LDAPADMIN="cn=admin,$DIT"

# manipulated file
file=./testuser.ldif

echo "

# TestUser

dn: ou=testUsers,$KRB5_DIT
objectClass: top
objectClass: organizationalUnit
ou: users

# Test User Nr. 1
dn: uid=tu1,ou=testUsers,$KRB5_DIT
objectClass: top
objectClass: person
objectClass: organizationalPerson
objectClass: inetOrgPerson
objectClass: posixAccount
objectClass: shadowAccount
objectClass: sambaSamAccount
cn: tu1
displayName: tu1
gecos: Test User Nr. 1
gidNumber: 513
givenName: tu1
homeDirectory: /home/testusers/tu1
loginShell: /bin/bash
sambaAcctFlags: [UX]
sambaLogonScript: logon.cmd
sambaHomeDrive: H:
sambaKickoffTime: 2147483647
sambaLMPassword: B757BF5C0D87772FAAD3B435B51404EE
sambaLogoffTime: 2147483647
sambaLogonTime: 0
sambaNTPassword: 7CE21F17C0AEE7FB9CEBA532D0546AD6
sambaPrimaryGroupSID: S-1-5-21-1234567890-1234567890-123456789-513
sambaProfilePath: \\smb01\tu1\.win7profil
sambaPwdCanChange: 0
sambaPwdLastSet: 1312471667
sambaPwdMustChange: 1316359667
sambaSID: S-1-5-21-1234567890-1234567890-123456789-3201
shadowLastChange: 15190
shadowMax: 30000
sn: tu1
uid: tu1
uidNumber: 3201
userPassword: {SSHA}dx0sCgNBPlx98eRYnun1QBNfrWUR6qM1
# 1234

# Test User Nr. 2
dn: uid=tu2,ou=testUsers,$KRB5_DIT
objectClass: top
objectClass: person
objectClass: organizationalPerson
objectClass: inetOrgPerson
objectClass: posixAccount
objectClass: shadowAccount
objectClass: sambaSamAccount
cn: tu2
displayName: tu2
gecos: Test User Nr. 2
gidNumber: 513
givenName: tu2
homeDirectory: /home/testusers/tu2
loginShell: /bin/bash
sambaAcctFlags: [UX]
sambaLogonScript: logon.cmd
sambaHomeDrive: H:
sambaKickoffTime: 2147483647
sambaLMPassword: B757BF5C0D87772FAAD3B435B51404EE
sambaLogoffTime: 2147483647
sambaLogonTime: 0
sambaNTPassword: 7CE21F17C0AEE7FB9CEBA532D0546AD6
sambaPrimaryGroupSID: S-1-5-21-1234567890-1234567890-123456789-513
sambaProfilePath: \\smb01\tu2\.win7profil
sambaPwdCanChange: 0
sambaPwdLastSet: 1312471667
sambaPwdMustChange: 1316359667
sambaSID: S-1-5-21-1234567890-1234567890-123456789-3202
shadowLastChange: 15190
shadowMax: 30000
sn: tu2
uid: tu2
uidNumber: 3202
userPassword: {SSHA}dx0sCgNBPlx98eRYnun1QBNfrWUR6qM1
# 1234


# Test User Nr. 3
dn: uid=tu3,ou=testUsers,$KRB5_DIT
objectClass: top
objectClass: person
objectClass: organizationalPerson
objectClass: inetOrgPerson
objectClass: posixAccount
objectClass: shadowAccount
objectClass: sambaSamAccount
cn: tu3
displayName: tu3
gecos: Test User Nr. 3 no Password
gidNumber: 513
givenName: tu3
homeDirectory: /home/testusers/tu3
loginShell: /bin/bash
sambaAcctFlags: [NUX]
sambaLogonScript: logon.cmd
sambaHomeDrive: H:
sambaKickoffTime: 2147483647
sambaLMPassword: B757BF5C0D87772FAAD3B435B51404EE
sambaLogoffTime: 2147483647
sambaLogonTime: 0
sambaNTPassword: 7CE21F17C0AEE7FB9CEBA532D0546AD6
sambaPrimaryGroupSID: S-1-5-21-1234567890-1234567890-123456789-513
sambaProfilePath: \\smb01\tu3\.win7profil
sambaPwdCanChange: 0
sambaPwdLastSet: 1312471667
sambaPwdMustChange: 1316359667
sambaSID: S-1-5-21-1234567890-1234567890-123456789-3203
shadowLastChange: 15190
shadowMax: 30000
sn: tu3
uid: tu3
uidNumber: 3203
userPassword: {SSHA}dx0sCgNBPlx98eRYnun1QBNfrWUR6qM1
# 1234


" > $file

ldapmodify -a -D "cn=admin,dc=$LDAP_DOMAIN_SUFFIX_FIRST,dc=$LDAP_DOMAIN_SUFFIX_SECOND" -w $LDAP_DOMAIN_ADMIN_PASSWORD -f $file

rm $file