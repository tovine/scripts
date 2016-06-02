#!/bin/bash
if [ "$1" == "background" ]; then
	BACKGROUND=true
fi
if ! screen -list | grep -q "rtorrent"; then
	# Fix terminal keys interfering with rTorrent
	stty stop undef;
	stty start undef;
	if $BACKGROUND; then
		echo "Starting in background"
		screen -dmS rtorrent /usr/bin/rtorrent
	else
		screen -mS rtorrent /usr/bin/rtorrent
	fi
	echo "RTorrent not running, started new session..."
else
	screen -rx rtorrent
fi
