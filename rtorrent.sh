#!/bin/bash
if [ "$1" == "background" ]; then
	START_IN_BACKGROUND=true
else
	unset START_IN_BACKGROUD
fi
if ! screen -list | grep -q "rtorrent"; then
	if [ $START_IN_BACKGROUND ]; then
		echo "Starting in background"
		screen -dmS rtorrent /usr/bin/rtorrent
	else
		screen -mS rtorrent /usr/bin/rtorrent
	fi
	echo "RTorrent not running, started new session..."
elif [ ! $START_IN_BACKGROUND ]; then
	# Fix terminal keys interfering with rTorrent
	stty stop undef;
	stty start undef;
	screen -rx rtorrent
fi
