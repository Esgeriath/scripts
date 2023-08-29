#!/bin/bash
# hacky one-liner
shuf ~/.local/share/neofetch-ASCII | fzf | tee >(xargs neofetch -L --ascii_distro) && sleep 0.2
# NAME="$(shuf ~/.local/share/neofetch-ASCII | fzf)"
# echo "$NAME"
# neofetch -L --ascii_distro "$NAME"
