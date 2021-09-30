#!/bin/sh

# My dwm status bar

SEPARATOR="|"
BACKLIGHT=""
VOLUME=""
TIME=""
DAY=""
BATT=""
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
    BATT=$(cat /sys/class/power_supply/BAT1/capacity)
    # Is charging cable connected
    CONNECTED=$(cat /sys/class/power_supply/ACAD/online)
    case $BATT in
        100|9[0-9]) BATT_ICO="";;
        8[0-9])     BATT_ICO="";;
        7[0-9])     BATT_ICO="";;
        6[0-9])     BATT_ICO="";;
        5[0-9])     BATT_ICO="";;
        4[0-9])     BATT_ICO="";;
        3[0-9])     BATT_ICO="";;
        2[0-9])     BATT_ICO="";;
        1[0-9])     BATT_ICO="";;
         [0-9])     BATT_ICO="";;
    esac

    # idk, it seems pointless when it is synchronous
    [ "$CONNECTED" = 1 ] && BATT_ICO="$BATT_ICO""ﮣ" #

}

update() {
    xsetroot -name "  $BACKLIGHT $SEPARATOR 奄 $VOLUME% $SEPARATOR $BATT_ICO $BATT% $SEPARATOR $DAY $SEPARATOR $TIME "
}

# This version didn't work
# trap -- 'async_info; update ;' INT

while true; do
    async_info
    sync_info
    update
    sleep 1m
done

