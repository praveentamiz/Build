@echo off

set SITENAME=vlpl
set APPNAME=vlplusmqa
set APPPOOL=vlplusmpoolqa
set PHYSICALPATH=C:\BuildOutput\vlplusmqa

if not exist "%PHYSICALPATH%" mkdir "%PHYSICALPATH%"

echo Creating App Pool...
%windir%\system32\inetsrv\appcmd add apppool /name:%APPPOOL%
%windir%\system32\inetsrv\appcmd set apppool "%APPPOOL%" /managedRuntimeVersion:v4.0

echo Creating Application Under %SITENAME%...
%windir%\system32\inetsrv\appcmd add app /site.name:%SITENAME% /path:/%APPNAME% /physicalPath:"%PHYSICALPATH%"

echo Assigning App Pool...
%windir%\system32\inetsrv\appcmd set app "%SITENAME%/%APPNAME%" /applicationPool:%APPPOOL%

echo Done.
pause