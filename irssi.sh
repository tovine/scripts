if ! screen -list | grep -q "irssi"; then
	screen -mS irssi /usr/bin/irssi
	echo "Irssi not running, started new session..."
else 
	screen -rx irssi
fi
