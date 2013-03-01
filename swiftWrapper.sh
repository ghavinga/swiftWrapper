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
	swift list
}

init $1 $2 $3 $4
checks  
set_envs
stat
list

