#!/bin/sh
# adapted from BugsWriter
# https://www.youtube.com/watch?v=g6V9jrgxR9g

help() {
    echo "usage: y [-s] [-l] <query>"
    echo " -s: search (opposite to follow link)"
    echo " -l: get link only"
}

[ $# -eq 0 ] && help && exit
if [ "$1" = '-s' ]; then
    search=true
    shift
fi
if [ "$1" = '-l' ]; then
    get_link=true
    shift
fi

if [ $search ]; then
    query=$(printf "%s" "$*" | tr ' ' '+')
    ending=$(curl -s "https://vid.puffyan.us/search?q=$query" | grep -Eo "watch\?v=.{11}" | head -n 1)
    link="https://youtube.com/$ending"
else
    ending=$(echo "$1" | grep -Eo '.{11}$')
    link="https://youtube.com/watch?v=$ending"
fi

if [ $get_link ]; then
    echo "$link"
else 
    mpv "$link"
fi

