#!/bin/bash

# A script to interactively mount usb drives using fzf.
# Idea stolen from Luke Smith

devices="$(lsblk -l |
# First grep gets rid of windows partitions that I don't want to mount
    grep -vE 'sda|nvme0n1' |
    grep 'part $' |
    awk '{print $1" ("$4")"}')"

disk="$(echo "$devices" |
    fzf --prompt='Choose device: ')" 

# TODO: it's not POSIX complient with [[ and =~, but works with bash
[[ -z "$disk" || ! "$devices" =~ "$disk" ]] && exit 1

disk="/dev/$(echo "$disk" | cut -f 1 -d ' ')"

# If disk figures in fstab, mount it
sudo mount -o gid=users,umask=0000 "$disk" 2>&1 && exit 0

# Otherwise ask where to mount
mountpoint="$(find /mnt -maxdepth 3 -mount -type d |
    fzf --prompt='Choose mountpoint' )"

[ -z "$mountpoint" ] || [ ! -d "$mountpoint" ] && exit 2

sudo mount -o gid=users,umask=0000 "$disk" "$mountpoint"

