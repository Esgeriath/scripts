#!/bin/bash

sed -n "$1" < ~/.local/share/words.txt | tee >(wc -l)

# pacman -Qi | awk '/^Name/{name=$3} /^Installed Size/{print $4$5, name}' | sort -hr | head -25

