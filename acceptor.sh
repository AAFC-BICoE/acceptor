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

set -e

# Message goes here; any number of lines.
#     Alternate form acceptable:
#       MESSAGE=("[example] Foobar varsion 1.7 installed", "  Foobar v.1.6 still available", " Any issues please contact foo@bar.com")
MESSAGE[0]="[example] Foobar varsion 1.7 installed; Foobar v.1.6 still available at /opt/old/foobar"
MESSAGE[1]="   Foobar v.1.6 still available at /opt/old/foobar"
MESSAGE[2]="   Any issues please contact foo@bar.com 23"


# Edit this if you want to use something other than "yes" as acknowledgement
readonly ACCEPT="yes"
# Edit this to alter the prompt:
readonly PROMPT="Please acknowledge you have read and understand the above MESSAGE by typing \"${ACCEPT}\" at this prompt: "


# Location of logfile; must be world writable
readonly LOGFILE="/var/log/acceptor.log"

#################################################
###### DO NOT CHANGE BELOW THIS POINT ###########
#################################################


print_message(){
    printf "%s\n" "$@"
 }

make_message_key(){
    key=""
    for i in "${@}"
    do
	key+=$i
	key+=" "
    done
    echo "$key"
 }

readonly messageKey=$(make_message_key "${MESSAGE[@]}")

if [ ! -f $LOGFILE ]; then
    echo ""
    echo "Error: acceptor.sh: Missing log file: $logfile"
    echo ""
else
    # Are we on a tty?
    case $(tty) in /dev/pts/[0-9]*)

	    ## Disable Ctrl+C, Ctrl+Z 
	    trap '' 2 20
	    ##

	    echo ""
	    print_message "${MESSAGE[@]}"
	    echo ""

	    readonly userMessageKey="$USER|$messageKey"

	    readonly hits=`grep -F -c "$userMessageKey" $LOGFILE`

	    if [ $hits == "0" ]; then
		for (( ; ; ))
		do
		    echo "#########################################################################################"
		    read -p "$PROMPT" ACK
		    
		    if  [ $ACK == "${ACCEPT}" ] || [ $ACK == "YES" ] ; then
			date=`date`
			echo "$date|${userMessageKey}" >> $LOGFILE
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
