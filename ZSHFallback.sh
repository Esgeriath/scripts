#!/bin/sh

if eval $@; then
    exit 0
else
    zsh
fi
