echo Setting Current Time...
net time \\ad01 /set /yes

#  Here we map network drives 

echo Mapping Network Drives
net use X: \\SMB01\xchange
net use H: \\SMB01\users\%username%
