#! /bin/bash

initMeta(){
#test ssh
	if ! which ssh > /dev/null; then
		echo -e "ssh not found! Install? (y/n) \c"
		read
		if "$REPLY" = "y"; then
			sudo apt-get install ssh
		fi
	fi

#test instalovanych programu sshpass
	if ! which sshpass > /dev/null; then
		echo -e "sshpass not found! Install? (y/n) \c"
		read REPLY
		if "$REPLY" = "y"; then
			sudo apt-get install sshpass
		fi
	fi

#test ssh
	if ! which scp > /dev/null; then
		echo -e "scp not found! Install? (y/n) \c"
		read REPLY
		if "$REPLY" = "y"; then
			sudo apt-get install scp
		fi
	fi
test ssvnc
	if ! which x11vnc > /dev/null; then
		echo -e "ssvnc not found! Install? (y/n) \c"
		read REPLY
		if [ "$REPLY" = "y" ]; then
			sudo apt-get install ssvnc 
		fi
	fi
#test xsel - for clipboard
	if ! which xsel > /dev/null; then
		echo -e "xsel clipboard manager not found! Install? (y/n) \c"
		read REPLY
		if [ "$REPLY" = "y" ]; then
			sudo apt-get install xsel 
		fi
	fi	
#get credentials
	dir=$(pwd)
	dir="${dir// /\\ }"
	hostname="doom29.metacentrum.cz"
	echo -n "Metacentrum username:"
	read username
	sshLogin="$username@$hostname"
	read -s -p "$sshLogin's password: " password
	
#test if files are on remote host
	echo
	remoteDir=$(sshpass -p $password ssh $sshLogin pwd)
	shList=$(sshpass -p $password ssh $sshLogin echo "ls *.sh")
	initHFile=$(echo $shList | grep "initHuygens.sh" -c)
	initGFile=$(echo $shList | grep "initGui.sh" -c)
	huproFile=$(echo $shList | grep "hupro.sh" -c)
	if [ $initHFile -eq 0 ] ; then 
		echo uploading initHuygens.sh
		sshpass -p $password scp initHuygens.sh "$sshLogin:\"$remoteDir\""
	fi
	if [ $initGFile -eq 0 ] ; then 
		echo uploading initGui.sh
		sshpass -p $password scp initGui.sh "$sshLogin:\"$remoteDir\""
	fi
	if [ $huproFile -eq 0 ] ; then 
		echo uploading hupro.sh
		sshpass -p $password scp hupro.sh "$sshLogin:\"$remoteDir\""
	fi
	
#start initHuygens.sh script
	sshpass -p $password chmod u=rwx *.sh
	sshpass -p $password ssh $sshLogin "./initHuygens.sh"
	if [[ $? -eq 0 ]]; then
		#scp your_username@remotehost.edu:foobar.txt /local/dir
		sshpass -p $password scp $sshLogin:VNClogin.txt ./
		port=$(cat "./VNClogin.txt" | grep -F "Port" | cut -d ":" -f 2)
		port="${port// /}"
		#echo $port
		pass=$(cat "./VNClogin.txt" | grep -F "Password" | cut -d ":" -f 2)
		pass="${pass// /}"
		#echo $pass
		display=$(cat "./VNClogin.txt" | grep -F "Display" | cut -d ":" -f 3)
		#echo $display
		#cat "./VNClogin.txt"
		echo $pass | xsel
		echo "use SHIFT+Ins to put the password into the VNC gui"
		#start VNC localy
		sshpass -p $password sshvnc "$hostname:$port"
	else echo "Huygens start was unsuccesfull"; fi
}

export -f initMeta

initMeta
#gnome-terminal -e "bash -c 'initMeta;$SHELL'"
