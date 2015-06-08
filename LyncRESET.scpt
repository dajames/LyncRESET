(*
the purpose of this script is to clear out Lync settings for Macs
:: Created by Daniel James March 11, 2015 at 5:03:51 PM CDT For the College of Applied Health Sciences :: 

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
+++ University of Illinois, Urbana-Champaign ++++
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
*)

display dialog "This is going to clear out your Lync settings. This is for fixing Lync when it quits upon startup." with icon note buttons {"Proceed.", "Let's Not Do This."} default button 1 cancel button 2


try
	tell application "Microsoft Lync" to quit
end try


display dialog "Please give me the account name of the user whose Lync settings we need to clear out." default answer "stevejobs"

-- here I define variables we use later
set punter to text returned of result -- because this is the punter we are looking at

set pittedDate to do shell script "date '+%Y%m%d'"
-- this is a variable that puts todays date in an ASCII friendly way
-- such as 20140812


set UOFI to "/users/" & punter


try
	do shell script "chflags nohidden " & UOFI & "/Library" with administrator privileges
on error
	display dialog "Looking for the Library folder for the new user: " & punter & ". That doesn't appear to be where it should be.  Double check, please."
end try


try
	do shell script "rm -Rf " & UOFI & "/Library/Caches/com.microsoft.Lync/*" with administrator privileges
end try

try
	do shell script "rm -Rf " & UOFI & "/Library/Preferences/ByHost/MicrosoftLyncRegistrationDB*" with administrator privileges
end try

try
	do shell script "rm -Rf " & UOFI & "/Library/Preferences/com.microsoft.Lync*" with administrator privileges
end try

try
	do shell script "rm -Rf " & UOFI & "/Library/Keychains/OC_KeyContainer*" with administrator privileges
end try

-- ++++++++++++++++++++++++++++++++++++++++++++++++++
--- Lastly we'll properly hide the Library files again as should be
-- ++++++++++++++++++++++++++++++++++++++++++++++++++


try
	do shell script "chflags hidden " & UOFI & "/Library" with administrator privileges
end try


delay 1


set reRun to true
set reSpawn to "osascript -e 'tell app " & quote & "loginwindow" & quote & " to «event aevtrrst»'"

display dialog "Done.  Restart your Mac and restart Lync, and that will hopefully do it." with icon note buttons {"Restart Now.", "D'oh. Too Busy. Let's Do It Later."}
if result = {button returned:"Restart Now."} then
	try
		do shell script reSpawn with administrator privileges
	end try
else if result = {button returned:"D'oh. Too Busy. Let's Do It Later."} then
	display dialog "OK. Restart at your own leisure, but Lync won't work until you do." giving up after 3 with icon note buttons {"Okay.", "Super Okay."}
end if

