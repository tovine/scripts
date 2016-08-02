#!/bin/bash
if [ "$1" == "background" ]; then
	START_IN_BACKGROUND=true
else
	unset START_IN_BACKGROUD
fi
if ! screen -list | grep -q "irssi"; then
	if [ $START_IN_BACKGROUND ]; then
		echo "Starting in background"
		screen -dmS irssi /usr/bin/irssi
	else
		screen -mS irssi /usr/bin/irssi
	fi
	echo "Irssi not running, started new session..."
elif [ ! $START_IN_BACKGROUND ]; then
	screen -rx irssi
fi
