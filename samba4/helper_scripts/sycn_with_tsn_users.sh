#!/bin/bash

## check, if there are homedirs with NO user-accounts in AD
/bin/bash ./check-for_unused_homedirs.sh

## check, if there are user-accounts in AD with NO homedir
/bin/bash ./check-for_missing_homedirs.sh

