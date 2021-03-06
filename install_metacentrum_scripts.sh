#! /bin/bash
cd $HOME
#test initHuygens
echo -e "would you like to reinstall all scripts? (y/n) \c"
	read
	if ! [ -f ./install_metacentrum_scripts.sh ] || [ "$REPLY" = "y" ]; then
		wget https://github.com/Schebique/Metacentrum_Huygens_Scripts/blob/master/install_metacentrum_scripts.sh?raw=true  -O install_metacentrum_scripts.sh -q
		echo "install_metacentrum_scripts.sh updated"
	fi
	if ! [ -f ./deconvoluce.sh ] || [ "$REPLY" = "y" ]; then
		wget https://github.com/Schebique/Metacentrum_Huygens_Scripts/blob/master/dekonvoluce.sh?raw=true  -O dekonvoluce.sh -q
		echo "dekonvoluce.sh copyied"
	fi
	if ! [ -f ./initHuygens.sh ] || [ "$REPLY" = "y" ]; then
		wget https://github.com/Schebique/Metacentrum_Huygens_Scripts/blob/master/initHuygens.sh?raw=true  -O initHuygens.sh -q
		chmod 700 initHuygens.sh
		echo "initHuygens.sh installed"
	fi
	if ! [ -f ./initGui.sh ] || [ "$REPLY" = "y" ]; then
		wget https://github.com/Schebique/Metacentrum_Huygens_Scripts/blob/master/initGui.sh?raw=true --unlink -O initGui.sh -q
		chmod 700 initGui.sh
		echo "initGui.sh installed"
	fi
	if ! [ -f ./hupro.sh ] || [ "$REPLY" = "y" ]; then
		wget https://github.com/Schebique/Metacentrum_Huygens_Scripts/blob/master/hupro.sh?raw=true --unlink -O hupro.sh -q
		chmod 700 hupro.sh
		echo "hupro.sh installed"
	fi
	if ! [ -f ./How_to_use_it.txt ] || [ "$REPLY" = "y" ]; then
		wget https://github.com/Schebique/Metacentrum_Huygens_Scripts/blob/master/How_to_use_it.txt?raw=true --unlink -O How_to_use_it.txt -q
		echo
		cat How_to_use_it.txt
	fi
	if [ "$REPLY" = "n" ]; then echo "No files were installed."
	fi
