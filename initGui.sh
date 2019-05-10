#!/bin/bash

module add gui
path=$(pwd)/VNClogin.txt
echo $path
gui start -g 1920x1080 --ssh -f > $path
#cat $path
echo "VNC login credentials can be displayed with this command as well:" >> $path
echo "cat VNClogin.txt" >> $path
