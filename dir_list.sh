#!/bin/bash

usage="Print first 5 catalogues in current directory.

Use dir_list.sh <arg>
Where <arg>:
	-r  	reverse sort
	--help  call help
or nothing\n"

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

