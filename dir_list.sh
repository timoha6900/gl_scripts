#!/bin/bash

#if [ $1 = "-r" ] 2> /dev/null; then
#	ls -F | grep "./" | head -n 5 | sort -r
#else
#	ls -F | grep "./" | head -n 5
#fi

usage="Print first 5 catalogues in current directory.

Where:
	-r  	reverse sort
	--help  call help\n"

case "$1" in
	--help)
		printf "$usage"
		;;
	-r)
		ls -F | grep "./" | head -n 5 | sort -r
	   	;;
	*)
		if [ -z $1 ]; then
			ls -F | grep "./" | head -n 5
		else
			echo "Illegal argument $1. Please use --help."
		fi
		;;
esac

