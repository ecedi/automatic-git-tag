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
        if [ $OPTARG = "breaking" ||  $OPTARG = "major" ]; then
            VNUM1=$((VNUM1+1)) 
            VNUM2=0
            VNUM3=0
        fi
        if [ $OPTARG = "feature" ||  $OPTARG = "minor" ]; then
            VNUM2=$((VNUM2+1)) 
            VNUM3=0
        fi
        if [ $OPTARG = "fix" ||  $OPTARG = "patch" ]; then
            VNUM3=$((VNUM3+1)) 
        fi
        ;;
    esac
done

if [ -z $opt ]; then
    echo "Starting taging process based on commit message +semver: xxxxx"
    # Taken from gitversion
    # major-version-bump-message: '\+semver:\s?(breaking|major)'
    # minor-version-bump-message: '\+semver:\s?(feature|minor)'
    # patch-version-bump-message: '\+semver:\s?(fix|patch)'
    # get last commit message and extract the count for "semver: (major|minor|patch)"
    COUNT_OF_COMMIT_MSG_HAVE_SEMVER_MAJOR=`git log $(git describe --tags --abbrev=0)..HEAD --oneline --pretty=%B | egrep -i -c '\+semver\s?:\s?(breaking|major)'`
    COUNT_OF_COMMIT_MSG_HAVE_SEMVER_MINOR=`git log $(git describe --tags --abbrev=0)..HEAD --oneline --pretty=%B | egrep -i -c '\+semver\s?:\s?(feature|minor)'`
    COUNT_OF_COMMIT_MSG_HAVE_SEMVER_PATCH=`git log $(git describe --tags --abbrev=0)..HEAD --oneline --pretty=%B | egrep -i -c '\+semver\s?:\s?(fix|patch)'`

    if [ $COUNT_OF_COMMIT_MSG_HAVE_SEMVER_MAJOR -gt 0 ]; then
        VNUM1=$((VNUM1+1)) 
        VNUM2=0
        VNUM3=0
    fi
    if [ $COUNT_OF_COMMIT_MSG_HAVE_SEMVER_MINOR -gt 0 ]; then
        VNUM2=$((VNUM2+1)) 
        VNUM3=0
    fi
    if [ $COUNT_OF_COMMIT_MSG_HAVE_SEMVER_PATCH -gt 0 ]; then
        VNUM3=$((VNUM3+1)) 
    fi
fi

# count all commits for a branch
GIT_COMMIT_COUNT=`git rev-list --count HEAD`
echo "Commit count: $GIT_COMMIT_COUNT" 
export BUILD_NUMBER=$GIT_COMMIT_COUNT

#create new tag
NEW_TAG="$VNUM1.$VNUM2.$VNUM3"

#only tag if commit message have version-bump-message as mentioned above
if [ "$VERSION" = "" ]; then
  echo "Updating to first tag $NEW_TAG"
else
  echo "Updating $VERSION to $NEW_TAG"
fi

#only tag if commit message have version-bump-message as mentioned above
if [ $NEW_TAG != $VERSION ] || [ "$VERSION" = "" ]; then
    echo "Tagged with $NEW_TAG !"
    COMMIT_ID=`git log --format="%H" -n 1 | head -n 1`
    git tag -a "${NEW_TAG}" ${COMMIT_ID} -m "${NEW_TAG}"
else
    echo "Already a tag on this commit"
fi
