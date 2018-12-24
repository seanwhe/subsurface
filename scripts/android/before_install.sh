#!/bin/bash

# Travis only pulls shallow repos. But that messes with git describe.
# Sorry Travis, fetching the whole thing and the tags as well...
git fetch --unshallow
git pull --tags
git describe

# setup build dir on the host, not inside of the container
mkdir -p ../subsurface-mobile-build-arm

# this uses a custom built Ubuntu image that includes Qt for Android and
# Android NDK/SDK
# Running sleep to keep the container running during the build
PARENT="$( cd .. && pwd )"
docker run -v $PWD:/android/subsurface \
	   -v $PARENT/subsurface-mobile-build-arm:/android/subsurface-mobile-build-arm \
	   --name=builder \
	   -w /android \
	   -d dirkhh/android-builder:5.12.01 \
	   /bin/sleep 60m
