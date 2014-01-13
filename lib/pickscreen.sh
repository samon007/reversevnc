#!/bin/sh
set -e
set -u
export LANG=c
IFS=$'\n'
 
xdotool selectwindow &> /dev/null
CLICK=$(xdotool getmouselocation 2> /dev/null)
CLICK_WIDTH=$( echo ${CLICK} | cut -d\: -f2 |cut -d\  -f1)
CLICK_HEIGHT=$(echo ${CLICK} | cut -d\: -f3 |cut -d\  -f1)
 
 
for LINE in $(xrandr | grep -e ".*x.*+.*+.*" | cut -d\  -f3);do
   
	MIN_WIDTH=$(echo ${LINE} | cut -d\+ -f2)
	MAX_WIDTH=$(( $(echo ${LINE} | cut -d\+ -f1 | cut -d\x -f1) + ${MIN_WIDTH}))
   
	MIN_HEIGHT=$(echo ${LINE} | cut -d\+ -f3)
	MAX_HEIGHT=$(( $(echo ${LINE} | cut -d\+ -f1 | cut -d\x -f2) + ${MIN_HEIGHT}))
   
	#echo WIDTH RANGE: $MIN_WIDTH - $MAX_WIDTH
	#echo HEIGHT RANGE: $MIN_HEIGHT - $MAX_HEIGHT
 
	if (($CLICK_WIDTH<=$MAX_WIDTH && $CLICK_WIDTH>=$MIN_WIDTH))
	then
		if (($CLICK_HEIGHT<=$MAX_HEIGHT && $CLICK_HEIGHT>=$MIN_HEIGHT))
			then
				echo ${LINE}
			fi    
	fi
done

