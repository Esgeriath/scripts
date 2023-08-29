#!/bin/sh

# My dwm status bar

SEPARATOR="|"
BACKLIGHT=""
VOLUME=""
TIME=""
DAY=""
BATT_INFO=""
BATTS="$(ls /sys/class/power_supply/ | grep BAT)"
CONNECTED=""
BATT_ICO=""

# Info that needs to be updated immediately
async_info() {
    # Backlight brightness
    BACKLIGHT=$(light | xargs printf "%.1f")
    # Audio level
    VOLUME=$(pulsemixer --get-volume | tr " " "\n" | sort -u | tail -n 1)
}

sync_info() {
    # Hours and minutes
    TIME=$(date "+%R")
    # Day month and year
    DAY=$(date "+%F (%a)")
    # Current battery capacity
    BATT_INFO=""
    for BATTN in $BATTS; do
        BATT=$(cat /sys/class/power_supply/$BATTN/capacity)
        case $BATT in
            100|9[0-9]) BATT_ICO="🔋";;
            8[0-9])     BATT_ICO="🔋";;
            7[0-9])     BATT_ICO="🔋";;
            6[0-9])     BATT_ICO="🔋";;
            5[0-9])     BATT_ICO="🔋";;
            4[0-9])     BATT_ICO="🔋";;
            3[0-9])     BATT_ICO="🔋";;
            2[0-9])     BATT_ICO="🪫";;
            1[0-9])     BATT_ICO="🪫";;
             [0-9])     BATT_ICO="🪫";;
        esac
        BATT_INFO="$BATT_INFO $BATT%$BATT_ICO$SEPARATOR"
    done

    # Is charging cable connected
    CONNECTED=$(cat /sys/class/power_supply/AC/online)
    # idk, it seems pointless when it is synchronous
    [ "$CONNECTED" = 1 ] && BATT_INFO="$BATT_INFO⚡$SEPARATOR" #

}

update() {
    #xsetroot -name "🔆 $BACKLIGHT%$SEPARATOR🔊 $VOLUME%$SEPARATOR$BATT_INFO $DAY $SEPARATOR $TIME "
    xsetroot -name "🔆 $BACKLIGHT%$SEPARATOR🔊 $VOLUME%$SEPARATOR $DAY $SEPARATOR $TIME "
}

# This version didn't work
# trap -- 'async_info; update ;' INT

while true; do
    async_info
    sync_info
    update
    sleep 20
done

