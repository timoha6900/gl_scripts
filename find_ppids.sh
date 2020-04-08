#!/bin/bash

# Help message
usage="Print all PPIDs of current PID.

Use find_ppids.sh <arg>
Where <arg>:
	<pid>  	PID if current proccess. Must be a number
	--help  call help\n"


# Script variables
c_pid=$1
cc_pid=0
er_out=tmp_err
re='^[0-9]+$'

# Argument validation function
function validation {
	if [ -z $c_pid ]; then
		echo "Missing argument. Please call --help."
		exit
	else
		if [ "$c_pid" = "--help" ]; then
			printf "$usage"
			exit
		else
			if ! [[ $c_pid =~ $re ]] ; then
				echo "Invalid argument $c_pid. Please call --help."
				exit
			fi
		fi
	fi
}

# Function check stderr and print PPID if all rights.
function error_check {
	if [ "$(cat $er_out)" = "" ]; then
		echo $cc_pid
		c_pid=$cc_pid
	else
		exit
	fi
}



validation

# Create temp file for stderr
touch $er_out

while [ $c_pid -ne 0 ]; do
	if [ "$(ps -p $c_pid | grep $c_pid)" != "" ]; then
		cc_pid=$(ps -o ppid= $c_pid 2>"$er_out")
		error_check
	else
		echo "Proccess with PID $c_pid is not running"
		exit
	fi
done

# Remove temp file
rm -rf $er_out
