# Small scripts

Bash scripts for various purposes

## ClipboardClean.bat

Once Elite Dangerous update brake clipboard capabilities. Ctrl+C and Ctrl+V stopped working after Alt+Tab from game to WebBrowser and back sometimes. This script reset clipboard content and hotkeys worked again. 

## NetworkAdapterRestart.bat

Simply shutdown and initialize some network interface. Why? Because... If be more precisely, because of

usage:

> **NetworkAdapterRestart %Name_OF_Target_Interface%**

***Need to "Run as Administrator***, but if you forget this nuance the script will check it and start again with higher privileges. 

## Currency_From_NBU.ps1

PowerShell script for obtaining exchange rates for different currencies on today's date.

params are (order is important)

\-qr [currencies array] : Specifies the sequence and target currencies id for which the request will be made. Example:
 > \-qr USD EUR
 
 -p : Waits for user input before terminating the script. This should be added at the very end.
 
## Run_CurrencyPs1.ps1

Example of using Currency_From_NBU.ps1