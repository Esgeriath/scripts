#!/bin/bash


CHOICE=$(echo \
"er: è
ef: é
ea: ê
el: ë
os: ò
od: ô
of: õ
oi: ö
as: à
ad: á
af: â
ae: æ
ar: ã
al: ä
ak: å
ua: ú
ui: ù
uo: û
us: ũ
ud: ü
ya: ý
ys: ỳ
yd: ŷ
yf: ÿ
yw: ȳ
ia: í
is: ì
id: î
if: ĩ
ie: ï" |
    fuzzel -d -f "JetBrainsMono:weight=medium:size=24" -w 13 -l 7 |
    cut -d: -f2 | tr -d " \n")

wl-copy "$CHOICE"
notify-send -t 1500 "Copied $CHOICE"

