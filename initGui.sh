#!/bin/bash

module add gui
path=$(pwd)/VNClogin.txt
echo "use cat $path to see connection details again" > $path
gui start -g 1920x1080 --ssh -f >> $path

