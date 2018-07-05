#!/bin/bash

CORSFinished=false

# this function is called when Ctrl-C is sent
trap_ctrlc()
{
	if [ "$CORSFinished" = false ] ; then #continue the rest of the program
		# perform cleanup here
		echo "Ctrl-C caught...performing clean up"

		echo "Done !"

		echo "Starting CORS (ID445) "
			
		#Go to the c file directory
		cd /home/pi/RTKLIB/app/str2str/gcc
		
		#Ask User for coordinates of BS
		read -p "Waiting for Latitude: " var1

		read -p "Waiting for input: " var2

		read -p "Waiting for input: " var3

		# Stream the RTCM3 content with the following messages
		# 1005,1006,1008,1033,1074,1013,1084,1094,1114,1124 (As AUCK_RTCM-MSM)
		# Station ID 445
		sudo ./str2str -in serial://ttyACM0:230400:8:n:1:off#ubx -out serial://ttyS0:57600:8:n:1:off#rtcm3 -msg 1005,1006,1008,1033,1074,1013,1084,1094,1114,1124 -p 52.14271937 3.24461 5.6753
		
		#In case of Ctrl-C, indicates that the CORS is already done
		CORSFinished=true

	else
		echo 'End of Script'
	fi	
	
	# exit shell script with error code 2
	# if omitted, shell script will continue execution
	exit 2
}

# initialise trap to call trap_ctrlc function
# when signal 2 (SIGINT) is received
trap "trap_ctrlc" 2

## This is the passthrough: RPi is a glorified Serial2WLAN converter
#grab Ucenter and perform a Receiver -->  Port --> Network Connection --> New or select

while true; do
	socat tcp-listen:54321,reuseaddr /dev/ttyACM0,b230400,raw,echo=0
done