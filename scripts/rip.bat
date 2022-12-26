@echo off
setlocal enabledelayedexpansion

SET "VideoRipVersion=1.3.1"
SET "VideoRipName=VideoRip !VideoRipVersion!"

IF "!workingDir!" == "" (
   SET "workingDir=C:\Users\Public\Scripts"
)
IF "!statusFile!" == "" (
   SET "statusFile=!workingDir!\status.txt"
)
IF "!logFile!" == "" (
   SET "logFile=!workingDir!\conversionLog.txt"
)

REM Erases previous log. Do not change these to write calls
ECHO Starting !VideoRipName!
ECHO Log file is !logFile!
ECHO !VideoRipName! > !logFile!
ECHO !VideoRipName! > !statusFile!


IF "!tempVidDir!" == "" (
   SET tempVidDir=G:\TEMP\
)
ECHO Temp Video Dir is !tempVidDir! >> !logFile!
IF "!tempConvertDir!" == "" (
   SET tempConvertDir=J:\TEMP\
)
ECHO Temp Convert Dir is !tempConvertDir! >> !logFile!
IF "!progressFile!" == "" (
	SET progressFile=!tempConvertDir!progress.txt
)
IF "!TvFolder!" == "" (
	SET "TvFolder=J:\Video\TV Shows\"
)
IF "!FilmFolder!" == "" (
	SET "FilmFolder=J:\Video\Film\"
)
IF "!lang!" == "" (
	SET "lang=eng"
)

SET "ripProgressFile=ripProgress.txt"
SET "tempFile=!workingDir!\temp.txt"
SET "tempFile2=!tempConvertDir!temp2.txt"
ECHO: Temp File is !tempFile! >> !logFile!


REM retain multiple video angles on movie
IF "!keepAngles!" EQU "" (
   SET keepAngles=FALSE
)

IF "!preset!" EQU "" (
   ECHO No preset specified >>!logFile!
) ELSE (
   ECHO preset is !preset! >>!logFile!
)

cd %workingDir%
ECHO 0 > !ripProgressFile!

REM initialize variables
IF "!isBonusDisc!" == "" (
	SET isBonusDisc=FALSE
)
SET "lastTitleName=none"
SET discInfoFile=discInfo.txt
SET volNameFile=volName.txt
SET renameFile=rename.txt
SET convertSuccess=FALSE
SET showDir=Unknown
SET seperator=_________________________________


REM Cleanup last run
IF EXIST "!discInfoFile!" (
	del "!discInfoFile!"
)
IF EXIST "!volNameFile!" (
	del "!volNameFile!"
)
IF EXIST "!renameFile!" (
	del "!renameFile!"
)

REM launch Tail to view progress
IF "!launchTail!"=="TRUE" (
	tasklist /FI "IMAGENAME eq Tail.exe" 2>NUL | FIND /I /N "Tail.exe">NUL
	IF %ERRORLEVEL% NEQ 0 (
		ECHO Launching Tail
		START "" "!workingDir!\Tail.exe" "!logFile!"
	)
)

IF NOT EXIST !tempVidDir! (
   SET tempVidDrive=!tempVidDir:~2!
	IF NOT EXIST !tempVidDrive! (
	   CALL :writeAndLog Ripping Hard Drive Not Found
	) ELSE (
      CALL :writeAndLog Ripping Directory does not exist
	)
	GOTO :final
)

IF NOT EXIST !tempConvertDir! (
   SET tempConvertDrive=!tempConvertDir:~2!
	IF NOT EXIST !tempConvertDrive! (
	   CALL :writeAndLog Video Hard Drive Not Found
	) ELSE (
      CALL :writeAndLog Video Directory does not exist
	)
	GOTO :final
)



REM Here we are checking to see which drive has which type of disc
SET vol=
SET discNum=0

REM Get optical drives ==================================================
FOR /f "skip=1 tokens=1,2" %%i IN ('wmic logicaldisk get caption^, drivetype') DO (
   IF [%%j]==[5] (
	   IF EXIST %%i\VIDEO_TS\ (
			IF "!preset!" == "" (
                      SET preset=DVD
			)
         SET drive=%%i
			SET drive=!drive::=!
			CALL :writeAndLog "Detected DVD on drive !drive!"
			SET discType=DVD
			GOTO dvdInfo
		)
		IF EXIST %%i\BDMV\ (
		   IF "!preset!" == "" (
             SET preset=BluRay720
			)
         SET drive=%%i
			SET drive=!drive::=!
			CALL :writeAndLog "Detected Blu-Ray on drive !drive!"
			SET discType=Blu-Ray
			GOTO volInfo
		)
		SET /A discNum+=1
	)
)

CALL :writeAndLog "No Disc Found"
GOTO :EOF


REM Get DVD info from Microsoft =========================================
:dvdInfo
IF 1 == 2 (
	CALL :writeAndLog "Retrieving DVD info from the web"
	dvdTitle\DvdInfo.exe %drive% 0 t -f -s > tmpFile
	IF EXIST tmpFile (
		SET /p vol= < tmpFile
		del tmpFile
	)

	SET volError=!vol:unexpected error=!
	IF NOT "!volError!" == "!vol!" (
		CALL :writeLog "Error Reading Volume Name from Microsoft"
		SET vol=
	)
) ELSE (
	CALL :writeLog "    Reading volume name from Microsoft DISABLED"
)

REM set drive and read volume info ======================================
:volInfo
CALL :writeAndLog "Using Preset !preset!"
ECHO Reading info for !drive! >>!logFile!
FOR /F "tokens=1-5*" %%1 IN ('vol !drive!:') DO (
    SET "drvVol=%%6"
	 ECHO Volume name is !drvVol! >>!logFile!
	 goto readDiscInfo
)

:readDiscInfo
SET "forceRip=FALSE"
ECHO Analyzing Disc >>!logFile!
CALL :writeLine "Analyzing Disc %drive%"

SET StartDecryptTime=%TIME: =0%
SET StartDecryptTime=%StartDecryptTime:~3,2%
ECHO Disc Decryption Started >>!logFile!
IF NOT EXIST !discInfoFile! ( 
	CALL :getLastLine "!volNameFile!"
	IF NOT "!lastLine!"=="!drvVol!" (
		SET "forceRip=TRUE"
		ECHO !drvVol!> "!volNameFile!"
		"%ProgramFiles(x86)%\MakeMKV\makemkvcon.exe" -r info disc:%discNum% > !discInfoFile!
	)
)

SET EndDecryptTime=%TIME: =0%
SET EndDecryptTime=%EndDecryptTime:~3,2%

ECHO Disc Decryption Complete >>!logFile!
IF !StartDecryptTime! GTR !EndDecryptTime! (
	SET /a DecryptTimeMins=60+!EndDecryptTime!
	SET /a DecryptTimeMins=!DecryptTimeMins!-!StartDecryptTime!
) ELSE (
	SET /a DecryptTimeMins=!EndDecryptTime!-!StartDecryptTime!
)
ECHO Decryption Took !DecryptTimeMins! Min >>!logFile!

REM If decryption takes a long time, then rip the entire DVD in a single
REM operation in order to decrease ripping duration.
REM Not doing the same for Blu-ray because of the large size and possibility
REM of streams being included in multiple titles can cause the output to grow
REM to 100s of GBs.
SET DecryptAllTitles=FALSE
IF !DecryptTimeMins! GTR 3 (
	IF "!discType!"=="DVD" (
		ECHO Decrypting entire disc at once >>!logFile!
		SET DecryptAllTitles=TRUE
	) ELSE (
		CALL :writeAndLog "Ripping will take longer than expected"
	)
)


IF "!vol!" == "" (
   CALL :writeAndLog "Reading Disc Name"
   FIND "CINFO:2,0," !discInfoFile! > "!tempFile!"
   IF !ERRORLEVEL! EQU 0 (
      FOR /f "delims=" %%x IN (!tempFile!) DO SET vol=%%x
      IF NOT "!vol!" == "" (
        SET vol=!vol:~10!
      )
   )
)

REM Formatting video filename ===========================================

REM remove spaces and illegal chars
REM SET "vol=!vol:|=｜!"
REM SET "vol=!vol:>=﹥!"
REM SET "vol=!vol:<=﹤!"

SET "vol=!vol:|=_!"
SET "vol=!vol:>=_!"
SET "vol=!vol:<=_!"
SET "vol=!vol: =_!"
SET "vol=!vol::=_!"
SET "vol=!vol:\=_!"
SET "vol=!vol:/=_!"
SET "vol=!vol:__=_!"
SET vol=!vol:"=!
ECHO Formatted Name is !vol! >>!logFile!

REM remove disc from title name =========================================
SET parseText=%vol%
CALL :parse
SET newVol=!parseText!
SET vol=!parsedDisc!

:readVol
REM use drive volume name to detect TV as well ==========
ECHO Parsing volume>>!logFile!
SET "drvVol=!drvVol:<=!"
SET "drvVol=!drvVol:>=!"
SET parseText=%drvVol%
CALL :parse
SET newdrvVol=!parseText!
SET drvVol=!parsedDisc!
CALL :writeLog "Converted volume name is %newdrvVol%"

IF NOT "!userTitle!" == "" (
	SET "newVol=!userTitle!"
)
SET "showDir=!newVol!"
SET "showDir=!showDir:_= !"
SET "showDir=!showDir:(=!"
SET "showDir=!showDir:)=!"

IF NOT "!titleYear!"=="" (
	SET "showDir=!showDir! (!titleYear!)"
)
IF NOT "!titleSpecialInfo!"=="" (
	SET "showDir=!showDir! (!titleSpecialInfo!)"
)
CALL :writeAndLog "%vol% renamed to %showDir%"
ECHO !seperator!>>!logFile!
ECHO 1 > !ripProgressFile!

CALL :waiting 2

REM Use commanded media type if it exists ===============================
IF EXIST "!tempFile!" (
	del "!tempFile!"
)
SET mediaType 2>"!tempFile!"
Findstr /I "not defined" "!tempFile!" >nul

REM Detect TV by seeing if season rename produced diff name =============
IF !ERRORLEVEL! EQU 0 (
   CALL :writeAndLog "Determining media Type"
   SET "mediaType=TV"
	IF "%newVol%" == "%vol%" (
	   IF "%newdrvVol%" == "%drvVol%" (
	      SET "mediaType=FILM"
		)
	)
)

CALL :writeLog "Ripping !mediaType!"

IF "!mediaType!" == "FILM" (
	SET "vol=!vol:_= !"
	SET "seasonNum="
	IF NOT EXIST "!FilmFolder!!showDir!" (
		ECHO Making folder "!FilmFolder!!showDir!">>!logFile!
      mkdir "!FilmFolder!!showDir!"
	)
   CALL :writeLine "Ripping !mediaType! to !showDir!"
   SET "convertPath=!FilmFolder!!showDir!"

) ELSE (
REM Additional season name processing
   CALL :writeAndLog "   Additional season name processing"
    
    SET "newVol=!newVol:_THE_COMPLETE_=_!"
	SET "newVol=!newVol!##"
	SET "newVol=!newVol: ##=##!"
	SET "newVol=!newVol: ##=##!"
	SET "newVol=!newVol: ##=##!"
	SET "tempText=!newVol:##=!"
	SET "newVol=!newVol:_FIRST_S##=_s01!"
	SET "newVol=!newVol:_SECOND_S##=_s02!"
	SET "newVol=!newVol:_THIRD_S##=_s03!"
	SET "newVol=!newVol:_FOURTH_S##=_s04!"
	SET "newVol=!newVol:_FIFTH_S##=_s05!"
	SET "newVol=!newVol:_SIXTH_S##=_s06!"
	SET "newVol=!newVol:_SEVENTH_S##=_s07!"
	SET "newVol=!newVol:_EIGHTH_S##=_s08!"
	SET "newVol=!newVol:_NINTH_S##=_s09!"
	SET "newVol=!newVol:_TENTH_S##=_s10!"
	SET "newVol=!newVol:_ELEVENTH_S##=_s11!"
	SET "newVol=!newVol:_TWELVTH_S##=_s12!"
	SET "newVol=!newVol:##=!"

	REM If no season is present in the Disc name, use the FS Volume name
	SET "tempSeasonName=!newVol!"
	SET "showDir=!tempSeasonName:~0,-4!"
	
	REM Detect the season number
	
	IF "!seasonNum!"=="" (
		CALL :writeLog "Detecting Season Number"
		IF "!newVol!" == "!tempText!" (
			CALL :writeLog "  Checking Title Name"
			SET "seasonNum=!newdrvVol:~-2!"
			SET "seasonNum=!seasonNum: =0!"
			SET "showDir=!tempSeasonName!"
			IF "!seasonNum!" GTR "99" (
				CALL :writeLog "  Checking For single digit number"
				SET "seasonNum=!newdrvVol:~-1!"
				IF "!seasonNum!" GTR "9" (
					CALL :writeLog "Isn't a 1 digit number. Default to Season 01"
					SET "seasonNum=01"
				) ELSE (
					SET "seasonNum=0!newdrvVol:~-1!"
				)
			) 
			REM SET "newVol=!newVol! - s!seasonNum!"
		) ELSE (
		    CALL :writeLog "   !newVol! doesn't match !tempText!"
			SET "seasonNum=A"
		)

		IF "!seasonNum:~1!" GTR "9" (
			CALL :writeLog "  Checking Volume Name"
			REM set to PLEX format ==================================================
			SET "tempSeasonName=!newVol:_s0= - s0!"
			SET "tempSeasonName=!tempSeasonName:_s1= - s1!"
			SET "tempSeasonName=!tempSeasonName:_s9= - s9!"
			SET "seasonNum=!tempSeasonName:~-2!"
		)

		IF "!seasonNum!" LEQ "0" (
			SET "seasonNum=01"
		)
		CALL :writeLog "Season Number " !seasonNum!
	)
	SET "seasonDir=Season !seasonNum!"
	
	REM No season was detected so we will default to season 99
   REM IF "s" NEQ "!tempSeasonName:~-3,-2!" (
	REM    SET tempSeasonName=!tempSeasonName!_s99
	REM )
   
   
	IF NOT "!userTitle!"=="" (
		SET "showDir=!userTitle!"
	)
	
	IF NOT "!titleYear!"=="" (
		SET "showDir=!showDir! (!titleYear!)"
	)
	IF NOT "!titleSpecialInfo!"=="" (
		SET "showDir=!showDir! (!titleSpecialInfo!)"
	)
   SET "showDir=!showDir:_= !"
   
   REM Remove trailing period (not allowed in dir name) =================
   IF "!showDir:~-1!"=="." (
      SET "showDir=!showDir:~0,-1!"
   )
	IF "!showDir:~-1!"==" " (
      SET "showDir=!showDir:~0,-1!"
   )
   
   IF NOT EXIST "!TvFolder!!showDir!" (
      mkdir "!TvFolder!!showDir!"
   )
   IF NOT EXIST "!TvFolder!!showDir!\!seasonDir!" (
      mkdir "!TvFolder!!showDir!\!seasonDir!"
   )
   CALL :writeLine "Ripping %mediaType% !vol! to !showDir!\!seasonDir!"

   SET "convertPath=!TvFolder!!showDir!\!seasonDir!"
)

CALL :writeLog "   Reading free space on !convertPath:~0,2!"
SET "convertDrive=!convertPath:~0,2!"
CALL :detectLowDriveSpace

REM Count files already converted
SET episodeCount=0
FOR /F "delims=|" %%i in ('dir /b "!convertPath!\*.mkv"') do (
   SET /A episodeCount+=1
)

REM Count double episodes
IF "!mediaType!" == "TV" (
	FOR /F "delims=|" %%i in ('dir /b "!convertPath!\*-e*.mkv"') do (
		SET /A episodeCount+=1
	)
)

REM subtract bonus features from count
SET bonusCount=0
FOR /F "delims=|" %%i in ('dir /b "!convertPath!\*Extra.mkv"') do (
   SET /A bonusCount+=1
	SET /A episodeCount-=1
)

ECHO !seperator!>>!statusFile!

SET lastEpisodeCount=!episodeCount!
SET /A episodeCount+=1

IF !lastEpisodeCount! NEQ 0 (
    CALL :writeLine "Found !lastEpisodeCount! titles already converted."
)
IF !bonusCount! NEQ 0 (
    CALL :writeLine "Found !bonusCount! extras already converted."
)


REM removing trailing spaces ============================================
IF "!newVol:~-1!" == "_" (
   SET "newVol=!newVol:~0,-1!"
)

REM replace underscores with spaces =====================================
SET "newVol=!newVol:_= !"
SET "vol=!newVol!"

IF NOT "!userTitle!" == "" (
	IF NOT "!seasonNum!" == "" (
		SET "vol=!vol! - s!seasonNum!"
	)
)
CALL :writeLine "Filename Format %vol%"

REM Determine if previous process was aborted ===========================
CALL :writeLog "Searching for unconverted videos"
CALL :waiting 3
SET Filesx=0
FOR /F "delims=|" %%i in ('dir /b "!tempVidDir!*.mkv"') do (
   SET /A Filesx+=1
)

SET skipRip=FALSE
IF !Filesx! EQU 0 (
   CALL :writeLog "No unconverted videos found"
) ELSE (
	REM if the disc info file was wrong, these can't be our unconverted videos
	IF NOT "forceRip"=="TRUE" (
		CALL :writeAndLog "!Filesx! unconverted videos found"
		SET skipRip=TRUE
	)
)

IF EXIST "!renameFile!" (
	CALL :writeAndLog "Ripping did not complete"
	SET skipRip=FALSE
	del "!renameFile!"
)

REM Rip the Disc ========================================================
:ripping
CALL :writeLine "Counting titles."
SET titleCount=nul
FIND "TCOUNT" !discInfoFile! > "!tempFile!"
FOR /f "delims=" %%x in (!tempFile!) do SET titleCount=%%x
SET titleCount=!titleCount:~-2!
IF "%titleCount:~0,1%" == ":" (
   SET titleCount=!titleCount:~-1!
)
CALL :writeLine "Found !titleCount! titles."

SET takeFirstTitle=FALSE

:analyzeTitles
REM Analyze titles on disc ==============================================
ECHO    Analyze titles on disc >>"!logFile!"
SET foundMainTitle=!isBonusDisc!
SET badTitle=-1
SET segCount=0
SET i=0
IF "!EpisodeLength!" == "" (
	SET EpisodeLength=UNSET
)
SET forLimit=!titleCount!
SET /A forLimit-=1
del /q "titleList.txt"

CALL :writeLog "Process each title"
FOR /l %%A IN (0, 1, !forLimit!) DO (

   FIND "TINFO:%%A" !discInfoFile! >nul
   IF !ERRORLEVEL! NEQ 0 SET badTitle=%%A
   
   REM Creates a list of segments for this title =======================
	CALL :writeLog "   Create a list of segments for this title:
	SET titleSegCount=0
	SET foundStart=FALSE
   FIND "TINFO:%%A,26,0,""" !discInfoFile! > "!tempFile!"
   IF !ERRORLEVEL! EQU 0 (
      FOR /F "delims=" %%B IN (!tempFile!) DO (
		   SET segText=%%B
			SET segText=!segText:"=_!
		   FOR %%C IN (!segText!) DO (
		      SET "seg=%%C"
				SET "seg2=!seg:_=!"
				IF !seg! NEQ !seg2! (
				   SET foundStart=TRUE
				)
				IF "!foundStart!"=="TRUE" (
		         SET /A titleSegCount+=1
		         SET titleSegList[!titleSegCount!]=!seg2!
				)
         )
	   )
		CALL :writeLog "   Finished processing segment info"
   ) ELSE (
	    CALL :writeAndLog "Could not find title segment info."
	)
	
   REM Skip transport streams with duplicate segments on blu-rays ======
	CALL :writeLog "   Get stream type"
	SET titleNum[!i!]=!episodeCount!
	SET isSubStream=FALSE
	FIND "TINFO:%%A,16,0" !discInfoFile! > "!tempFile!"
	IF !ERRORLEVEL! EQU 0 (
      	FIND "2ts""" "!tempFile!" >nul
      	IF !ERRORLEVEL! EQU 0 (
			SET isSubStream=TRUE
			CALL :writeLog "Found Transport Stream"
		) ELSE (
			FIND "mpls(" "!tempFile!" >nul
      		IF !ERRORLEVEL! EQU 0 (
	      		SET isSubStream=TRUE
				CALL :writeLog "Found Sub Playlist"
	    	)
	)
		
	IF !isSubStream! EQU TRUE (
		FOR /L %%K in (1,1,!titleSegCount!) DO (
		  FOR /L %%E in (1,1,!segCount!) DO (
		    IF !segList[%%E]! == !titleSegList[%%K]! (
		    	ECHO Skipping %%A due to duplicate segment !segList[%%E]! >> !logFile!
                  SET badTitle=%%A
		    )
		  )
		)         
      )
		
	REM Get filename for episode ordering
	CALL :writeLog "   Get filename for episode ordering"
	FOR /f "delims=" %%x IN (!tempFile!) DO SET titleName=%%x
     	SET "titleName=!titleName:~13,-1!"
     	SET "titleName=!titleName:,=!"
     	SET "titleName=!titleName:"=!"
	SET "titleName=!titleName:"=!"
     	SET "titleName=!titleName: =!"
     	SET "titleName=!titleName:	=!"
   	SET "titleName=!titleName:.mpls=.mkv!"
     	SET "titleName=!titleName:.m2ts=ts.mkv!"
		
   )
	
	REM Get output filename===============================================
	CALL :writeLog "   Get output filename"
	FIND "TINFO:%%A,27,0" !discInfoFile! > "!tempFile!"
	IF !ERRORLEVEL! EQU 0 (
	    FOR /f "delims=" %%x IN (!tempFile!) DO SET outputName=%%x
       	SET "outputName=!outputName:~13,-1!"
		SET "outputName=!outputName:"=!"
	 	SET "outputName=!outputName:"=!"

		REM Remove leading comma
		SET "tempChar=!outputName:~0,1!"
		IF "!tempChar!"=="," (
			SET "outputName=!outputName:~1!
		)
		ECHO Output name = !outputName! >> !logFile!    
	) ELSE (
	    CALL :writeAndLog "Could not find title output name."
	)	

	REM Skip titles less than 30 seconds long ============================
	CALL :writeLog "   Get title length"
   FIND "TINFO:%%A,9,0" !discInfoFile! >"!tempFile!"
	IF !ERRORLEVEL! EQU 0 (
		CALL :getLastLine "!tempFile!"
		SET "currentTitleLength=!lastLine:~-9!"
		SET currentTitleLength=!currentTitleLength:"=!
		CALL :writeLog "current title length !currentTitleLength!"
	) ELSE (
		CALL :writeAndLog "Could not determine title length."
		SET "currentTitleLength=0:00:00"
	)
	
   IF "!currentTitleLength!" LSS "0:00:28" (
      CALL :writeLog Skipping %%A "because it is less than 28 sec long"
      SET badTitle=%%A
   )
	
	SET IsBonus=FALSE
   REM Don't convert TV titles longer than twice episode length ==================
	REM These are usually "Play All" sequences ====================================	
   IF !mediaType!==TV (
		CALL :writeLog "   Checking for TV titles longer than twice episode length"
		
		REM Episode length is not yet known.
		REM If this could be an episode, use it to establish the length.
	   IF !EpisodeLength! EQU UNSET (
			FIND """0:19" "!tempFile!" >nul
			IF !ERRORLEVEL! EQU 0 (
            SET EpisodeLength=30
         )		
		   FIND """0:2" "!tempFile!" >nul
			IF !ERRORLEVEL! EQU 0 (
            SET EpisodeLength=30
         )
			FIND """0:3" "!tempFile!" >nul
			IF !ERRORLEVEL! EQU 0 (
            SET EpisodeLength=30
         )
			FIND """0:4" "!tempFile!" >nul
			IF !ERRORLEVEL! EQU 0 (
            SET EpisodeLength=60
         )
			FIND """0:5" "!tempFile!" >nul
			IF !ERRORLEVEL! EQU 0 (
            SET EpisodeLength=60
         )
			FIND """1:0" "!tempFile!" >nul
			IF !ERRORLEVEL! EQU 0 (
            SET EpisodeLength=60
         )
			
			REM Read episode details ===============================================			
			IF !EpisodeLength! NEQ UNSET (
				CALL :writeLog "   Read Episode video details"
				CALL :readEpisodeDetails %%A				
			) ELSE (
				IF "!currentTitleLength!" GTR "1:01:00" (
					IF "!takeFirstTitle!" == "TRUE" (
						CALL :writeLog Adding %%A " multi-episode title"
					) ELSE (
						CALL :writeLog Skipping %%A " due to length"
						SET badTitle=%%A
					)
				) ELSE (
					SET IsBonus=TRUE
					CALL :writeLog Assuming %%A "is bonus due to short length"
				)
			)
		) ELSE (
			REM if we found the episode details,
			REM filter any episodes larger than double length ===========================
			CALL :writeLog "   Filter any episodes larger than double length"
			
			REM Tailor the max episode length to the episode length
			REM Televised shows are usually 22 or 44 minutes long.
			REM Streamed shows could be different.
			IF "!MaxEpisodeLength!"=="" (
			IF !EpisodeLength!==5 (
					IF "!currentTitleLength!" GTR "0:03:30" (
						IF "!currentTitleLength!" LSS "0:10:00" (
							SET "MaxEpisodeLength=0:20:00"
						)		
						IF "!currentTitleLength!" LSS "0:05:00" (
							SET "MaxEpisodeLength=0:10:00"
						)
					)
				)
			    IF !EpisodeLength!==15 (
					IF "!currentTitleLength!" GTR "0:10:00" (
						IF "!currentTitleLength!" LSS "0:19:00" (
							SET "MaxEpisodeLength=0:33:00"
						)		
						IF "!currentTitleLength!" LSS "0:15:00" (
							SET "MaxEpisodeLength=0:30:00"
						)
						IF "!currentTitleLength!" LSS "0:12:00" (
							SET "MaxEpisodeLength=0:24:00"
						)
					)
				)
				IF !EpisodeLength!==30 (
					IF "!currentTitleLength!" GTR "0:19:00" (
						IF "!currentTitleLength!" LSS "0:36:00" (
							SET "MaxEpisodeLength=1:10:00"
						)		
						IF "!currentTitleLength!" LSS "0:30:00" (
							SET "MaxEpisodeLength=1:00:00"
						)
						IF "!currentTitleLength!" LSS "0:25:00" (
							SET "MaxEpisodeLength=0:50:00"
						)
						IF "!currentTitleLength!" LSS "0:23:00" (
							SET "MaxEpisodeLength=0:46:00"
						)
					)
				)
				IF !EpisodeLength!==60 (
					IF "!currentTitleLength!" GTR "0:39:30" (
						IF "!currentTitleLength!" LSS "1:10:00" (
							SET "MaxEpisodeLength=2:00:00"
						)		
						IF "!currentTitleLength!" LSS "1:00:00" (
							SET "MaxEpisodeLength=1:50:00"
						)
						IF "!currentTitleLength!" LSS "0:50:00" (
							SET "MaxEpisodeLength=1:40:00"
						)
						IF "!currentTitleLength!" LSS "0:46:00" (
							SET "MaxEpisodeLength=1:30:00"
						)
					)
				)
				IF NOT "!MaxEpisodeLength!"=="" (
					CALL :writeLog "Detected maximum episode length !MaxEpisodeLength!"
				)
			)
			
			REM If we have an estimated max length, use it to filter titles
			IF NOT "!MaxEpisodeLength!"=="" (
				IF "!currentTitleLength!" GTR "!MaxEpisodeLength!" (
					SET badTitle=%%A
					CALL :writeLog Skipping %%A "because its length exceeds !MaxEpisodeLength!"
				)
			) ELSE (			
				REM title is over 1.5 hour. Too long unless < 1.5 for 1 hr ep
				IF !EpisodeLength! EQU 60 (
					IF "!currentTitleLength!" GTR "1:35:00" (
						SET badTitle=%%A
						CALL :writeLog Skipping %%A "because its length exceeds 1.5 hours"
					)
				)
				IF !EpisodeLength! EQU 30 (
				REM title is over an hour. Assume its too long for 30 min ep
					IF "!currentTitleLength!" GTR "0:59:00" (
						SET badTitle=%%A
						CALL :writeLog Skipping %%A "because its length exceeds 1 hour"
					)
				)
				IF !EpisodeLength! EQU 15 (
				REM title is over an hour. Assume its too long for 15 min ep
					IF "!currentTitleLength!" GTR "0:29:40" (
						SET badTitle=%%A
						CALL :writeLog Skipping %%A "because its length exceeds 30 min"
					)
				)
				IF !EpisodeLength! EQU 5 (
				REM title is over an hour. Assume its too long for 5 min ep
					IF "!currentTitleLength!" GTR "0:14:00" (
						SET badTitle=%%A
						CALL :writeLog Skipping %%A "because its length exceeds 15 min"
					)
				)
			)
			
			REM We haven't yet read episode details
			IF "!episodeVideoSize!" == "" (
				REM only read details if this is an episode
				IF !badTitle! NEQ %%A (
					IF "!currentTitleLength!" GTR "0:19:00" (
						CALL :readEpisodeDetails %%A				
					)
				)
			)
			
			REM The title is within length restrictions for an episode.
			REM See if there are differences in video info.
			REM We could also check for number of unique audio laguages in the future.
			CALL :writeLog "   See if there are differences in video info"
			IF !badTitle! NEQ %%A (
			
				REM Check the video frame size ===============================================
				IF NOT "!episodeVideoSize!" == "" (
					SET "tempData="
					FIND "SINFO:%%A,0,19,0" !discInfoFile! > "!tempFile!"
					IF !ERRORLEVEL! EQU 0 (
						CALL :getLastLine "!tempFile!"
						SET tempData=!lastLine:~15!
						SET tempData=!tempData:,=!
					)
					
					IF !tempData! NEQ !episodeVideoSize! (
						SET IsBonus=TRUE
						CALL :writeLog Assuming %%A "is bonus due to !tempData! video size"
						
					)
				)
				
				REM check the video aspect ratio =============================================
				IF NOT "!episodeAspect!" == "" (
					SET "tempData="
					FIND "SINFO:%%A,0,20,0" !discInfoFile! > "!tempFile!"
					IF !ERRORLEVEL! EQU 0 (
						CALL :getLastLine "!tempFile!"
						SET tempData=!lastLine:~15!
						SET tempData=!tempData:,=!
					)
					
					IF NOT !tempData! == !episodeAspect! (
						SET IsBonus=TRUE
						CALL :writeLog Assuming %%A "is bonus due to !tempData! aspect ratio"
						
					)
				)
				
				REM check the video frame rate ===============================================
				IF NOT "!episodeFrameRate!" == "" (
					SET "tempData="
					FIND "SINFO:%%A,0,21,0" !discInfoFile! > "!tempFile!"
					IF !ERRORLEVEL! EQU 0 (
						CALL :getLastLine "!tempFile!"
						SET tempData=!lastLine:~15!
						SET tempData=!tempData:,=!
					)
					
					IF NOT !tempData! == !episodeFrameRate! (
						SET IsBonus=TRUE
						CALL :writeLog Assuming %%A "is bonus due to !tempData! frame rate"
						
					)
				)
				
				REM Check number of audio languages ============================================
				CALL :countLang %%A
				IF !episodeLangCount! GTR !audioLangCount! (
					SET IsBonus=TRUE
					CALL :writeLog Assuming %%A "is bonus due to missing audio language"
				)
				
				REM Check number of subtitle languages ============================================
				IF !episodeSubLangCount! GTR !subtitleLangCount! (
					SET IsBonus=TRUE
					CALL :writeLog Assuming %%A "is bonus due to missing subtitle language"
				)

				REM Detect bonus features by their short length ===============================
				IF !EpisodeLength! EQU 60 (
					IF "!currentTitleLength!" LSS "0:40:00" (
						SET IsBonus=TRUE
						CALL :writeLog Assuming %%A "is bonus due to short length"
					)
				) ELSE (
				REM title is over an hour. Assume its too long for 30 min ep ===================
					IF "!currentTitleLength!" LSS "0:19:00" (
						SET IsBonus=TRUE
						CALL :writeLog Assuming %%A "is bonus due to short length"
					)
				)
			)
		)
   ) ELSE (
		REM Don't add multiple 1.5 hour titles from a movie ====================================
		ECHO    Detect multiple 1.5 hour titles from a movie >> !logFile!
		SET foundTitle=FALSE
	   IF "!currentTitleLength!" GEQ "1:25:00" (
		   SET foundTitle=TRUE
			CALL :writeLog "Found movie length title"

			IF NOT !multiTitle! == TRUE (

				REM Match the user supplied length. ========
				REM This is only needed for Lions Gate, which adds multiple playlists to trick you.
				REM Also can be used to select a particular edition of the film.
				IF NOT "!userLength!"=="" (
					
					SET subLength=!currentTitleLength:~0,4!
					CALL :writeLog "   Checking for title length match !userLength!"
					IF "!userLength!"=="!subLength!" (
						CALL :writeLog "Found title that matched user length"
						SET foundTitle=TRUE
					) ELSE (
						REM round titles up to the next minute
						SET secondsLength=!currentTitleLength:~5,2!
						SET minutesLength=!currentTitleLength:~2,2!
						SET /A minutesLength+=1
						IF !minutesLength! == 60 (
							SET "minutesLength=00"
						)
						IF !minutesLength! LSS 10 (
						    SET "subLength=!currentTitleLength:~0,2!0!minutesLength!"
						) ELSE (
						    SET "subLength=!currentTitleLength:~0,2!!minutesLength!"
						)
						IF "!userLength!"=="!subLength!" (
							CALL :writeLog "Found title that rounded up to user length !subLength!" 
							SET foundTitle=TRUE
						) ELSE (
						      IF NOT !takeFirstTitle! == TRUE (
								SET foundTitle=FALSE
								SET badTitle=%%A
								CALL :writeLog "    Skipping title due to wrong length !subLength!"
							) ELSE (
								CALL :writeLog "    Using first title even though title does not match user length"
								SET foundTitle=TRUE
							)
						)
					)
				) ELSE (
					REM Find the number of chapters
					REM if chapters >= 15 then this could be the movie
					REM Skip chapter requirement if no title was found ================================
					CALL :writeLog "   Find the number of chapters"
					IF NOT !takeFirstTitle! == TRUE (
						IF !foundTitle! EQU TRUE (
							FIND "TINFO:%%A,8,0," !discInfoFile! > "!tempFile2!"
							IF !ERRORLEVEL! EQU 0 (
								SET foundTitle=FALSE
							
								REM get chapter count
								CALL :getLastLine "!tempFile!"
								SET chapterCount=!lastLine:~-3!
								SET chapterCount=!chapterCount:"=!
						
								REM check result
								IF !chapterCount! GEQ 10 (
									SET foundTitle=TRUE
									CALL :writeLog "Video has !chapterCount! chapters"
								) ELSE (
									CALL :writeLog "Video has too few chapters !chapterCount!"
									SET badTitle=%%A
								)
							) ELSE (
								CALL :writeLog "No chapter count for video"
								SET chapterCount=1
								SET badTitle=%%A
							)
						)
					)
				)
			)
		) ELSE (
			SET IsBonus=TRUE
		)
		
		FIND "SINFO:%%A," !discInfoFile! > "!tempFile!"		
		FOR /F %%L IN (!tempFile!) DO SET audioChannelCount=%%L
		
		SET "filterTitle=FALSE"
		IF !foundTitle! EQU TRUE (
			IF NOT !multiTitle! == TRUE (
				SET "filterTitle=TRUE"
			)
		)
		
		REM check for movie video details =====================================================
		ECHO    Check for movie video details >> !logFile!
		IF !filterTitle! == TRUE (
			REM See if this video is square screen or wide screen
		   FIND "SINFO:%%A,0,20" !discInfoFile! > "!tempFile2!"
		   FIND "4:3" "!tempFile2!" > nul
			IF !ERRORLEVEL! EQU 0 (
				REM Set full screen as main title
			   IF !foundMainTitle! EQU FALSE (
					CALL :writeAndLog "Found Full screen Title."
					SET foundMainTitle=MAYBE
					SET mainTitleLength=!currentTitleLength!
					SET mainAudioChannelCount=!audioChannelCount!
				) ELSE (
					REM replace full screen title if this one has 2 more audio channels
					IF !foundMainTitle! EQU MAYBE (
						SET /A tempChannelCount=!audioChannelCount! - 1
						IF !tempChannelCount! GTR !mainAudioChannelCount! (
							CALL :writeAndLog "Choosing New Full Screen Title Due To Audio Channels."
							SET foundMainTitle=MAYBE
							SET mainTitleLength=!currentTitleLength!
							SET mainAudioChannelCount=!audioChannelCount!
						) ELSE (
							REM replace full screen title if this one is longer
							IF !currentTitleLength! GTR !mainTitleLength! (
								CALL :writeAndLog "Choosing New Full Screen Title Due To Length."
								SET foundMainTitle=MAYBE
								SET mainTitleLength=!currentTitleLength!
								SET mainAudioChannelCount=!audioChannelCount!
							) ELSE (
								CALL :writeAndLog "   Skipping title %%A because it is over 1.5 hours."
								SET badTitle=%%A
							)
						)
					) ELSE (
						REM don't replace wide screen with full
						CALL :writeAndLog "Skipping title %%A because it is full screen."
						SET badTitle=%%A
					)
				)
         ) ELSE (
				REM Set the main title
				IF NOT !foundMainTitle! == TRUE (
					CALL :writeAndLog "Found Main Title."
					SET foundMainTitle=TRUE
					SET mainTitleLength=!currentTitleLength!
					SET mainAudioChannelCount=!audioChannelCount!
				) ELSE (
					REM replace main title if this one has 2 more audio channels
					SET /A tempChannelCount=!audioChannelCount! - 1
					IF !tempChannelCount! GTR !mainAudioChannelCount! (
						CALL :writeAndLog "Choosing New Main Title Due To Audio Channels."
						SET foundMainTitle=TRUE
						SET mainTitleLength=!currentTitleLength!
						SET mainAudioChannelCount=!audioChannelCount!
					) ELSE (						
						REM Replace the main title if this one is longer
						IF !currentTitleLength! GTR !mainTitleLength! (
							IF !chapterCount! GTR 1 (
								CALL :writeAndLog "Choosing New Main Title Due To Title Length."
								SET foundMainTitle=TRUE
								SET mainTitleLength=!currentTitleLength!
								SET mainAudioChannelCount=!audioChannelCount!
							) ELSE (
								CALL :writeAndLog "Skipping title %%A due to length and chapters."
								SET badTitle=%%A
							)
						) ELSE (
							CALL :writeAndLog "Skipping title %%A because it is over 1.5 hours long."
							SET badTitle=%%A
						)
					)
				)
			)
		)
	)
	
   REM Filter by language unless we are selecting the first title==========
	ECHO    Filter by language >> !logFile!
	IF "!discType!"=="Blu-Ray" (
		IF NOT !takeFirstTitle! == TRUE (
			FIND "SINFO:%%A," !discInfoFile! > "!tempFile!"	
			IF !ERRORLEVEL! EQU 0 (
				REM if there no french but there is japanese, this is likely a duplicate
				REM title with more languages
				FIND ",3,0,""fra" "!tempFile!" >nul
					IF !ERRORLEVEL! EQU 1 (
				  FIND ",3,0,""jpn" "!tempFile!" >nul
				  IF !ERRORLEVEL! EQU 0 (
					  CALL :writeLog Skipping %%A "due to japanese language"
					  SET badTitle=%%A
				  )
				)
				FIND ",3,0,""!lang!" "!tempFile!" >nul
				IF !ERRORLEVEL! NEQ 0 (
					FIND ",3,0,""und" "!tempFile!" >nul
					IF !ERRORLEVEL! EQU 0 (
						CALL :writeAndLog "Undertermined language on" %%A
					) ELSE (
						CALL :writeAndLog "Skipping" %%A "due to lack of !lang! language."
						SET badTitle=%%A
					)
				)
			)
		)
	)

	REM Add accepted titles to convert list ==============================	
     IF !badTitle! NEQ %%A (
         
		ECHO Add accepted title to convert list >> !logFile!
		REM Add 'z' to title to make bonus feature move to the end
		IF !IsBonus! EQU TRUE (
                IF "!titleName!"=="" (
                    SET "titleName=!outputName!"
                )
			SET titleName=!titleName:"=!
			SET titleName=!titleName:"=!
			
			SET "titleName=z!titleName!"
			
		   CALL :writeLog "Found extra feature !i! !titleName!"
	      ) ELSE (
               REM Decrypting all titles means we need to move the files.
               REM This is done using the rename file list
               IF !DecryptAllTitles! EQU TRUE (
                   IF "!titleName!"=="" (
                       SET "titleName=!outputName!"
                   )
			   SET titleName=!titleName:"=!
			   SET titleName=!titleName:"=!
               )
           )
		
		REM if duplicate name is detected, hopefully consecutive
		REM it may be a second angle of the same film.
		REM TODO: On Blu-rays, we could look at the filename
		ECHO    Detect 2nd Angle >> !logFile!
		FIND "TINFO:%%A,30,0," !discInfoFile! > "!tempFile!"	
		CALL :getLastLine "!tempFile!"
		
		SET "titleDescription=!lastLine=~16,-2"
		IF NOT "!titleDescription:(angle=!"=="!titleDescription!" (
			IF NOT !keepAngles! == TRUE (
			     CALL :writeAndLog "Skipping additional angle."
			     SET badTitle=%%A
			 ) ELSE (
			     CALL :writeAndLog "Adding additional angle."
		        SET titleName=A!titleName!
			)
		) ELSE (
			IF !lastTitleName! == !titleName! (
			  CALL :writeLog "titlename !lastTitleName! matched !titleName!"
				IF NOT !keepAngles! == TRUE (
					 CALL :writeAndLog "Skipping second angle."
					 SET badTitle=%%A
				 ) ELSE (
					 CALL :writeAndLog "Adding second angle."
					SET titleName=A!titleName!
			  )
			) ELSE (
			   IF !IsBonus! EQU TRUE (
				 ECHO: Adding Extra Feature %%A>>!statusFile!
				) ELSE (
				  ECHO: Adding title %%A>>!statusFile!
				)
			)
		)
		
		REM See if this title was marked to be skipped "bad"
		IF !badTitle! NEQ %%A (
			REM save the output name in order to rename this file
			
			IF NOT "!titleName!"=="" (
				REM SET "titleName=!titleName:(=!"
				REM SET "titleName=!titleName:)=!"
		   		ECHO !outputName!#!titleName!>> !renameFile!
			)
			
			REM remember the last filename to detect multiple angles
			IF "!discType!" == "Blu-Ray" (
		       SET lastTitleName=!titleName!
			)
	
			SET /A i+=1
			SET /A episodeCount+=1
			SET titleList[!i!]=%%A
			ECHO %%A >> titleList.txt
		)
		
		REM Create a list of segments already processed
		FOR /L %%K in (1,1,!titleSegCount!) DO (
		   SET /A segCount+=1
	      SET segList[!segCount!]=!titleSegList[%%K]!
			REM ECHO Processed segment !titleSegList[%%K]!>> !logFile!
	   )
		
		SET "titleName="
   )
)

REM If we didn't find the movie's title, take the first one.
ECHO    Check if we found the movie title >> !logFile!
IF !mediaType!==FILM (
   IF !isBonusDisc! EQU FALSE (
      IF !foundMainTitle! EQU FALSE (
	      IF !takeFirstTitle! EQU FALSE (
			CALL :writeLog "We didn't find the movie's title, take the first one"
			del "titleList.txt"
			SET takeFirstTitle=TRUE
			SET episodeCount=!lastEpisodeCount!
			ECHO !seperator! >> !statusFile!
			CALL :writeAndLog "Reprocessing..."
			GOTO :analyzeTitles
		) ELSE (
			SET isBonusDisc=TRUE
			CALL :writeLog "We didn't find the movie's title. Assuming bonus disc"
                  ECHO !seperator! >> !statusFile!
            )
        )
    )
)

IF !mediaType!==TV (
   IF !isBonusDisc! EQU FALSE (
      IF !i! EQU 0 (
	      IF !takeFirstTitle! EQU FALSE (
				CALL :writeLog "We didn't find any episodes, take the first one"
				del "titleList.txt"
				SET takeFirstTitle=TRUE
				SET episodeCount=!lastEpisodeCount!
				ECHO !seperator! >> !statusFile!
				CALL :writeAndLog "Reprocessing..."
			   GOTO :analyzeTitles
			) ELSE (
				SET isBonusDisc=TRUE
				CALL :writeLog "We didn't find any episodes. Assuming bonus disc"				
				ECHO !seperator! >> !statusFile!
			)
		)
	)
)

ECHO !seperator! >> !statusFile!

IF EXIST !discInfoFile! (
	del last!discInfoFile!
	move !discInfoFile! last!discInfoFile!   
)

IF !skipRip!==TRUE (
   ECHO Unconverted videos found. Encoding >> !statusFile!
   GOTO :converting
)

REM Rip titles from convert list ========================================
ECHO Rip titles from convert list >> !logFile!

CALL :writeAndLog "!i! titles selected."
SET progressDiv=!i!
CALL :waiting 3

SET ripCount=0

SET "MakeMKVDir=MakeMKV"
IF !DecryptAllTitles!==TRUE (
	ECHO: Ripping All Titles for speed >>!logFile!
	md !tempVidDir!del
	ECHO: "%ProgramFiles(x86)%\!MakeMKVDir!\makemkvcon.exe" -r --messages="!tempFile!" --progress=-same mkv disc:%discNum% all !tempVidDir!del >>!logFile!
	START "" /MIN /BELOWNORMAL "%ProgramFiles(x86)%\!MakeMKVDir!\makemkvcon.exe" -r --messages="!tempFile!" --progress=-same mkv disc:%discNum% all !tempVidDir!del
		
	CALL :waiting 3
	IF ERRORLEVEL 1       (
		ECHO ERROR>>!statusFile!
		goto :eof
	)
	CALL :waitingForMKV

	FOR /f "delims=" %%w in (!renameFile!) DO (
 	  SET newName=%%w
		REM SET newName=!newName:#=" "..\!
		CALL SET newName=%%newName:#=" "%tempVidDir%%%

		REM quotes screw up rename
		SET "newName=!newName:'=?!"
		SET "newName=!newName:,=?!"
 	     ECHO: rename "!tempVidDir!!newName!" >> !logFile!
		move "!tempVidDir!del\!newName!"
		IF NOT !ERRORLEVEL! EQU 0 (
			IF !mediaType!==TV (
				ECHO RENAMING FAILURE >> !statusFile!
				GOTO :eof
			)
		)
	)
	CALL :waiting 1
	del /F /S /Q !tempVidDir!del
	GOTO :converting
)

FOR /f "UseBackQ delims=" %%i IN (titleList.txt) DO (

	IF EXIST "!tempFile!" (
		del /q "!tempFile!"
	)
   ECHO   !TIME:~0,2!^:!TIME:~3,2! - Ripping Title %%i>> !statusFile!
	IF EXIST "!progressFile!" (
		del "!progressFile!"
	)
	
	REM Skip files already ripped	
	IF !ripCount! GEQ !Filesx! (
		START "" /MIN /BELOWNORMAL "%ProgramFiles(x86)%\!MakeMKVDir!\makemkvcon.exe" -r --messages="!tempFile!" --progress=-same mkv disc:%discNum% %%i !tempVidDir!
		
		CALL :waiting 3
		IF ERRORLEVEL 1       (
			ECHO ERROR>>!statusFile!
			goto :eof
		)
		CALL :waitingForMKV
	)
	
	SET /A ripCount+=1
	SET /A ripProgressPercent=!ripCount! * 20
	SET /A ripProgressPercent/=!progressDiv!
	ECHO !ripProgressPercent!> !ripProgressFile!
)
SET Filesx=!ripCount!

:renaming
ECHO !seperator!>> !statusFile!
del /q "titleList.txt"
ECHO 20 > !ripProgressFile!

REM Rename titles ======================================================

ECHO renaming files %plusTime%>> !statusFile!

REM The first rename sorts files alphabetically ===========================
REM This gives the best chance for TV shows to be in correct order ========
FOR /f "delims=" %%w in (!renameFile!) DO (
   SET newName=%%w
	SET newName=!newName:#=" "!

	REM quotes screw up rename
	SET "newName=!newName:'=?!"
	SET "newName=!newName:,=?!"
      ECHO: rename "!tempVidDir!!newName!" >> !logFile!
	ren "!tempVidDir!!newName!"
	IF NOT !ERRORLEVEL! EQU 0 (
		IF !mediaType!==TV (
			ECHO RENAMING FAILURE >> !statusFile!
			GOTO :eof
		)
	)
)
CALL :waiting 1

REM Converting titles ====================================================
:converting

SET plusTime=%TIME:~3,2%
SET plusTime=%plusTime: =0%

SET index=!lastEpisodeCount!

REM Assume seasons contain less than 0 episodes ===========================
REM Start numbering at 1
IF !mediaType!==TV (
    SET /A index+=1
)

IF !mediaType!==TV (
   SET sep=e
) ELSE (
    SET "sep= - pt"
)

REM Assume there are less than 200 episodes in a TV season ================
REM Start numbering at 200 for extra features
IF !mediaType!==TV (
	SET /A "BonusIndex=bonusCount+200"
) ELSE (
	SET /A "BonusIndex=bonusCount+10"
)

REM rename the files to follow PLEX standards =============================
FOR /F "delims=|" %%i in ('dir /b /O:N !tempVidDir!*.mkv*') DO (
   SET orig=%%i
   ECHO processing file !orig! >> !logFile!
	SET orig=!orig:~0,1!
	IF "!orig!"=="z" (
	   SET /A BonusIndex+=1
		REM name bonus material as extras
		IF !mediaType!==TV (
			IF NOT EXIST "!vol!!sep!!BonusIndex! - !plusTime! Extra.mkv" (
		      	ECHO %%i to "!vol!!sep!!BonusIndex! - !plusTime! Extra.mkv">> !logFile!
          			ren "!tempVidDir!%%i" "!vol!!sep!!BonusIndex! - !plusTime! Extra.mkv"
			)
		) ELSE (
			IF NOT EXIST "!vol! - !BonusIndex! - !plusTime! Extra.mkv" (
		      	ECHO %%i to "!vol! - !BonusIndex! - !plusTime! Extra.mkv">> !logFile!
          			ren "!tempVidDir!%%i" "!vol! - !BonusIndex! - !plusTime! Extra.mkv"
			)
		)
	) ELSE (
	   REM rename films to parts after the first title
		CALL :setEpisodeNum !index!
		
		IF !mediaType!==TV (
			REM Get video length ==================================================
			MediaInfo\MediaInfo.exe --Inform=General;%%Duration%% "!tempVidDir!%%i" > del.txt
			SET /p videoLength=<del.txt
			del del.txt

			SET "episodeNumText=!episodeNum!"

			REM Check for double episodes
			IF !EpisodeLength! EQU 60 (
				IF !videoLength! GTR 4200000 (
					SET /A index+=1
					CALL :setEpisodeNum !index!
					SET "episodeNumText=!episodeNumText!-e!episodeNum!"
				)
			)
			IF !EpisodeLength! EQU 30 (
				IF !videoLength! GTR 2400000 (
					SET /A index+=1
					CALL :setEpisodeNum !index!
					SET "episodeNumText=!episodeNumText!-e!episodeNum!"
				)
			)

			IF NOT EXIST "!vol!!sep!!episodeNumText! - !plusTime! Title.mkv" (
				ECHO %%i to "!vol!!sep!!episodeNum! - !plusTime! Title.mkv">> !logFile!
				ren "!tempVidDir!%%i" "!vol!!sep!!episodeNumText! - !plusTime! Title.mkv"
			)
		) ELSE (
		   REM if there is more than 1 part to a film then number them
		   IF !episodeNum! GTR 1 (
			IF NOT EXIST "!vol!!sep!!episodeNum!.mkv" (
		      	ECHO %%i to "!vol!!sep!!episodeNum!.mkv">> !logFile!
            		ren "!tempVidDir!%%i" "!vol!!sep!!episodeNum!.mkv"
			)
		   ) ELSE (
			IF NOT EXIST "!vol!.mkv" (
			   	ECHO %%i to "!vol!.mkv">> !logFile!
            		ren "!tempVidDir!%%i" "!vol!.mkv"
			)
		   )
		)
	)
   SET /A index+=1
)
CALL :waiting 3
IF EXIST "!renameFile!" (
	del "!renameFile!"
)

ECHO !seperator! >> !statusFile!

ECHO Converting files>> !statusFile!
ECHO !seperator!>> !statusFile!
SET index=1
SET ripSuccess=False
SET convertSuccess=TRUE
FOR /F "delims=|" %%i IN ('dir /b "!tempVidDir!*.mkv"') DO (
  SET ripSuccess=TRUE

  REM Get video length ==================================================
  MediaInfo\MediaInfo.exe --Inform=General;%%Duration%% "!tempVidDir!%%i" > del.txt
  SET /p videoLength=<del.txt
  del del.txt

  ECHO video length of %%i is !videoLength!>> !logFile!
  
  IF !videoLength! GEQ 999999999 (
     ECHO error reading video length !videoLength!>> !statusFile!
     CALL :waiting 3
  )
  
  REM Convert file with HandBrake =========================================
   
	IF EXIST "!progressFile!" (
		del "!progressFile!"
	)
	
	ECHO   !TIME:~0,2!^:!TIME:~3,2! - Converting !index! of !Filesx! "%%i" >> !statusFile!
	SET "videoIsConverted=FALSE"
	IF EXIST "!tempConvertDir!%%i" (	
	   REM Compare video lengths to deterine success. Allow 2 second margin of error
	   MediaInfo\MediaInfo.exe --Inform=General;%%Duration%% "!tempConvertDir!%%i" > del.txt
      SET /p outputVideoLength=<del.txt
		
		REM randomly Handbrake files are 11 sec shorter?
		REM maybe it is trimming black frames or audio is longer than video
		SET /A outputVideoLength=!outputVideoLength! + 12
		
		IF !outputVideoLength! GEQ !videoLength! (
			SET "videoIsConverted=TRUE"
		)
	)
	
	IF !videoIsConverted!==FALSE (
		START "" /MIN /BELOWNORMAL cmd /c ""C:\Program Files\HandBrake\HandBrakeCLI.exe" --preset-import-file "!preset!.json" -Z "%preset%" -i "!tempVidDir!%%i" -o "!tempConvertDir!%%i"" ^> !progressFile!
		CALL :waiting 3
		CALL :waitingForHB
	
		SET "outputVideoLength=0"
		REM verify a file was produced ========================================
		IF EXIST "!tempConvertDir!%%i" (
		
			REM Compare video lengths to deterine success. Allow 2 second margin of error
			MediaInfo\MediaInfo.exe --Inform=General;%%Duration%% "!tempConvertDir!%%i" > del.txt
			SET /p outputVideoLength=<del.txt
			
			REM randomly Handbrake files are a little shorter?
			REM maybe it is trimming black frames or audio is longer than video
			SET /A outputVideoLength=!outputVideoLength! + 4000
			
			IF !outputVideoLength! GEQ !videoLength! (
				SET "videoIsConverted=TRUE"
				IF !convertSuccess!==TRUE (
					SET "convertSuccess=TRUE"
				)
			) ELSE (
				CALL :writeAndLog Converted video too short "!outputVideoLength!"
			)
		) ELSE (
			CALL :writeAndLog Conversion FAILED______________
		)
	)
	
	IF !videoIsConverted!==TRUE (
		REM Break films into main title and features for PLEX ==============
		REM Move files to PLEX folders
		IF !mediaType!==FILM (
			IF !videoLength! LEQ 5000000 (
				IF NOT EXIST "!convertPath!\Behind The Scenes" (
					mkdir "!convertPath!\Behind The Scenes"
				)
				ECHO move to "!convertPath!\Behind The Scenes\%%i" >> !logFile!
				move /Y "!tempConvertDir!%%i" "!convertPath!\Behind The Scenes"
			) ELSE (
				ECHO move to "!convertPath!\%%i">> !logFile!
				move /Y "!tempConvertDir!%%i" "!convertPath!"
			)
		) ELSE (
			ECHO move to "!convertPath!\%%i">> !logFile!
			move /Y "!tempConvertDir!%%i" "!convertPath!"
		)
	  del "!tempVidDir!%%i"
   ) ELSE (
	   ECHO Video conversion failed >> !statusFile!
		ECHO Error during video conversion !outputVideoLength! ^< !videoLength!>> !statusFile!
      SET convertSuccess=FALSE
   )

   
	SET /A ripProgressPercent=!index! * 80 / !i!
	SET /A ripProgressPercent+=30
	ECHO !ripProgressPercent!> !ripProgressFile!
	SET /A index+=1
)

ECHO 100 > !ripProgressFile!

:final
REM Delete temporary files ============================================
IF !convertSuccess! == TRUE (
   SET ConversionResult=succeeded
   ECHO Conversion succeeded. Cleaning folders. >> !statusFile!
   FOR /F "delims=|" %%i IN ('dir /b !tempVidDir!*.mkv*') DO (
      ECHO Deleting %%i >> !logFile!
      CALL :waiting 1
      del "!tempVidDir!%%i"
   )

   REM Eject Disc if successful ===========================================
   IF "!EjectOnComplete!"=="TRUE" (
      ECHO Ejecting Disc !drive! >> !statusFile!
      CALL :waiting 1
      powershell.exe -Command "& {$obj = (new-object -comObject Shell.Application).NameSpace(17).ParseName('!drive!:');$obj.InvokeVerb('Eject')}"
   )
) ELSE (
   SET ConversionResult=failed
   ECHO Conversion failed! >> !statusFile!
   timeout /t 20
)


REM Send Notification ======================================
REM blat3219\blat.exe -to myemail@wherever.com -subject "!ConversionResult! for %showDir%" -body "Conversion %ConversionResult% for %vol%"
Echo  

ECHO 100 > !ripProgressFile!
ECHO 0.0%% > !progressFile!
timeout /t 5

GOTO :eof

REM Waits for MakeMKV to complete and reports progress ========================
REM waitingForMKV ##########################################################################
REM ########################################################################################
:waitingForMKV
CALL :waiting 4
SET progressNum=2500
SET "progressChar=|"
CALL :logChar [
SET whileLoopDone=0
SET "currentProgress=0"

REM Check to see if analyzation is complete
:waitingForMKVb

REM detect if MakeMKV dies
CALL :taskRunning makemkvcon.exe
IF !taskIsRunning! EQU FALSE (
	ECHO Make MKV terminated>> !logFile!
	GOTO :waitingForMKVbDone
)

FIND "Saving to MKV" "!tempFile!" >NUL
IF !ERRORLEVEL! EQU 0 (
	SET whileLoopDone=1
	SET "currentProgress=65536"
) ELSE (
	REM Read Progress
	FIND "PRGV:" "!tempFile!" >"!progressFile!"
	CALL :getLastLine !progressFile!
	SET detectError=!lastLine:ERROR=!
	IF NOT "!detectError!" == "!lastLine!" (
		ECHO: ERROR>>!statusFile!
		ECHO: !lastLine!>>!logFile!
	)
	IF !lastLine:~-5! EQU 65536 (
		SET "currentProgress=!lastLine:~-11,-6!#"
		SET "currentProgress=!currentProgress:,#=!"
		SET "currentProgress=!currentProgress:,=+!"
		SET "currentProgress=!currentProgress::=!"
		SET "currentProgress=!currentProgress:V=!"
		SET "currentProgress=!currentProgress:G=!"
		SET "currentProgress=!currentProgress:#=!"
	)
)
REM Draw progress bar
IF NOT "!currentProgress!" == "" (
	CALL :drawProgress !currentProgress! 2625 65600
)

REM Continue if analyzation is complete
IF !whileLoopDone! NEQ 1 (
	CALL :waiting 4
	GOTO :waitingForMKVb
)

:waitingForMKVbDone
SET progressNum=2500
SET "progressChar=#"
SET "currentProgress=0"
SET whileLoopDone=0
CALL :writeLog ]
CALL :logChar [

REM Check to see if MKV finished
:readMKVprogress
CALL :taskRunning makemkvcon.exe
IF !taskIsRunning! EQU FALSE (
	SET whileLoopDone=1
	SET "currentProgress=66000"
) ELSE (
	REM Get Progress
	FIND "PRGV:" "!tempFile!" >"!progressFile!"
	CALL :getLastLine !progressFile!
	SET "currentProgress=!lastLine:~-11,-6!#"
	SET "currentProgress=!currentProgress:,#=!"
	SET "currentProgress=!currentProgress:,=+!"
	SET "currentProgress=!currentProgress::=!"
	SET "currentProgress=!currentProgress:V=!"
	SET "currentProgress=!currentProgress:G=!"
	SET "currentProgress=!currentProgress:#=!"
	
)
REM Draw progress bar
IF "!currentProgress!" NEQ "" (
	CALL :drawProgress !currentProgress! 2625 65600
)

REM Exit if MakeMKV is done
IF !whileLoopDone! NEQ 1 (
	CALL :waiting 5
	GOTO :readMKVprogress
)
CALL :writeLog ]
EXIT /B

REM Waits for HandBrake to complaete and reports progress ========================
REM waitingForHB ###########################################################################
REM ########################################################################################
:waitingForHB
SET progressNum=4
SET "progressChar=|"
SET whileLoopDone=0
SET "currentProgress=0"
SET "HandBrakeWaitingCount=0"
CALL :logChar [
CALL :waiting 2

REM Check to see if analyzation is complete
:waitingForHBb

REM detect if HandBrake dies
CALL :taskRunning HandBrakeCLI.exe
IF !taskIsRunning! EQU FALSE (
	IF !HandBrakeWaitingCount! GEQ 20 (
		CALL :writeLog "HandBrake Done"
		GOTO :handBrakeExit
	) ELSE (
		CALL :logChar *
		CALL :waiting 2
		SET /A HandBrakeWaitingCount+=1
		GOTO :waitingForHBb
	)
)

REM read analyzation progress
FIND "task 2" "!progressFile!" >NUL
IF !ERRORLEVEL! EQU 0 (
	SET whileLoopDone=1
	SET "currentProgress=100"
) ELSE (
	REM detect if analization is skipped
	FIND "task 1 of 1" "!progressFile!" >NUL
	IF !ERRORLEVEL! EQU 0 (
		SET whileLoopDone=1
		SET "currentProgress=100"
	) ELSE (
		REM Read Progress
		CALL :getLastEntry !progressFile!
	
		SET "currentProgress=!lastLine:~23,3!"
		IF NOT "!currentProgress!" == "" (
			SET "currentProgress=!currentProgress:%=!"
			SET "currentProgress=!currentProgress:,=!"
			SET "currentProgress=!currentProgress:.9=!"
			SET "currentProgress=!currentProgress:.8=!"
			SET "currentProgress=!currentProgress:.7=!"
			SET "currentProgress=!currentProgress:.6=!"
			SET "currentProgress=!currentProgress:.5=!"
			SET "currentProgress=!currentProgress:.4=!"
			SET "currentProgress=!currentProgress:.3=!"
			SET "currentProgress=!currentProgress:.2=!"
			SET "currentProgress=!currentProgress:.1=!"
			SET "currentProgress=!currentProgress:.0=!"
			SET "currentProgress=!currentProgress:.=!"
			SET "currentProgress=!currentProgress:,=!"
			SET "currentProgress=!currentProgress: =!"
		)
	)
)
REM Draw progress bar
IF NOT "!currentProgress!" == "" (
	CALL :drawProgress !currentProgress! 4 100
)

REM Continue if analyzation is complete
IF !whileLoopDone! NEQ 1 (
	CALL :waiting 4
	GOTO :waitingForHBb
)

:waitingForHBbDone
CALL :writeLog ]
SET progressNum=0

:waitForHBProgress

REM reset variables
CALL :logChar [
SET "progressNum=0"
SET "progressChar=#"
SET "currentProgress=0"
SET "whileLoopDone=0"
SET "currentETA="

REM Check to see if HandBrake finished
:readHBprogress
CALL :taskRunning HandBrakeCLI.exe
IF NOT !taskIsRunning! EQU FALSE (
	IF "!currentETA!" == ""  (
            REM Get Progress
		CALL :getLastEntry !progressFile!
		IF NOT "!lastLine!" == "" (
			IF NOT "!lastLine:ETA=!" == "!lastLine!" (		
				REM print ETA from end of progress
				SET "currentETA=!lastLine:~-14!"
				ECHO !currentETA!>> !statusFile!
			)
		)
	)
      CALL :waiting 10
	GOTO :readHBprogress
)

CALL :writeLog ]

:handBrakeExit
EXIT /B

REM readHandBrake Progress #################################################################
REM ########################################################################################
SET "currentProgress=!lastLine:~23,3!"
		IF NOT "!currentProgress!" == "" (
			SET "currentProgress=!currentProgress:.9=!"
			SET "currentProgress=!currentProgress:.8=!"
			SET "currentProgress=!currentProgress:.7=!"
			SET "currentProgress=!currentProgress:.6=!"
			SET "currentProgress=!currentProgress:.5=!"
			SET "currentProgress=!currentProgress:.4=!"
			SET "currentProgress=!currentProgress:.3=!"
			SET "currentProgress=!currentProgress:.2=!"
			SET "currentProgress=!currentProgress:.1=!"
			SET "currentProgress=!currentProgress:.0=!"
			SET "currentProgress=!currentProgress:.=!"
			SET "currentProgress=!currentProgress:,=!"
			SET "currentProgress=!currentProgress: =!"
		)

REM Draw progress bar
IF NOT "!currentProgress!" == "" (
	CALL :drawProgress !currentProgress! 4 100
)

EXIT /B


REM readEpisodeDetails #####################################################################
REM ########################################################################################
:readEpisodeDetails
SET "episodeVideoSize="
FIND "SINFO:%1,0,19,0" !discInfoFile! > "!tempFile!"
IF !ERRORLEVEL! EQU 0 (
	CALL :getLastLine "!tempFile!"
	SET episodeVideoSize=!lastLine:~15!
	SET episodeVideoSize=!episodeVideoSize:,=!
	CALL :writeLog "episode video size is !episodeVideoSize!"
)

SET "episodeAspect="
FIND "SINFO:%1,0,20,0" !discInfoFile! > "!tempFile!"
IF !ERRORLEVEL! EQU 0 (
	CALL :getLastLine "!tempFile!"
	SET episodeAspect=!lastLine:~15!
	SET episodeAspect=!episodeAspect:,=!
	CALL :writeLog "episode aspect ratio is !episodeAspect!"
)

SET "episodeFrameRate="
FIND "SINFO:%1,0,21,0" !discInfoFile! > "!tempFile!"
IF !ERRORLEVEL! EQU 0 (
	CALL :getLastLine "!tempFile!"
	SET episodeFrameRate=!lastLine:~15!
	SET episodeFrameRate=!episodeFrameRate:,=!
	CALL :writeLog "episode frame rate is !episodeFrameRate!"
)

CALL :countLang %1
SET episodeLangCount=!audioLangCount!
CALL :writeLog "episode has !episodeLangCount! audio languages"
SET episodeSubLangCount=!subtitleLangCount!
CALL :writeLog "episode has !episodeSubLangCount! subtitle languages"

CALL :writeLog "Detected !EpisodeLength! minute episodes"
EXIT /B

REM detectLowDriveSpace ####################################################################
REM ########################################################################################
:detectLowDriveSpace
SET convertDriveSpace=0000000000000000
wmic LogicalDisk Get DeviceID^,FreeSpace|FINDSTR /I "!convertDrive!"> "!tempFile!"
FOR /F "tokens=1,2 delims= " %%a IN (!tempFile!) DO (
   SET convertDriveSpace=%%b
)

IF "!convertDriveSpace!" EQU "0000000000000000" (
	CALL :writeLine ##############################
	CALL :writeLine "   DRIVE IS MISSING"
	CALL :writeLine ##############################
	ECHO    DRIVE IS MISSING>>!logFile!
	GOTO :eof
)

SET "convertDriveSpace=!convertDriveSpace: =!"
ECHO: !convertDriveSpace! Free>>!logFile!

ECHO: !convertDriveSpace:~0,-6! MB Free Drive Space>>!statusFile!
ECHO: !convertDriveSpace:~0,-6! MB Free Drive Space>>!logFile!
IF !convertDriveSpace! LSS 12000000000 (
   CALL :writeLine ##############################
   CALL :writeLine "   Drive Space Is Low"
)
IF !convertDriveSpace! LSS 4000000000 (
   CALL :writeLine ##############################
   CALL :writeLine "   DRIVE IS FULL"
	CALL :writeLine ##############################
	GOTO :eof
)
EXIT /B

REM countLang ##############################################################################
REM ########################################################################################
REM Count Audio Languages in a title
:countLang
SET langCount=0
SET audioLangCount=0
SET subtitleLangCount=0
SET "langs="
SET countLangSkip=1
 REM Determine number of columns to skip

REM Find audio stream numbers
SET "outLine=FINDSTR ,\"Audio\" !discInfoFile!"
ECHO:    Processing audio streams >> !logFile!
ECHO UNK > langs.txt
ECHO UNK > audioLangs.txt
ECHO UNK > subtitleLangs.txt

REM In each audio stream, get the language code
FOR /L %%Q IN (1,1,50) DO (	
	
	REM Get the language code lines	
	FIND "SINFO:%1,%%Q,14,0," !discInfoFile! >nul
	IF !ERRORLEVEL! EQU 0 (
	    SET "langFile=audio"
	) ELSE (
		SET "langFile=subtitle"
	)
	SET "outLine2=FINDSTR "SINFO:%1,%%Q,3,0," !discInfoFile!"
	FOR /F %%R in ('!outLine2!') DO (
		REM parse the language code from the line
		SET "lang=%%R"
		SET "lang=!lang:~-4,-1!
		
		REM Determine if the code ws already processed by logging to a file
		FIND "!lang!" langs.txt >nul
        IF !ERRORLEVEL! NEQ 0 (
		    SET /A langCount+=1
			ECHO: !lang!>> langs.txt
		)
		FIND "!lang!" !langFile!Langs.txt >nul
        IF !ERRORLEVEL! NEQ 0 (
			ECHO:    Found !langFile! language !lang! >> !logFile!
			ECHO: !lang!>> !langFile!Langs.txt
			
			IF !langFile! == audio (
			    SET /A audioLangCount+=1
			) ELSE (
				SET /A subtitleLangCount+=1
			)
		)
	)
)
ECHO: Found !langCount! languages>> !logFile!
ECHO: Found !audioLangCount! audio languages>> !logFile!
ECHO: Found !subtitleLangCount! subtitle languages>> !logFile!
del langs.txt
del audioLangs.txt
del subtitleLangs.txt
EXIT /B

REM set the episodeNum variables
REM setEpisodeNum ##########################################################################
REM ########################################################################################
:setEpisodeNum
IF %1 LSS 10 (
   SET episodeNum=0%1
) ELSE (
   SET episodeNum=%1
)
EXIT /B

REM write a line to the status file and log file
REM writeAndLog ############################################################################
REM ########################################################################################
:writeLog
ECHO: %~1 %~2 %~3 %~4 %~5 %~6>> !logFile!
EXIT /B

REM write a line to the status file
REM writeLine ##############################################################################
REM ########################################################################################
:writeLine
ECHO: %~1 %~2 %~3 %~4 %~5 %~6>> !statusFile!
EXIT /B

REM write a line to the status file and log file
REM writeAndLog ##############################################################################
REM ########################################################################################
:writeAndLog
ECHO: %~1 %~2 %~3 %~4 %~5 %~6>> !statusFile!
ECHO: %~1 %~2 %~3 %~4 %~5 %~6>> !logFile!
EXIT /B

REM write a character to the log file
REM logChar ##############################################################################
REM ########################################################################################
:logChar
ECHO|SET /p dummyName="%1">> !logFile!
EXIT /B


REM write a character to the status file
REM writeChar ##############################################################################
REM ########################################################################################
:writeChar
ECHO|SET /p dummyName="%1">> !statusFile!
EXIT /B

REM Draw a progress bar
REM 1 = current progress, 2 = step size, 3 = max progress
REM drawProgress ###########################################################################
REM ########################################################################################
:drawProgress
:drawProgressLoop
IF !progressNum! LEQ %3 (
	IF %1 GTR !progressNum! (
		ECHO|SET /p dummyName="!progressChar!">> !logFile!
		SET /A "progressNum+=%2"
		GOTO :drawProgressLoop
	)
)
EXIT /B

REM detects if a process is running by its filename
REM 1 = process filename
REM taskRunning ############################################################################
REM ########################################################################################
:taskRunning
tasklist /FI "IMAGENAME eq %1" 2>NUL | FIND /I /N "%1">NUL
IF ERRORLEVEL 1      (
	SET taskIsRunning=FALSE
) ELSE (
	SET taskIsRunning=TRUE
)
EXIT /B

REM Waits for the number of seconds passed
REM waiting ################################################################################
REM ########################################################################################
:waiting
SET waitTime=%1
SET /A waitTime+=1
PING -n !waitTime! 127.0.0.1>nul
EXIT /B

REM ########################################################################################
:getLastEntry
IF EXIST "!tempFile2!" (
	del "!tempFile2!"
)

SET "lastLine="
IF EXIST %1 (
	powershell -C "((Get-Content %1 -Raw) -replace '[)]',\"`r`n\") | Set-Content !tempFile2!"

	IF EXIST "!tempFile2!" (
		FOR /f "UseBackQ delims=" %%r IN (!tempFile2!) DO (
			SET "lastLine=%%r"
		)
		del "!tempFile2!"
	)
)
EXIT /B

REM Replaces a right paren with a new line
REM 1 = The file to process, 2 = output file
REM addLineFeed ############################################################################
REM ########################################################################################
:addLineFeed
powershell -C "((Get-Content %1 -Raw) -replace '[)]',\"`r`n\") | Set-Content %2"
EXIT /B

REM Gets the last line from a file
REM getLastLine ############################################################################
REM ########################################################################################
:getLastLine
SET "lastLine="
FOR /f "UseBackQ delims=" %%r IN (%~1) DO (
   SET "lastLine=%%r"
)
EXIT /B

REM Reads total minutes from a time
REM #########################################################################################
:getTotalTimeMinutes
SET readMinutes=%1
SET readHours=0
SET readHours=!readMinutes:~-7,-6!
SET readMinutes=!readMinutes:~-5,-3!
IF !readMinutes!:~0,1! EQU 0 (
	SET readMinutes=!readMinutes:~1,1!
)
IF !readHours! GTR 0 (
	IF !readHours! LSS 10 (
		SET /A  readMinutes=!readHours! * 60 + !readMinutes!
	)
)
EXIT /B

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
IF "!isBonusDisc!" == "" (
	IF "%bonusDetect%" NEQ "%parseText%" (
	SET isBonusDisc=TRUE
	) ELSE (
		SET isBonusDisc=FALSE
	)
)

REM remove problematic characters
setlocal DisableDelayedExpansion
SET "parseText=%parseText:!=%"
endlocal
SET "parseText=%parseText::=%"
SET "parseText=%parseText:?=%"

REM Remove unecessary words
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

REM Remove disc from name
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

REM Remove Disc from name
SET parseText=%parseText:D1##=##%
SET parseText=%parseText:D2##=##%
SET parseText=%parseText:D3##=##%
SET parseText=%parseText:D4##=##%
SET parseText=%parseText:D5##=##%
SET parseText=%parseText:D6##=##%
SET parseText=%parseText:D7##=##%
SET parseText=%parseText:D8##=##%
SET parseText=%parseText:D9##=##%

REM Standardize season nomenclature
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

REM Remove volume from name
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

REM Remove season from name
SET parseText=%parseText:_S1##=##%
SET parseText=%parseText:_S2##=##%
SET parseText=%parseText:_S3##=##%
SET parseText=%parseText:_S4##=##%
SET parseText=%parseText:_S5##=##%
SET parseText=%parseText:_S6##=##%
SET parseText=%parseText:_S7##=##%
SET parseText=%parseText:_S8##=##%
SET parseText=%parseText:_S9##=##%

REM Trim end
SET parseText=%parseText:_##=##%
SET parseText=%parseText: ##=##%
SET parseText=%parseText: ##=##%
SET parseText=%parseText: ##=##%
SET parseText=%parseText:##=%
EXIT /B