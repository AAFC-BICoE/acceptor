acceptor
========

bash script for acknowledging of login messages &amp; logging acceptance

Background
=======
MBB runs clusters for scientific research, supporting AAFC and other scientists in their research.
The software on the Rocks cluster periodically needs to be upgraded to new versions.

**___New versions can produce different results than the earlier version, given the same inputs.**
In order to mitigate the issues around upgrades and other system changes, `acceptor` introduces a mechanism to inform the user that software has been upgraded, or some other systems change has been implemented, that may impact their work.
**The onus is therefor on the research to make sure any changes communicated to them through `acceptor` do not impact their work, either by using older versions of the software (if available) or contacting systems staff to find another solution (if possible).**



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