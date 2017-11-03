#!/bin/sh

if [ -f /mnt/live/tmp/modules ]; then
pidconky="`ps -eo pid,cmd | grep -v grep | grep "conky -c $HOME/.conkyrc-port" | awk '{ print $1 }'`"
else
pidconky="`ps -eo pid,cmd | grep -v grep | grep "conky -c $HOME/.conkyrc-live" | awk '{ print $1 }'`"
fi

	if [ -n "$pidconky" ]; then
kill -9 $pidconky
touch ~/Desktop/u.txt; rm ~/Desktop/u.txt
	else
   if [ -f /mnt/live/tmp/modules ]; then
   conky -c ~/.conkyrc-port &
   else
   conky -c ~/.conkyrc-live &
   fi
	fi
