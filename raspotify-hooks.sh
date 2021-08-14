#!/bin/bash
# Raspotify callback script used to send HDMI CEC commands to control the A/V system when this system is selected or deselected as the playback target
# Use parameter `--onevent /path/to/raspotify-hooks.sh` to direct raspotify (or librespot) towards this script
# Prerequisites: cec-client utility from debian package cec-utils (or similar in other distros)
# Typically the user running raspotify will need to be a member of the "video" group to get permission to access the HDMI CEC interface

# Configration parameters: addresses can be found using the 'scan' function in cec-client to discover which devices are present on the bus and which addresses they have
OUR_HDMI_ADDRESS=4
OUR_PHYS_ADDRESS="25:00" # Concatenated form of 2.5.0.0
RECEIVER_HDMI_ADDRESS=5 # Logical address, physical is "2.0.0.0" but cec-client seems to use the logical one for commands
TV_HDMI_ADDRESS=0 # Physical: "0.0.0.0"

function sendCec() {
       echo "$*" | cec-client -s -d 1 | grep -v 'opening a connection to the CEC adapter...'
}

function getTvPower() {
        sendCec "pow $TV_HDMI_ADDRESS" | cut -d: -f2 | xargs
}


case $PLAYER_EVENT in
        start)
                # Start event, change HDMI receiver source
                echo "Got start event, starting receiver and selecting HDMI source..."
                sendCec "on $RECEIVER_HDMI_ADDRESS"
                # Playback 1 (4) -> broadcast (F): active source (82, address: 2500)
                sendCec "tx ${OUR_HDMI_ADDRESS}F:82:${OUR_PHYS_ADDRESS}"
                ;;
        stop)
                # Stop event (client disconnect), revert HDMI receiver source
                echo "Got stop event, releasing receiver control..."
                TV_STATE="$(getTvPower)"
                echo "TV_STATE: $TV_STATE"
                # Send "inacive source" command to mark this source as no longer active
                sendCec "is"
                if [[ "$TV_STATE" == "standby" ]]; then
                        sendCec "standby $RECEIVER_HDMI_ADDRESS"
                else
                        # Request active source - used to switch back to previously active source
                        sendCec "tx ${OUR_HDMI_ADDRESS}F:85"
                fi
                ;;
        *)
                echo "Event not yet implemented: $PLAYER_EVENT"
                ;;
esac
