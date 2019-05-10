#!/bin/bash

deleteVNClogin() {
	if [[ -f ./VNClogin.txt ]]; then rm VNClogin.txt; fi
}

initGui() {
	deleteVNClogin
	rSelect=d$(pbs_rstat -f $reservace | grep -F "Resource_List.select")
	rSelect=$(echo $rSelect | cut -d " " -f 3)
	qsub -q $resNum -l select=$rSelect ./initGui.sh
	while ! [ -f ./VNClogin.txt ] ; do #cekej na start rezervace
		sleep 3
	done
	sleep 1
	cat VNClogin.txt
}

#username=$(eval users | cut -d" " -f 1)
username=$(id | cut -d "(" -f 2 | cut -d ")" -f1 )
reservNumSalvet=$(pbs_rstat -S | grep -F "salvet" -c | cut -d"." -f 1)
reservNumUser=$(pbs_rstat -S | grep -F $username -c | cut -d"." -f 1)
reservNum=$((reservNumSalvet+reservNumUser))
#echo $reservNum
reservationsSalvet=$(pbs_rstat -S | grep -F "salvet" | cut -d"." -f 1)
reservationsUser=$(pbs_rstat -S | grep -F $username | cut -d"." -f 1)
reservations=$(echo $reservationsUser $reservationsSalvet)
#SUBSTRING=$(echo $reservations | cut -d"." -f 1)
#echo $reservations
nTime=$(date +%s)
echo "------------------------------------------------"
echo Reservations for $username:
if [ $reservNum -gt 0 ] ; then
	oldDTime=9999999999
	#prohledat rezervace a najit nejblizsi
	for (( count=0 ; $count-($reservNum) ; count+=1 )) ; do
		count=$(($count+1))
		reservace=$(echo $reservations | cut -d" " -f $count)
		state=$(pbs_rstat -f $reservace | grep -F $username -c)
		confirmed=$(pbs_rstat -f $reservace | grep -F  "RESV_CONFIRMED" -c)
		running=$(pbs_rstat -f $reservace | grep -F  "RESV_RUNNING" -c)
		if [ $state -ge 1 ] && [ $confirmed -eq 1 ] || [ $running -eq 1 ] ; then
			startTime=$(pbs_rstat -f $reservace | grep -F "reserve_start")
			durTime=$(pbs_rstat -f $reservace | grep -F "reserve_duration")
			durTime=$(echo $durTime | cut -d " " -f 3)
			Sweekday=$(echo $startTime | cut -d" " -f 3)
			Sden=$(echo $startTime | cut -d" " -f 5)
			Smesic=$(echo $startTime | cut -d" " -f 4)
			Stime=$(echo $startTime | cut -d" " -f 6)
			Srok=$(echo $startTime | cut -d" " -f 7)
			Spasmo=$(date +%z)
			rTime=$(echo $Sweekday, $Sden $Smesic $Srok $Stime $Spasmo)
			sTime=$(date -d "$rTime" +%s)
			eTime=$(($sTime+durTime))
			dTime=$(($sTime-$nTime))
			echo "$reservace starts at $rTime for $durTime seconds. Start after $dTime seconds."
			if [ $dTime -lt $oldDTime ]; then 
				oldDTime=$dTime  
				resNum=$reservace
				resStart=$rTime
				resStime=$sTime
				resEtime=$eTime
				resDur=$durTime
			fi
		fi
		count=$(($count-1))
	done #konec forcyklu
	# co udelat s nejblizsi rezervaci
	if [ -n "${resNum}" ] ; then
		nTime=$(date +%s)
		dTime=$(($resStime-$nTime))
		echo "------------------------------------------------"
		echo "Starting job $resNum $resStart"
		if [ $dTime -le	0 ] && [ $nTime -lt $resEtime ] ; then
			jobStat=$(qstat | grep $resNum)
			path=$(pwd)/VNClogin.txt
			if [ -z "${jobStat}" ] ; then
				initGui
				#echo Job started and VNC correctly initialized
			else
				jobNum=$(qsub -- echo $jobStat | cut -d " " -f 1)
				echo $resNum job $jobNum is already running. 
				cat $path	
			fi 
		elif [ $dTime -gt 0 ] && [ $dTime -lt 600 ] ; then #pokud zacne job do 10ti minut
			echo #na novy radek
			read -p "Do you want wait $dTime seconds for job starts? (y/n) " -n 1 -r
			if [[ $REPLY =~ ^[Yy]$ ]] ; then
				nTime=$(date +%s)
				dTime=$(($resStime-$nTime))
				echo #na novy radek
				echo "Waiting for job $resNum starts ($dTime seconds) (exit CTRL+C)"
				#odpocitavani
				while [ $dTime -ge 0 ] ; do #cekej na start rezervace
					sleep 1
					echo -en "\r`tput el`$dTime"
					dTime=$(expr $dTime - 1)
				done
				jobStat=$(qstat | grep $resNum)
				path=$(pwd)/VNClogin.txt
				if [ -z "${jobStat}" ] ; then
					initGui
					#echo Job started and VNC correctly initialized
				else
					jobNum=$(echo $jobStat | cut -d " " -f 1)
					echo $resNum job $jobNum is already running
					if [[ -f ./VNClogin.txt ]]; then 
						cat $path
					else
						echo "but VNC login credentials are not available. Trying to find gui..."
						module add gui
						flag=$(gui -p info | grep -F "There're no VNC session(s) to show! Exiting..." -c)
						if [ $flag -eq 0 ]; then initGui
						else gui -p info
						fi
					fi 
				fi
			else
				echo #na novy radek
				echo "Job is not starting yet. Try to run this script later again."
				exit 1
			fi
		else
			# [[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1 # handle exits from shell or function but don't exit interactive shell
			echo "Reservation starts more than 10 minutes later. Try it later again!"
			exit 1
		fi
	else 
		# deleteVNClogin
		echo "No confirmed or running Huygens reservations found for user $username"
		exit 1
	fi
#fi #konec podminky kdyz rezervace existuji
else 
	# deleteVNClogin
	echo "No Huygens reservations found for user $username"
	exit 1
fi
