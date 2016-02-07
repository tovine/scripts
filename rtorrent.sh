if ! screen -list | grep -q "rtorrent"; then
	screen -mS rtorrent /usr/bin/rtorrent
	echo "RTorrent not running, started new session..."
else
	screen -rx rtorrent
fi
