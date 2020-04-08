#!/bin/bash

usage="Print all PPIDs of current PID.

Use find_ppids.sh <arg>
Where <arg>:
	<pid>  	PID if current proccess. Must be a number
	--help  call help\n"

re='^[0-9]+$'
if [ -z $1 ]; then
	echo "Missing argument. Please call --help."
	exit
else
	if [ "$1" = "--help" ]; then
		printf "$usage"
		exit
	else
		if ! [[ $1 =~ $re ]] ; then
			echo "Invalid argument $1. Please call --help."
			exit
		fi
	fi
fi

c_pid=$1
cc_pid=0
er_out=tmp_err
err=""

touch $er_out

while [ "$err" = "" ]; do
	cc_pid=$(ps -o ppid= $c_pid 2>"$er_out")
	err=$(cat $er_out)
	if [ "$err" = "" ]; then
		echo $cc_pid
		c_pid=$cc_pid
	fi
done

rm -rf $er_out
