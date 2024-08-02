#!/bin/bash

# A script to interactively unmount usb drives using fzf.
# Idea stolen from Luke Smith

devices="$(lsblk -l |
# First grep gets rid of windows partitions that I don't want to mount
    grep -vE 'sda|nvme0n1' |
    grep 'part /' |
    awk '{print $7" ("$1")"}')"

disk="$(echo "$devices" |
    fzf --prompt='Choose device: ')" 

# TODO: it's not POSIX complient with [[ and =~, but works with bash
[[ -z "$disk" || ! "$devices" =~ "$disk" ]] && exit 1

mountpoint="$(echo "$disk" | cut -f 1 -d ' ')"

[ -z "$mountpoint" ] || [ ! -d "$mountpoint" ] && exit 2

sudo umount "$mountpoint"

