#!/bin/sh

echo $#
ending=$(echo "$1" | grep -Eo '.{11}$')
mpv "https://youtube.com/watch?v=$ending"

