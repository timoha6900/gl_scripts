#!/bin/bash

# Help message
usage="Starts application by it's package name.

Use start_app.sh <arg>
Where <arg>:
	<pkg>	package name
	-list  	list of available packages on current device
	-listl	list packages that have intent ...LAUNCHER 
	--help  call help\n"

# Script variables
pkg=$1
activity_name=""
pkg_act=""
intent="android.intent.category.LAUNCHER"
pkg_list=""

#Function return list of packages
function get_pkg_list {
	pkg_list=$(adb shell 'pm list packages -f' | sed -e 's/.*=//' | sort)
}

#Function return name of activity that has intent "...LAUNCHER"
function get_act_name {
	activity_name=$(adb shell dumpsys package $pkg activities | grep -B 5 'LAUNCHER' | grep -oh "$pkg[./a-Z]*")
}

#Function print list of packages that have intent "...LAUNCHER"
function print_runnable_pkg_list {
	touch tmp_l
	printf "$pkg_list" > tmp_l
	while IFS= read -r line; do
		array+=("$line")
	done <tmp_l

	rm -rf tmp_l

	for y in "${array[@]}"; do
		pkg="$y"
		get_act_name		
		if [ "$activity_name" != "" ]; then
			echo $pkg
		fi
	done
}

# Argument validation function
function validate_arg {
	case "$pkg" in
		--help)
			printf "$usage"
			exit
			;;
		-list)
			get_pkg_list
			printf "$pkg_list"
			exit
			;;
		-listl)
			get_pkg_list
			print_runnable_pkg_list
			exit
			;;
		*)
			if [ -z $pkg ]; then
				echo "Missing argument! Please use --help."
				exit
			fi
			;;
	esac
}

#Function checks if a package exists
function validate_pkg {
	get_pkg_list
	if [ "$(printf "$pkg_list" | grep $(echo "$pkg$"))" = "" ]; then
		echo "Wrong package name. Package <'$pkg'> not found. Please use --help."
		exit
	fi
}

#Function checks if an activity exists
function validate_act {
	if [ "$activity_name" = "" ]; then
		printf "Activity not found!\nIn: '$pkg'\nWith Intent: '$intent'\n\nPlease use --help.\n"
		exit
	fi
}

validate_arg
validate_pkg

get_act_name
validate_act

adb shell am start $activity_name > /dev/null
