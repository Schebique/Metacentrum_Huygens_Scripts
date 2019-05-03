#! /bin/bash
cd $HOME
#test initHuygens
echo -e "would you like to reinstall all scripts? (y/n) \c"
	read
	if ! [ -f ./initHuygens.sh ] || [ "$REPLY" = "y" ]; then
		wget https://github.com/Schebique/Metacentrum_Huygens_Scripts/blob/master/initHuygens.sh --unlink -O initHuygens.sh 
		chmod 700 initHuygens.sh
	fi
	if ! [ -f ./initGui.sh ] || [ "$REPLY" = "y" ]; then
		wget https://github.com/Schebique/Metacentrum_Huygens_Scripts/blob/master/initGui.sh --unlink -O initGui.sh 
		chmod 700 initGui.sh
	fi
	if ! [ -f ./hupro.sh ]|| [ "$REPLY" = "y" ]; then
		wget https://github.com/Schebique/Metacentrum_Huygens_Scripts/blob/master/hupro.sh --unlink -O hupro.sh
		chmod 700 hupro.sh
	fi
	if [ "$REPLY" = "n" ]; then echo "No files were installed."
	fi
	
	
