#!/usr/bin/env bash
## (c) 2017 by Mick Hohmann - last changed: 2017-04-17 14:55
#
## initialize variables
SCRIPTNAME=$(basename --suffix=.sh "$0")
LOCKFILE="/var/lock/${SCRIPTNAME}.lock"
SET_USER="mick"
SET_GROUP="staff"
BASIC_DIRECTORIES=(/media/documents /media/downloads /media/music /media/pictures /media/sites /media/sources /media/videos)
EXEC_DIRECTORIES=(/media/documents/systems/config/ /media/downloads/ /media/sources/)

## if called with any version of help or any other argument
if [ "$1" = "help" ] || [ "$1" = "-h" ] || [ "$1" = "--help" ] || [ $# -ne 0 ]; then
	echo -e "Sets ownership and permissions of directories and files to fixed values (from the script)"
	echo -e "Usage: '$(basename "$0")'"
	false
## else set ownership and permissions
else
	## check already running script with 'flock'
	set -e
	exec 9>"$LOCKFILE"
	flock --nonblock 9 || exit 1

	## recursively set ownership and permissions
	for i_DEFAULT in "${BASIC_DIRECTORIES[@]}"; do
		chown -R "$SET_USER":"$SET_GROUP" "$i_DEFAULT"
		find "$i_DEFAULT" -type d -exec chmod 775 "{}" +
		find "$i_DEFAULT" -type f -exec chmod 664 "{}" +
	done
	## give back the execbit to executables
	for i_EXECBIT in "${EXEC_DIRECTORIES[@]}"; do
		find "$i_EXECBIT" \( -iname "*.py" -o -iname "*.js" -o -iname "*.sh" -o -iname "*.fish" -o -iname "*.bash" \) -exec chmod a+x "{}" +
	done
fi
#EOF.
