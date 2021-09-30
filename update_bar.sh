#!/bin/sh

# This script "updates" my dwm bar by fast forwarding sleep command

kill "$(pstree -lp | grep -- dwm_bar.sh | sed "s/^.*sleep(//; s/).*$//")"

