#!/bin/bash
# 
# ---acceptor---
# 
# - Run at login with a message that must be accepted by the user before proceeding
# - Logs the acceptance
# - Only demands acceptance once per user, per message
# - Displays message every time
# - control-c and control-z disabled
#
# Copyright 2014 Government of Canada
#
# MIT License
# 
# Author: Glen Newton glen.newton@agr.gc.ca glen.newton@gmail.com
# 
# Developed at: Microbial Biodiversity Bioinformatics Group @ Agriculture and Agri-Food Canada
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
#     Alternate syntax acceptable:
#       MESSAGE=("[example] Foobar varsion 1.7 installed", "  Foobar v.1.6 still available", " Any issues please contact foo@bar.com")
MESSAGE="[example] Foobar varsion 1.7 installed; Foobar v.1.6 still available at /opt/old/foobar Foobar v.1.6 still available at /opt/old/foobar. Any issues please contact foo@bar.com mm m"

# Edit this if you want to use something other than "yes" as user acknowledgement input
readonly ACCEPT="yes"

# Edit this to alter the prompt; above alternate syntax for MESSAGE also applies
PROMPT="Please acknowledge you have read and understand the above MESSAGE by typing \"${ACCEPT}\":"


# Location of logfile; must be world writable
readonly LOGFILE="/var/log/acceptor.log"

#################################################
###### DO NOT CHANGE BELOW THIS POINT ###########
#################################################

print(){
    printf "%s\n" "$@"
}

print_multiline(){
    lines=`echo "$1" | fold  -w 80 -s`
    print "${lines[@]}"
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

#readonly messageKey=$(make_message_key "${MESSAGE[@]}")
#readonly messageKey=$(make_message_key "${MESSAGE[@]}")

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
	    print_multiline "${MESSAGE[@]}"
	    echo ""

	    #readonly userMessageKey="$USER|$messageKey"
	    readonly userMessageKey="$USER|$MESSAGE"

	    readonly hits=`grep -F -c "$userMessageKey" $LOGFILE`

	    if [ $hits == "0" ]; then
		for (( ; ; ))
		do
		    echo "#################################################################################"
		    print_multiline "${PROMPT[@]}"
		    read -p "     >" ACK
		    
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
