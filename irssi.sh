if [ "$1" == "background" ]; then
	BACKGROUND=True
fi
if ! screen -list | grep -q "irssi"; then
	if $BACKGROUND; then
		echo "Starting in background"
		screen -dmS irssi /usr/bin/irssi
	else
		screen -mS irssi /usr/bin/irssi
	fi
	echo "Irssi not running, started new session..."
elif [ ! $BACKGROUND ]; then
	screen -rx irssi
fi
