#!/bin/bash

bl_file="/sys/class/backlight/*/brightness"  		# 
bl_act=$(cat $bl_file)          			# current brightness level
bl_max=$(cat /sys/class/backlight/*/max_brightness) 	# max brightness level (100%)
bl_min=$(($bl_max / 100))           			# min brightness level (1%)

input=$(( ($bl_max/100) * $1 ))
bl_new=$(($bl_act + input))

if [ "$bl_new" -gt "$bl_max" ]; then
    echo "$bl_max" | sudo tee $bl_file
elif [ "$bl_new" -lt "$bl_min" ]; then
    echo "$bl_min" | sudo tee $bl_file
else
    echo "$bl_new" | sudo tee $bl_file
fi
