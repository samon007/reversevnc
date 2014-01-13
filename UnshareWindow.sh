#!/bin/sh
set -e
set -u
export LANG=c
cd $(dirname $0)

pkill -15 -f $(xdotool selectwindow 2> /dev/null)
