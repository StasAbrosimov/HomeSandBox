# Small scripts

Bash scripts for various purposes

## ClipboardClean.bat

Once Elite Dangerous update brake clipboard capabilities. Ctrl+C and Ctrl+V stopped working after Alt+Tab from game to WebBrowser and back sometimes. This script reset clipboard content and hotkeys worked again. 

## NetworkAdapterRestart.bat

Simply shutdown and initialize some network interface. Why? Because... If be more precisely, because of

usage:

> **NetworkAdapterRestart %Name_OF_Target_Interface%**

***Need to "Run as Administrator"***, but if you forget this nuance the script will check it and start again with higher privileges. 

Explane of next code line

> echo UAC.ShellExecute "cmd", "/c """"%~f0"" ""%~1"" __elevated__""", "", "runas", 1 >> "%temp%\NetworkAdapterRestart_getadmin.vbs"

UAC.ShellExecute - windows function for execution call

- "cmd" - we call cmd.exe;

- \"/c \"\"\"\"%\~f0\"\" \"\"%\~1\"\" \_\_elevated\_\_\"\"\" - parameters for cmd.exe. It is string whits inner quotes. /c - Carries out the command specified by string and then terminates. Next is the **command** in double quotes (that tha way of vbs escapes characters): """"full path to original .bat file"" ""net interface name"" \_\_flag that is admin rights start\_\_""";

- "" - working directory. It will be default for this case "%SystemRoot%\System32";

- "runas" - The action to perform. In this case is "runas" - Launches the app as Administrator;

- 1 - windowStyle. in our case is Normal window

## Currency_From_NBU.ps1

PowerShell script for obtaining exchange rates for different currencies on today's date.

params are (order is important)

\-qr [currencies array] : Specifies the sequence and target currencies id for which the request will be made. Example:
 > \-qr USD EUR
 
 -p : Waits for user input before terminating the script. This should be added at the very end.
 
## Run_CurrencyPs1.ps1

Example of using Currency_From_NBU.ps1
