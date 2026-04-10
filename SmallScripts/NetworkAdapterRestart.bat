@echo off 
echo.

:: Check for permissions
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

:: If error flag set, we do not have admin privileges.
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
	if "%~1"==""  ( GOTO noadaptername )
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    echo UAC.ShellExecute "%~s0", "%1", "", "runas", "" >> "%temp%\getadmin.vbs"
    "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    if exist "%temp%\getadmin.vbs" ( del "%temp%\getadmin.vbs" )
    pushd "%CD%"
    CD /D "%~dp0"

SET adapter=""
if "%~1"=="" ( GOTO noadaptername )

ECHO Disabling network adapter %1...
netsh interface set interface %1 disable
TIMEOUT /T 3 /NOBREAK >nul
ECHO Enabling network adapter %1...
netsh interface set interface %1 enable
TIMEOUT /T 2 /NOBREAK >nul
ECHO Done.
TIMEOUT /T 1 /NOBREAK >nul
exit /B

:noadaptername

ECHO Provide adapter interface name as parameter
ECHO For view list of interfaces name use command:
ECHO netsh interface show interface
ECHO :
PAUSE