#!/bin/bash
# AutoStart commands

# start captvty. first wine fails so we restart right after
wine ./captvty/Captvty.exe >/dev/null 2>&1
if [ $? == 1 ]; then
	sleep 2
	wine ./captvty/Captvty.exe >/dev/null 2>&1
fi

# sauvegarde les options 
cp captvty/captvty.ini downloads/
