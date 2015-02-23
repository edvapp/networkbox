#!/bin/bash

# save file with "filename" to "filename.original"

saveOriginal()
{
	cp $1 $1.history.$(date +%Y%m%d-%N)
	if ! [ -f $1.original ];
	then
		cp $1 $1.original
	fi
}

restoreOriginal()
{
	if  [ -f $1.original ];
	then
		rm $1
		cp $1.original $1
	fi
}

