#!/usr/bin/env bash
## (c) 2017 by Mick Hohmann - last changed: 2017-04-16 09:45
#
## initialize variables
SCRIPTNAME=$(basename --suffix=.sh $0)
LOCKFILE="/var/lock/${SCRIPTNAME}.lock"
SEARCH_DIRECTORIES=(/media/documents /media/downloads /media/music /media/pictures /media/sites /media/sources /media/videos)
CLEAN_DATA=(.AppleDouble .DS_store "._*" "._.*" desktop.ini Thumbs.db)

## if called with any version of help, print out usage
if [ "$1" = "help" -o "$1" = "-h" -o "$1" = "--help" ]; then
	echo -e "Removes the following additional files used by macOS and Windows:\n"
	echo -e "	"${CLEAN_DATA[@]}
	echo -e "\nUsage: '$(basename $0) directory directory …'"
	echo -e "If no directory is provided, the defaults from the script will be used."
	false
## else remove the data of Windows and macOS systems
else
	## check already running script with 'flock'
	set -e
	exec 9>$LOCKFILE
	flock --nonblock 9 || exit 1

	## if there are any commandline arguments use them instead of the defaults
	if [ $# -ne 0 ]; then
		SEARCH_DIRECTORIES=("$@")
	fi

	## recursively clean
	for i_SEARCH in "${SEARCH_DIRECTORIES[@]}"; do
		for i_CLEAN in "${CLEAN_DATA[@]}"; do
			find $i_SEARCH -iname $i_CLEAN -delete
		done
	done
fi
#EOF.
