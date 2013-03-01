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
	date=`date +%Y%m%d%H%M%S`
	SS_AUTH_URL=$1
	PORT=""
	# PORT=":8080"
	AUTH="/auth/v1.0"
	SS_AUTH_USER=$2
	SS_AUTH_KEY=$3
	SS_COMMAND=$4

}

function checks()
{
	echo "Number of parms: $#"
	if [ $# == "0" ]; then  
		echo "Usage: $0 Swiftstack URL, account:user and key, [swift command]"
		exit 1
	fi
	ping -c 2 $1
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
	swift list
}

init
checks
set_envs
# stat

