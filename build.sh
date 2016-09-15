#!/bin/bash
set -e

#REQUIRED: get SNAP-BINARY RELEASE from other server
SNAP_ARCHIVE="snap-4.0.tar.gz"
SNAP_ARCHIVE_LOC="asam_hu@cvfeeder:/users/asam_hu/fmask/snap-4.0.tar.gz"
DOCKER_IMG_TAG="opus-test08.eoc.dlr.de:5000/s2-fmask:fmask0.4.2-snap4.0-v0.1"

if [ ! -d "app/snap-4.0" ]; then
	mkdir app/snap-4.0
	scp $SNAP_ARCHIVE_LOC app/
	tar -xvzf app/$SNAP_ARCHIVE -C app/snap-4.0
	rm app/$SNAP_ARCHIVE
fi

#BUILD
docker build -t $DOCKER_IMG_TAG .

