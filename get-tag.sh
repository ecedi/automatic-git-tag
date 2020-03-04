#!/bin/bash

# This script should be executed after a commit (.git/hooks/post-commit) or in a CI.

# Semantic Versioning 2.0.0 guideline https://semver.org/
# 
# Given a version number MAJOR.MINOR.PATCH, increment the:
# MAJOR version when you make incompatible API changes,
# MINOR version when you add functionality in a backwards-compatible manner, and
# PATCH version when you make backwards-compatible bug fixes.

# Value to use if no tags found
INITIAL_VERSION="0.1.0"

#get highest tags across all branches, not just the current branch
VERSION=`git describe --tags $(git rev-list --tags --max-count=1)`

if [ "$VERSION" = "" ]; then
    echo "No version tag found... Starting with $INITIAL_VERSION !"
    # split into array
    VERSION_BITS=($(echo "$INITIAL_VERSION" | tr '.' '\n'))
else
    echo "Latest version tag: $VERSION"
    # split into array
    VERSION_BITS=($(echo "$VERSION" | tr '.' '\n'))
fi

#get number parts and increase last one by 1
VNUM1=${VERSION_BITS[0]}
VNUM2=${VERSION_BITS[1]}
VNUM3=${VERSION_BITS[2]}

while getopts "u:" opt
do
    case $opt in
        u) echo "Starting taging process based on -u parameter"
        if [ $OPTARG = "breaking" ] || [ $OPTARG = "major" ]; then
            VNUM1=$((VNUM1+1)) 
            VNUM2=0
            VNUM3=0
        fi
        if [ $OPTARG = "feature" ] || [ $OPTARG = "minor" ]; then
            VNUM2=$((VNUM2+1)) 
            VNUM3=0
        fi
        if [ $OPTARG = "fix" ] || [ $OPTARG = "patch" ]; then
            VNUM3=$((VNUM3+1)) 
        fi
        ;;
    esac
done

#create new tag
NEW_TAG="$VNUM1.$VNUM2.$VNUM3"

echo $NEW_TAG
