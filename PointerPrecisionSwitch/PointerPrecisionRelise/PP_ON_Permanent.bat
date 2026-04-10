@echo off
echo.
pps -on -p
TIMEOUT /T 2 /NOBREAK >nul
rem set /p DUMMY=Hit ENTER to continue...