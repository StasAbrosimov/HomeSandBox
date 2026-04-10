@echo off 
echo.
if "%~1"=="" ( GOTO noadaptername 
) else ( if "%~1"=="__elevated__" ( GOTO noadaptername ))

if "%~2"== "__elevated__" (
	ECHO elevated
	GOTO gotAdmin
)
:: Check for permissions
::>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
net session >nul 2>&1
:: If error flag set, we do not have admin privileges.
if %errorlevel% NEQ 0 (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\NetworkAdapterRestart_getadmin.vbs"
	echo UAC.ShellExecute "cmd", "/c """"%~f0"" ""%~1"" __elevated__""", "", "runas", 1 >> "%temp%\NetworkAdapterRestart_getadmin.vbs"
    ::What a heel is going on Explaned in Readme.md
    "%temp%\NetworkAdapterRestart_getadmin.vbs"
    exit /B

:gotAdmin
    if exist "%temp%\NetworkAdapterRestart_getadmin.vbs" ( del "%temp%\NetworkAdapterRestart_getadmin.vbs" )
    pushd "%CD%"
    CD /D "%~dp0"

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

ECHO Provide adapter interface name as parameter.
ECHO For view list of interfaces name use command:
ECHO.
ECHO netsh interface show interface
ECHO.
PAUSE