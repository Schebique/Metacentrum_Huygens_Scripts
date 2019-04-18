#!/bin/bash

module add gui
path=$(pwd)/VNClogin.txt
echo $path
gui start -g 1920x1080 --ssh -f > $path
#cat $path
