Braving the Batch Script
==================================================

Rip.bat is the file that does most of the work in VideoRip. Batch
files are not for the timid person. You can make a simple edit
in 1 second and yet the next simple edit sends you down a
nightmare of difficulties. Just keep trying. You can always
go back to the original copy of the script if you mess things up.

The VideoRip executable acts as a front end for rip.bat. Information
is passed to the script by using environment variables. VideoRip
provides some extra fields in the settings to send your own variables
to the script.

Scripts can be editted witrh any text software, but you may want to use
something like Notepad++ which can assist you with syntax.

Getting Setup
==================================================

Environment variables passed to rip.bat
---------------------------------

workingDir - This is where VideoRip executes from
statusFile - The contents of this file are displayed in the status area
logFile - The contents of this file are displayed in the log area
seasonNum - The Season Number of the TV Show beiung copied.
tempConvertDir - This is the location that videos are placed when they are converted.
TvFolder - Where TV Shows are saved
FilmFolder - Folder where movies are saved.
lang - User's selected language. Defaults to eng.
keepAngles - Copies multiple video angles from a disc.
isBonusDisc - Set to TRUE if the disc is Special Features only.

Finding the Optical Drive
---------------------------------

WMIC is used to find the optical drives. The VIDEO_TS folder is used
to detect DVDs and the BDMV folder is used to detect Blu-rays. The drive
number is recorded in the discNum variable to be passed to MakeMKV.

Getting Disc Info
=================================================

Retrieving media info from Microsoft is disabled. Microsoft shut down the
service. MakeMKV can now retieve some information from the internet. The 
volume name of the drive is recorded. MakeMKV will return this information
anyway. The CLI interface is called with the "-r info" options to
retrieve disc information.

Next the name is formatted by removing any character that can be considered a command line
operator. Characters removed include: | " : \ /
Spaces and double underscores are turned into a single underscore.

Parsing the name
----------------------------------

The name is parsed for information. The word BONUS is detected
to indicate a bonus or special feature disc.

Exclamation marks and question marks are removed. These are death
for batch scripts. They are interpreted incorrectly very often so
the filename cannot contain them.

Any form of these extraneous words are removed: Disc, Blu-ray, DVD, 4x3, 16x9,
Fullscreen, widescreen, The Complete Series, Series, Season, SSN, VOLUME, VOL

in theory the disc number could be used to help get titles in the correct
order but I have not found any reliable way to use it so the info is 
discarded. English words for numbers are translated into digits. Any season
number detected is encoded as the letter S followed by the number.

After the title is parsed, it will be replaced by the user title, if one was provided.
The year and any special info are added to the filename surrounded by
paenthesis.

Getting Title Info
===================================================================

If the detected name and the video name are the same, then the title
is assumed to be a film, not a TV show. Essentially this is looking to see 
if a season number is present in the filename.

For films, the folders are setup, and that's all there is to do.

For TV, the name is parsed for numeric words (first, second, third)
and translated into a number. Then the season number is read. In
some cases (A complete series) thre is no number so it defaults to
season 1. In some cases the season will be encoded as 99. This is often for
bonus features that have nno seasopn affiliation.

Getting Output Folder Info
===================================================================

At this point the free drive space is read. An error is displayed
if the drive is missing. If the drive has less than 4 GB of free
space a failure occurs. This is probably even less than is needed
to convert even short DVDs. A warning is displayed if less than 12 GB
are free.

Next videos in the output folde are counted. This helps the script
keep track of shows and special features already converted. It also
helps to continue a conversion if it was interrrupted. MKV files
are assumed to be titles unless the word Extra is present in the filename.
Double episodes are also detected in order to get the episode number right.
Almost all studios give double episodes 2 episode numbers and thsi is how
most databases store the information.

Aborted conversions aredeteected by looking for files in the Temporary Rip
Directory. If files are found, and the renameFile is detected, ripping continues.
The renameFile is deleted after ripping. If the renameFile is
not present, no ripping occurs and the files are converted.

Getting Video Details
====================================================================

To Be Continued - This is where the magic happens
