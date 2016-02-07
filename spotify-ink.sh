#!/bin/bash
# # # # # # # # # # # # # # # # # # # # # # #
# Automatisk skript for å sjekke om Spotify #
# kjører og om klienten støtter X-forwarding#
# (som er nødvendig for å kjøre det)        #
# ---------------------------------         #
# Torbjørn Viem Ness, EDB                   #
# ---------------------------------         #
# # # # # # # # # # # # # # # # # # # # # # #

if [ `pidof spotify` ]; then
	if [ $1 ]; then
		case $1 in
		play)
		dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlayPause
		;;
		stop)
		dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Stop
		;;
		skip)
		dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Next
		;;
		back)
		dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Previous
		dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Previous
		;;
		esac
	else
		echo -e "\e[1;31mSpotify kjører allerede - ikke start en ny nå, da blir det bare derp...\e[0m"
	fi
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
