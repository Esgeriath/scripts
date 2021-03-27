#!/bin/bash

if [[ $# != 2 ]]; then
    echo "usage: $0 <url> <time>"
    exit
fi

url=$1
time=$2
if ((time < 0)); then
    (( time = -time ))
    background=true
else
    background=false
fi

urln=$(echo $url | sed -e "s/\//+/g")

cd ~/.webtrace

if [[ ! -d "$url" ]]; then
    mkdir -p "$url"
    cd "$url"
    git init > /dev/null
    lynx -dump $url > page
    git add .
    git commit -m "initail commit" > /dev/null
    $background || echo "initialized new tracer"
else
    cd "$url"
fi

while true; do
    lynx -dump $url > /tmp/webtracerpage__$urln
    if [[ ! -z "$(diff /tmp/webtracerpage__$urln page)" ]]; then
        $background || echo "new changes:"
        $background || diff page /tmp/webtracerpage__$urln
        $background || cat /tmp/webtracerpage__$urln > page
        git add .
        git commit -m "$(date +%s)" > /dev/null
        $background && break;   # in background mode exiting loop after first found
    fi
    rm /tmp/webtracerpage__$urln
    sleep $time
done

$background || exit

while true; do
	echo -en "\007"
	sleep 1
done


