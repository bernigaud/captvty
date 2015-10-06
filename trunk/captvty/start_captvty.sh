#!/bin/sh

set -x

xhost +local:

DOWNLOAD=/media/DATA/download/captvty
[ -d $DOWNLOAD ] || mkdir -p $DOWNLOAD
chmod 2777 $DOWNLOAD

exec docker run --rm -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix -v $DOWNLOAD:/home/luser/downloads captvty

