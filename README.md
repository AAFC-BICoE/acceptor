acceptor
========

bash script for acknowledging of login messages &amp; logging acceptance. 

Communicates changes to login users and makes sure users have acknowledged these changes, putting the onus on the user to deal with any impact on their work.

* Run at login with a message that must be accepted by the user before proceeding
* Logs the acceptance
* Only demands acceptance once per user, per message
* Displays message every time
* control-c and control-z disabled

Background
=======
MBB runs clusters for scientific research, supporting AAFC and other scientists in their research.
The software on the Rocks cluster frequently needs to be upgraded to new versions.

**New versions of software can produce different results than earlier versions, given the same inputs.**
This might be problematic if the upgrade occurs in mid-analysis.

In order to mitigate the issues around upgrades and other system changes, `acceptor` introduces a mechanism to inform the user that software has been upgraded, or some other systems change has been implemented, that may impact their work.

**The onus is therefor on the researcher to make sure any changes communicated to them through `acceptor` (messages a login time that need to be acknowledged) do not impact their work, either by using older versions of the software (if available) or contacting systems staff to find another solution (if possible).**



Usage
======
* Put the script in `/etc/profile.d/` (depends on your distro of Linux: you want the script run at login); should be world executable
* Edit the script variable:
    * `MESSAGE`: this is a bash array with your message; can span multiple lines
    * `PROMPT`: this is the prompt that asks the question of the user (i.e. "Acknowledge software X is now version 2.4")
    * `ACCEPT`: the string the user must type in to complete the acknowledgement. Default: `yes`
    * `LOGFILE`: location on filesystem of log file. Must be writable by users. Default: `/var/log/acceptor.log`

Log file Format
======
The log file format:
```
date-time|userid|message-with-line-feeds-removed
```


Copyright, Acknowledgements & Attribution
=====
Copyright 2014 Government of Canada

MIT License (See LICENSE file)
 
Author: Glen Newton glen.newton@agr.gc.ca glen.newton@gmail.com

Developed at: Microbial Biodiversity Bioinformatics Group @ Agriculture and Agri-Food Canada