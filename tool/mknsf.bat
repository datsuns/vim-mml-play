@echo off

set WORK_DIR=%1
set MML_NAME=%2
set TOOL_NSF2WAV=%3

echo ----------------------
echo PPMCK_BASEDIR=%PPMCK_BASEDIR%
echo NES_INCLUDE=%NES_INCLUDE%
echo DMC_INCLUDE=%DMC_INCLUDE%
echo directory=%WORK_DIR%
echo file=%MML_NAME%
echo ----------------------

if not exist %WORK_DIR%\effect.h goto compile
del %WORK_DIR%\effect.h

:compile
%PPMCK_BASEDIR%\bin\ppmckc -i %WORK_DIR%\%MML_NAME%.mml
if not exist %WORK_DIR%\effect.h goto err

if not exist %WORK_DIR%\ppmck.nes goto assemble
del %WORK_DIR%\ppmck.nes
:assemble
%PPMCK_BASEDIR%\bin\nesasm -s -raw ppmck.asm
if not exist %WORK_DIR%\ppmck.nes goto err

if not exist %WORK_DIR%\%MML_NAME%.nsf goto renam
del %WORK_DIR%\%MML_NAME%.nsf

:renam
ren %WORK_DIR%\ppmck.nes %MML_NAME%.nsf
rem start %1.nsf
del %WORK_DIR%\define.inc
del %WORK_DIR%\effect.h
del %WORK_DIR%\%MML_NAME%.h

%TOOL_NSF2WAV% %WORK_DIR%\%MML_NAME%.nsf %WORK_DIR%\%MML_NAME%.wav
if not exist %WORK_DIR%\%MML_NAME%.wav goto err
powershell -c (New-Object Media.SoundPlayer %WORK_DIR%\%MML_NAME%.wav).PlaySync();
exit 0

:err
exit 1
