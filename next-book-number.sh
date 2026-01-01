#!/bin/bash

if [ $# -lt 1 ]; then
    DIR="$HOME/Dokumenty/books/"
else
    DIR="$1"
fi

NUM=$(find "$DIR" -type f | while read -r line; do
   basename "$line" | cut -d " " -f 1
done | grep -E '[0-9]+' | sort | tail -n 1)

# printf '%03d' "$((NUM + 1))"
NEXT=$(awk "BEGIN {printf \"%03d\", $NUM + 1 end}")

wl-copy "$NEXT"
notify-send "next number is $NEXT" "copied to primary"

