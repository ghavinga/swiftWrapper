#!/bin/bash
# Script to simplify SwiftStack storage access and querying.
#
# Version 0.1
#
# Needs 
# 1) Authentication URL
# 2) Key/password
# 3) swift command
#

function init()
{
	# Must pass on script parameters explicitly 
	#
	date=`date +%Y%m%d%H%M%S`
	echo "Number of parms: $#"
	SS_AUTH_ADDRESS=$1
	METHOD="http://"
	PORT=""
	# export PORT=":8080"
	AUTH="/auth/v1.0"
	SS_AUTH_USER=$2
	SS_AUTH_KEY=$3
	SS_COMMAND=$4
	SS_AUTH_URL=$METHOD$SS_AUTH_ADDRESS$PORT$AUTH
}

function checks()
{
	echo "Number of parms: $#"
	if [ -z "$SS_AUTH_ADDRESS" ]; then 
	       	SS_AUTH_ADDRESS="10.0.0.38"
		SS_AUTH_URL=$METHOD$SS_AUTH_ADDRESS$PORT$AUTH
		echo "No Swiftstack URL specified, substituting with $SS_AUTH_URL"
	fi
	if [ -z "$SS_AUTH_USER" ]; then
		SS_AUTH_USER="dev:gerry"
		echo "No swiftstack account:user specified, substituing with $SS_AUTH_USER"
	fi
	if [ -z "$SS_AUTH_KEY" ] ; then
		SS_AUTH_KEY="password"
		echo "No SwiftStack key / password specified, using default."
	fi
	echo "Checking network availability to Swiftstack API URL address:"
	ping -c 2 $SS_AUTH_ADDRESS
}

function set_envs()
{
 	export ST_AUTH=$SS_AUTH_URL$PORT$AUTH
	export ST_USER=$SS_AUTH_USER
	export ST_KEY=$SS_AUTH_KEY
}

function stat()
{
	echo "Trying stat command on $1."
  	swift stat
}

function list() 
{
	echo "Listin of account container for $SS_AUTH_USER:"
	swift list
}

function multi_stat() 
{
	listArray=( $(swift list) )
	# echo ${listArray[@]}
	echo "Number of containers for this account: ${#listArray[*]}"
	for (( i = 0 ; i < ${#listArray[*]} ; i++ ))
	do
	    echo "Content off: ${listArray[$i]}"
	    swift stat ${listArray[$i]}
	    echo "- - - - - - - - - - - - - - - - - - - - - "
    	done
}

function multi_list() 
{
	listArray=( $(swift list) )
	# echo ${listArray[@]}
	echo "Number of containers for this account: ${#listArray[*]}"
	for (( i = 0 ; i < ${#listArray[*]} ; i++ ))
	do
	    echo "Content off: ${listArray[$i]}"
	    swift list ${listArray[$i]}
	    echo "- - - - - - - - - - - - - - - - - - - - - "
    	done
}

function choose_command()
{
	echo "Possible swift commands: s - stat on root container, t - multiple (if available)"
	echo "stat listing on each container found in root, l - listing on root container"
	echo "m - multiple (if available) listing on each container found in root."
	echo
	read -p "What swift command would you like to execute [stlm]?" stlm
	case $stlm in
		[Ss]* ) stat; return;;
		[Tt]* ) multi_stat; return;;
		[Ll]* ) list; return;;
		[Mm]* ) multi_list; return;;
		* ) echo "Please answer s, t, l or m.";;
	esac
}


init $1 $2 $3 $4
checks  
set_envs
# stat
# list
# multi_list
choose_command

