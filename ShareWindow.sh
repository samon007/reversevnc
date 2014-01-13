#!/bin/sh
set -e
set -u
export LANG=c
cd $(dirname $0)

lib/core.tcl
