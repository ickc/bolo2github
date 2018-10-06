#!/usr/bin/env bash

set -e

usage="${BASH_SOURCE[0]} [-h] [-n name] [-i input] [-o output] [-d dir] --- update github from bolowiki

where:
	-h	show this help message
	-n	name of the repo
	-i	input
	-o	output
	-d	directory to clone the repo
"

# getopts ######################################################################

# reset getopts
OPTIND=1

input='git@bitbucket.org'
output='git@github.com:cmb-polarbear'

# get the options
while getopts "n:i:o:d:h" opt; do
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

org="${name%/*}"
repo="${name##*.}"

cd "$dir"
git clone --bare "${input}:${name}"
cd "$repo"
git push --mirror "$output/$repo.git" || (>&2 printf '%s\n' "[FAILED] cannot mirror $name" )
