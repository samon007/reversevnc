#!/bin/sh

WINDOWID=$(xwininfo |grep "Window id:" |awk '{print $4}')
kill -15 $(pgrep -f ${WINDOWID})
