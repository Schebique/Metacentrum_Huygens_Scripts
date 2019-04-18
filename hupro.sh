#!/bin/bash  
# Skript pro spusteni Huygens Pro v gui rozhrani
home=$(pwd)
cd /packages/run/modules-2.0/modulefiles
vnum=$(ls huygens-* | grep "huygens" -c)
versions=$(ls huygens-* | grep "huygens")
verH=$(echo $versions | cut -d " " -f $vnum)
#verH=$(echo $ver | cut -d "/" -f 6)
echo $verH

vnum=$(ls cuda-* | grep "cuda-" -c)
versions=$(ls cuda-* | grep "cuda-")
verC=$(echo $versions | cut -d " " -f $vnum)
#verC=$(echo $ver | cut -d "/" -f 6)
echo $verC
cd $home


module add $verC
module add $verH
huygenspro
