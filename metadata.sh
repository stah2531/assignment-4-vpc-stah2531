#!/bin/bash

# Assign variables
ACTION=${1:-u}
version=0.5.0

# Check if user is root
if ! [ $(id -u) = 0 ]; then
	echo "The script needs to be run as root." >&2
	exit 1
fi

function display_usage() {
cat << EOF
Usage: ${0} {-c|--create|-h|--help|-v|--version}
EOF
}

function create() {
curl -s http://169.254.169.254/latest/dynamic/instance-identity/document/ >backend1-identity.json

curl -vs https://s3.amazonaws.com/seis665/message.json 2>&1 | tee backend1-message.txt

cp /var/log/nginx/access.log .
}

function display_help() {
cat << EOF
Usage: ${0} {-c|--create|-h|--help|-v|--version}

OPTIONS:
	no arguments	Display usage information
	-c | --create	Create backend1-identity.json, backend1-message.txt files
			and copy nginx log into present working directory
	-h | --help	Display the command help
	-v | --version	Display the script version

Examples:
	Display usage information:
		$ ${0}
	Create and move files:
		$ ${0} -c
	Display help:
		$ ${0} -h
	Display version:
		$ ${0} -v

EOF
}

function display_version() {
echo $version
}

case "$ACTION" in
	-c|--create)
		create
		;;
	-h|--help)
		display_help
		;;
	-u)
		display_usage
		;;
	-v|--version)
		display_version
		;;
	*)
	echo "Usage ${0} {-c|--create|-h|--help|-v|--version}"
	exit 1
esac
