@echo off
setlocal enabledelayedexpansion

ECHO Starting

IF "!workingDir!" == "" (
   SET workingDir=C:\Users\Public\Scripts
)
IF "!statusFile!" == "" (
   SET statusFile=status.txt
)
IF "!logFile!" == "" (
   SET logFile=conversionLog.txt
)

IF "!progressFile!" == "" (
	SET progressFile=!tempConvertDir!progress.txt
)

SET "ripProgressFile=ripProgress.txt"
SET tempFile=temp.txt
SET tempFile2=!tempConvertDir!temp2.txt
ECHO Temp File is !tempFile!> !logFile!
ECHO Temp Video Dir is !tempVidDir!>> !logFile!
ECHO Temp Convert Dir is !tempConvertDir!>> !logFile!

cd %workingDir%
ECHO 0 > !ripProgressFile!

REM initialize variables
SET isBonusDisc=FALSE
SET "lastTitleName=none"
SET discInfoFile=discInfo.txt
SET convertSuccess=FALSE
SET showDir=Unknown
SET seperator=_________________________________
SET "TvFolder=J:\Video\TV Shows\"
SET "FilmFolder=J:\Video\Film\"


ECHO Starting > !statusFile!

REM Here we are checking to see which drive has which type of disc
SET vol=
SET discNum=0
ECHO Start>> !logFile!


REM Get optical drives ==================================================
FOR /f "skip=1 tokens=1,2" %%i IN ('wmic logicaldisk get caption^, drivetype') DO (
   IF [%%j]==[5] (
	   IF EXIST %%i\VIDEO_TS\ (
			IF "!preset!" EQU "" (
             SET preset=DVD
			)
         SET drive=%%i
			SET drive=!drive::=!
			ECHO "Detected DVD on drive !drive!" > !statusFile!
			SET discType=DVD
			GOTO dvdInfo
		)
		IF EXIST %%i\BDMV\ (
		   IF "!preset!" EQU "" (
             SET preset=BluRay720
			)
         SET drive=%%i
			SET drive=!drive::=!
			ECHO "Detected Blu-Ray on drive !drive!" > !statusFile!
			SET discType=Blu-Ray
			GOTO volInfo
		)
		SET /A discNum+=1
	)
)

ECHO "No Disc Found" > !statusFile!
GOTO :EOF


REM Get DVD info from Microsoft =========================================
:dvdInfo
IF 1 == 2 (
	ECHO Retrieving DVD info from the web>> !statusFile!
	dvdTitle\DvdInfo.exe %drive% 0 t -f -s > tmpFile
	IF EXIST tmpFile (
		SET /p vol= < tmpFile
		del tmpFile
	)

	SET volError=!vol:unexpected error=!
	IF NOT "!volError!" == "!vol!" (
		ECHO Error Reading Volume Name from Microsoft>> !logFile!
		SET vol=
	)
)

REM set drive and read volume info ======================================
:volInfo
ECHO Analyzing Disc %drive%>> !statusFile!
"C:\Program Files (x86)\MakeMKV\makemkvcon.exe" -r info disc:%discNum% > !discInfoFile!

IF "!vol!" == "" (
  ECHO Reading Disc Name>> !statusFile!
  FIND "CINFO:2,0," !discInfoFile! > "!tempFile!"
  FOR /f "delims=" %%x IN (!tempFile!) DO SET vol=%%x
  IF NOT "!vol!" == "" (
    SET vol=!vol:~10!
  )
)

REM Formatting video filename ===========================================
ECHO Formatting Name %vol%>>!logFile!

REM remove spaces and illegal chars
SET vol=%vol: =_%
SET vol=%vol:"=%
SET "vol=!vol::=_!"
SET "vol=!vol:\=_!"
SET "vol=!vol:/=_!"
SET "vol=!vol:__=_!"


REM remove disc from title name =========================================
SET parseText=%vol%
CALL :parse
SET newVol=!parseText!
SET vol=!parsedDisc!

ECHO Reading info for !drive!>>!logFile!
FOR /F "tokens=1-5*" %%1 IN ('vol !drive!:') DO (
    SET "drvVol=%%6"
	 ECHO Volume name is !drvVol!>>!logFile!
	 goto readVol
)
:readVol
REM use drive volume name to detect TV as well ==========
ECHO Parsing volume>>!logFile!
SET "drvVol=!drvVol:<=!"
SET "drvVol=!drvVol:>=!"
SET parseText=%drvVol%
CALL :parse
SET newdrvVol=!parseText!
SET drvVol=!parsedDisc!
ECHO Converted volume name is %newdrvVol%>>!logFile!

ECHO Title is !newVol!
ECHO !newVol!>discTitle.txt

GOTO :eof


REM Finds words and abbreviations common on Discs
REM Seasons are named _snn where nn is a 2 digit season number 
REM parse ##################################################################################
REM ########################################################################################
:parse
SET parseText=%parseText:_DISC_=_D%
SET parseText=%parseText%##
SET bonusDetect=%parseText%
SET parseText=%parseText:_BONUS##=##%
SET parseText=%parseText:_Bonus##=##%
IF "%bonusDetect%" NEQ "%parseText%" (
   SET isBonusDisc=TRUE
) ELSE (
	SET isBonusDisc=FALSE
)
SET parseText=%parseText:_DISC##=%
SET parseText=%parseText:_Disc##=%
SET parseText=%parseText:_BLU-RAY##=##%
SET parseText=%parseText:_Blu-Ray##=##%
SET parseText=%parseText:_BLURAY##=##%
SET parseText=%parseText:_BluRay##=##%
SET parseText=%parseText:_4X3##=##%
SET parseText=%parseText:_4X3=%
SET parseText=%parseText:_16X9##=##%
SET parseText=%parseText:_16X9=%
SET parseText=%parseText:_FULLSCREEN##=##%
SET parseText=%parseText:_WIDESCREEN##=##%
SET parseText=%parseText:_##=##%
SET parseText=%parseText:-##=##%
SET parseText=%parseText:_##=##%

SET parseText=%parseText:DISC1=%
SET parseText=%parseText:DISC2=%
SET parseText=%parseText:DISC3=%
SET parseText=%parseText:DISC4=%
SET parseText=%parseText:DISC5=%
SET parseText=%parseText:DISC6=%
SET parseText=%parseText:DISC7=%
SET parseText=%parseText:DISC8=%
SET parseText=%parseText:DISC9=%
SET parseText=%parseText:_D##=##%
SET parseText=%parseText:_D0=_D%
SET parseText=%parseText:_DISC_=%
SET parseText=%parseText:_DISC##=##%
SET parseText=%parseText:_D1=%
SET parseText=%parseText:_D2=%
SET parseText=%parseText:_D3=%
SET parseText=%parseText:_D4=%
SET parseText=%parseText:_D5=%
SET parseText=%parseText:_D6=%
SET parseText=%parseText:_D7=%
SET parseText=%parseText:_D8=%
SET parseText=%parseText:_D9=%
SET parseText=%parseText:_##=##%

SET parsedDisc=!parseText:##=!

SET parseText=%parseText:_THE_COMPLETE_SERIES=_s99%
SET parseText=%parseText:_SERIES##=_SERIES_s99##%
SET parseText=%parseText:_THE_COMPLETE_SEASON=_S%
SET parseText=%parseText:_THE_WHOLE_STORY=_s99%
SET parseText=%parseText:_SEASON_=_S%
SET parseText=%parseText:_SEASON##=_S##%
SET parseText=%parseText:_SSN=_S%
SET parseText=%parseText:_S_=_S%

SET parseText=%parseText:D1##=##%
SET parseText=%parseText:D2##=##%
SET parseText=%parseText:D3##=##%
SET parseText=%parseText:D4##=##%
SET parseText=%parseText:D5##=##%
SET parseText=%parseText:D6##=##%
SET parseText=%parseText:D7##=##%
SET parseText=%parseText:D8##=##%
SET parseText=%parseText:D9##=##%

SET parseText=%parseText:SOne=s01%
SET parseText=%parseText:STwo=s02%
SET parseText=%parseText:SThree=s03%
SET parseText=%parseText:SFour=s04%
SET parseText=%parseText:SFive=s05%
SET parseText=%parseText:SSix=s06%
SET parseText=%parseText:SSeven=s07%
SET parseText=%parseText:SEight=s08%
SET parseText=%parseText:SNine=s09%

SET parseText=%parseText:_S1_=_s01_%
SET parseText=%parseText:_S2_=_s02_%
SET parseText=%parseText:_S3_=_s03_%
SET parseText=%parseText:_S4_=_s04_%
SET parseText=%parseText:_S5_=_s05_%
SET parseText=%parseText:_S6_=_s06_%
SET parseText=%parseText:_S7_=_s07_%
SET parseText=%parseText:_S8_=_s08_%
SET parseText=%parseText:_S9_=_s09_%

SET parseText=%parseText:_S1=_s01%
SET parseText=%parseText:_S2=_s02%
SET parseText=%parseText:_S3=_s03%
SET parseText=%parseText:_S4=_s04%
SET parseText=%parseText:_S5=_s05%
SET parseText=%parseText:_S6=_s06%
SET parseText=%parseText:_S7=_s07%
SET parseText=%parseText:_S8=_s08%
SET parseText=%parseText:_S9=_s09%

SET parseText=%parseText:_V1=_s01%
SET parseText=%parseText:_V2=_s01%
SET parseText=%parseText:_V3=_s01%
SET parseText=%parseText:_V4=_s01%
SET parseText=%parseText:_V5=_s01%
SET parseText=%parseText:_V6=_s01%
SET parseText=%parseText:_V7=_s01%
SET parseText=%parseText:_V8=_s01%
SET parseText=%parseText:_V9=_s01%

SET parseText=%parseText:_VOLUME1=_s01%
SET parseText=%parseText:_VOLUME2=_s01%
SET parseText=%parseText:_VOLUME3=_s01%
SET parseText=%parseText:_VOLUME4=_s01%
SET parseText=%parseText:_VOLUME5=_s01%
SET parseText=%parseText:_VOLUME6=_s01%
SET parseText=%parseText:_VOLUME7=_s01%
SET parseText=%parseText:_VOLUME8=_s01%
SET parseText=%parseText:_VOLUME9=_s01%

SET parseText=%parseText:_VOLUME_1=_s01%
SET parseText=%parseText:_VOLUME_2=_s01%
SET parseText=%parseText:_VOLUME_3=_s01%
SET parseText=%parseText:_VOLUME_4=_s01%
SET parseText=%parseText:_VOLUME_5=_s01%
SET parseText=%parseText:_VOLUME_6=_s01%
SET parseText=%parseText:_VOLUME_7=_s01%
SET parseText=%parseText:_VOLUME_8=_s01%
SET parseText=%parseText:_VOLUME_9=_s01%

SET parseText=%parseText:_VOL1=_s01%
SET parseText=%parseText:_VOL2=_s01%
SET parseText=%parseText:_VOL3=_s01%
SET parseText=%parseText:_VOL4=_s01%
SET parseText=%parseText:_VOL5=_s01%
SET parseText=%parseText:_VOL6=_s01%
SET parseText=%parseText:_VOL7=_s01%
SET parseText=%parseText:_VOL8=_s01%
SET parseText=%parseText:_VOL9=_s01%

SET parseText=%parseText:_VOL_1=_s01%
SET parseText=%parseText:_VOL_2=_s01%
SET parseText=%parseText:_VOL_3=_s01%
SET parseText=%parseText:_VOL_4=_s01%
SET parseText=%parseText:_VOL_5=_s01%
SET parseText=%parseText:_VOL_6=_s01%
SET parseText=%parseText:_VOL_7=_s01%
SET parseText=%parseText:_VOL_8=_s01%
SET parseText=%parseText:_VOL_9=_s01%

SET parseText=%parseText:_S1##=##%
SET parseText=%parseText:_S2##=##%
SET parseText=%parseText:_S3##=##%
SET parseText=%parseText:_S4##=##%
SET parseText=%parseText:_S5##=##%
SET parseText=%parseText:_S6##=##%
SET parseText=%parseText:_S7##=##%
SET parseText=%parseText:_S8##=##%
SET parseText=%parseText:_S9##=##%
SET parseText=%parseText:_##=##%
SET parseText=%parseText:##=%
EXIT /B
