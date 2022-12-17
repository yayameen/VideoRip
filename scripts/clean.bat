@echo off
setlocal enabledelayedexpansion

IF "!tempVidDir!" EQU "" (
   SET tempVidDir=G:\TEMP\
)
IF "!tempConvertDir!" EQU "" (
   SET tempConvertDir=J:\TEMP\
)

del /F /Q "!tempVidDir!*"
del /F /Q "!tempConvertDir!*"
del /F /Q "discInfo.txt"
del /F /Q "volName.txt"
del /F /Q "rename.txt"