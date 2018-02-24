#!/bin/sh

xhost +local:puppy

su puppy -c "/usr/bin/google-chrome-stable "$@" --user-data-dir=/home/puppy/chrome/user --disk-cache-dir=/home/puppy/chrome/cache --disk-cache-size=10000000 --media-cache-size=10000000 "$@""

#gksu -u puppy "/usr/bin/google-chrome-stable --user-data-dir=/home/puppy/chrome/user --disk-cache-dir=/home/puppy/chrome/cache --disk-cache-size=10000000 --media-cache-size=10000000"