#!/bin/bash
# 
# Accept message script
# To be used in 
#
# Copyright 2014 Government of Canada
#
# MIT License
# 
# Author: Glen Newton glen.newton@agr.gc.ca glen.newton@gmail.com
# 
# Developeed at: Microbial Biodiversity Bioinformatics @ Agriculture and Agri-Food Canada
# 
# Usage: add to /etc/profile.d
#        - Edit 'message' as necessary
#        - message must not span multiple lines: SINGLE LINE ONLY
#        - Acknowledgement recorded in $logfile
#           - format: date|userid|message
#           - must be world writable
#


message="[example] Foobar varsion 1.7 installed; Foobar v.1.6 still available at /opt/old/foobar mm"
#
prompt="Please acknowledge you have read and understand the above message by typing \"yes\" at this prompt: "

logfile="/var/log/accepted_message.log"

#################################################
###### DO NOT CHANGE BELOW THIS POINT ###########
#################################################


if [ ! -f $logfile ]; then
    echo ""
    echo "Error: accept_message.sh: Missing log file: $logfile"
    echo ""
else
    # Are we on a tty?
    case $(tty) in /dev/pts/[0-9]*)

	    ## Disable Ctrl+C, Ctrl+Z 
	    trap '' 2 20
	    ##

	    echo ""
	    echo $message
	    echo ""

	    userMessageKey="$USER|$message"

	    #hits=`grep -F -c "$userMessageKey\\$" $logfile`
	    hits=`grep -F -c "$userMessageKey" $logfile`

	    if [ $hits == "0" ]; then
		for (( ; ; ))
		do
		    echo "#########################################################################################"
		    read -p "$prompt" ack
		    
		    if  [ $ack == "yes" ] || [ $ack == "YES" ] ; then
			
			date=`date`
			echo "$date|${userMessageKey}" >> $logfile
			break
		    fi
		done
	    fi

	    # Enable Ctrl+C, Ctrl+Z, 
	    trap 2 20
	    #
	    echo ""
	    echo ""
    esac
fi
