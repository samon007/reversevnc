#!/bin/sh
set -e
set -u
set -x
export LANG=c
cd $(dirname $0)
kill -15 $(ps a|grep -v grep |grep x11vnc |grep  $(lib/pickscreen.sh)|cut -d\  -f1)
