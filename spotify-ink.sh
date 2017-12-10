#!/bin/bash
# # # # # # # # # # # # # # # # # # # # # # #
# Automatisk skript for å sjekke om Spotify #
# kjører og om klienten støtter X-forwarding#
# (som er nødvendig for å kjøre det)        #
# ---------------------------------         #
# Torbjørn Viem Ness, EDB                   #
# ---------------------------------         #
# # # # # # # # # # # # # # # # # # # # # # #

export DISPLAY=:0

if [ "$(pidof spotify)" ]; then
	case $1 in
		play)
		dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlayPause > /dev/null
		;;
		stop)
		dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Stop > /dev/null
		;;
		skip)
		dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Next > /dev/null
		;;
		back)
		dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Previous > /dev/null
		dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Previous > /dev/null
		;;
		*)
		echo "Ukjent kommando, prøv 'play' (play/pause), 'stop', 'skip' eller 'back'"
		;;
	esac
else
	if [ $DISPLAY ]; then
		echo "Starter Spotify..."
		screen -dmS spotify /usr/bin/spotify
		#/usr/bin/spotify
	else
		echo -e "\e[1;41;97mFEIL!\e[49m X-forwarding er deaktivert for denne terminalen..."
		echo -e "For å kunne kjøre Spotify må du koble til på nytt med det aktivert"
		echo -e "F.eks: \e[34mssh -X medlem@ink.ed.ntnu.no\e[0m"
	fi
fi
