#!/bin/sh

/usr/bin/google-chrome-stable --user-data-dir=/root/chrome/user --disk-cache-dir="/root/chrome/cache" --disk-cache-size=10000000 --media-cache-size=10000000 --no-sandbox --disable-infobars "$@"
