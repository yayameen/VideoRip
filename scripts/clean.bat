@echo off
setlocal enabledelayedexpansion

IF "!tempVidDir!" EQU "" (
   SET tempVidDir=G:\TEMP\
)
IF "!tempConvertDir!" EQU "" (
   SET tempConvertDir=J:\TEMP\
)

del "!tempVidDir!*"
del "!tempConvertDir!*"