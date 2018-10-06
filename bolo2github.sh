#!/usr/bin/env bash

set -e

usage="${BASH_SOURCE[0]} [-h] [-n name] [-i input] [-o output] --- update github from bolowiki

where:
	-h	show this help message
	-n  name of the repo
	-i  input
	-o  output
"

# getopts ######################################################################

# reset getopts
OPTIND=1

input='/pbrepo'
output='git@github.com:cmb-polarbear'

# get the options
while getopts "n:i:o:h" opt; do
	case "$opt" in
	n)	name="$OPTARG"
		;;
	i)	input="$OPTARG"
		;;
	o)	output="$OPTARG"
		;;
	h)	printf "$usage"
		exit 0
		;;
	*)	printf "$usage"
		exit 1
		;;
	esac
done

# helpers ##############################################################

nameWOExt="${name%.*}"
cd "$input/$name"
git push --mirror "$output/$nameWOExt.git" || (>&2 printf '%s\n' 'Cannot mirror' "$name" )
