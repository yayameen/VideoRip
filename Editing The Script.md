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

- workingDir → This is where VideoRip executes from
- statusFile → The contents of this file are displayed in the status area
- logFile → The contents of this file are displayed in the log area
- seasonNum → The Season Number of the TV Show beiung copied.
- tempConvertDir → This is the location that videos are placed when they are converted.
- TvFolder → Where TV Shows are saved
- FilmFolder → Folder where movies are saved.
- lang → User's selected language. Defaults to eng.
- keepAngles → Copies multiple video angles from a disc.
- isBonusDisc → Set to TRUE if the disc is Special Features only.
- titleYear → Year of release
- userTitle → Title supplied by the user

Local variables
--------------------------------

- drvVol → Disc volume label
- vol → Volume name 
- discNum → Disc drive number
- drive → Disc drive letter
- newVol → Formatted volume name
- newdrvVol → Formatted volume label
- showDir → Name of the TV show folder
- tempFile → File where temporary text is stored
- mediaType → FILM or TV
- convertPath → Final output location
- seasonNum → season number
- episodeCount → number of episodes converted
- bonusCount → number of extra features converted

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
operator. Characters removed include:

| " : \ /

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

Video details are parsed from the title info extracted by MakeMKV. The codes used from the output are given in each section.

Avoiding Duplicate Videos
------------------------------
TINFO:xx,26,0
Blue-ray discs have unique segment numbers, so the segments that
have been found are recorded in the titleSegmentList variables.
DVD segments are not unique. The string "2ts" is used to detect
transport streams. If a transport stream is made up of a segment
that has already been found, it is not ripped, since it is a piece
of a previously ripped video. "mpls" is a playlist of multiple
segments and is usually more desirable than the transport stream.

Ordering Episodes
------------------------------
TINFO:xx,27,0
Blu-ray discs have title names. These names are used for getting TV
episodes in the correct order. For DVDs the output filename must be
used. This is less reliable.

Skip short videos
-----------------------------
TINFO:xx,9,0
If he title length is less than 28 seconds, it is ignored. MakeMKV
has a miminmum title length setting which will filter out videos
before VideoRip even sees them, so set MakeMKV preferences 
appropriately.

Determine TV episode length
-----------------------------
TINFO:xx,9,0
If the episode length isn't set, VideoRip assumes the first video
it finds is an episode, and uses it to determine episode lengths.
This is just a guess, so it is better to set the length yourself.

Read Episode Details
----------------------------

TV episode characteristics are recorded in order to identify other
episodes on the disc. 99% of the time, episodes will match in every
regard.

SINFO:xx,0,19,0      The video dimension size
SINFO:%1,0,20,0      The video aspect ratio
SINFO:%1,0,21,0      The video frame rate

SINFO:xx,aa,3,0,     Audio stream languages are summed

Set valid episode length range
----------------------------

Once the episode length is known, a range is created to filter out
videos which are not episodes. The first episode found is used to
set the range. On broadcast TV "30 minute" episode is usually 22
minutes long. VideoRip sets the max episodes length to 46 minutes,
which is the longest a double episode would be. On streaming shows
a "30 minute" episode might be 36 minutes. In this case VideoRip
sets the max length to 70 minutes. There are a variety of ranges.
No range will ever work perfectly.

Filtering Videos
======================================================

If a title is ignored the badTitle variable will be set to the
title number.

For TV, if a video doesn't meet the length criteria or match the video
details, it is considered to be a bonus feature. If it is longer than
the max episode length, it is ignored. This means that some bonus
features will be detected as an episode. Long bonus features may
not be ripped at all.

Films
---------------------------------

For films, unless movie collection was selected (multiTitle == TRUE)
only 1 video longer  than 1.5 hours will be ripped. Sometimes VideoRip
has trouble detecting the main title. Supplying the correct runtime
length will help it select the correct video. This is especially
true for Lionsgate discs. There are also discs like Toy Story where
videos are supplied in different languages. Setting the preferred
language helps choose the right video.

If VideoRip doesn't find a main title video, it will drop all
requirements except for the length, and take the title that is the most
preferred match.

Chapters
---------------------------------

For films, videos with more than 10 chapters are given preference, since
the main title usually has that many chapters.

Video Aspect
---------------------------------
SINFO:xx,0,20
If VideoRip finds multiple possible main titles, it will prefer wide
screen ratios over full screen.

Number of Audio Streams
---------------------------------

VideoRip will prefer the film title with the most audio streams. Bonus
features usually have fewer streams.

Video Length
---------------------------------

The longest video is preferred. This will also cause VideoRip to prefer
extended cuts or directors cuts over the original feature release.

Audio Languages
---------------------------------

VideoRip will prefer titles in the user's languages. Also, there is a
weird quirk. If a title has a Japanese track, but no French track, it
is ignored. This will break the logic if japanese was your desired
language. This rule comes from the Friends Blu-rays. Once a certain
number of audio streams is reached, separate titles are created for
the additional audio streams. This reduces the overall bitrate, which
would otherwise be very high because it contains many languages.
Usually it is the asian languages that are divided out, but English
audio tracks are duplicated in the asian title as well.

Filenames
--------------------------------

A duplicate filename usually means that the title is a second video
angle of the previous title. There is actually a more certain
way to detect multiple angles, but so far this method is easier
and I have not seen it fail yet. Set keepAngles to TRUE to retain
all video angles.

Bonus features have a letter z prepended to their names so when the
titles are sotyed alphabetically, the bonus features can be identified
and converted last.

Ripping
=======================================================

MakeMKV rips the title to the hard drive's tempConvert folder.
Progress is logged to a file which the UI uses to update the progress
bar. Ripping is given Below Normal priority so the computer is still
responsive.

After all titles are ripped,they are renamed appropriately. Names follow
plex standards. Double length TV episodes are given 2 episode numers.
Muti-part titles are given part numbers.

Converting
======================================================

MediaInfo is used to record the titles length. In case converting was
interrupted, VideoRip checks for an output file of the correct length
to see if conversion has already succeeded. 11 seconds of difference
are allowed between the video lengths. Extra information at the end of
the video can cause the converted video to be shorter than the source.

If the video hasn;t been converted already, then HandBrake is called.
The video profile is passed to HandBrake based upon the user's choice.
Use HandBrake to export desired settings for each profile. As each
title is converted, it is copied to the final outpur location.

Finishing
======================================================

After everything is done, the disc is ejected. There are commented out
lines that show how you can use the Blat app to send notifications
to email. Remember that many cell phone companies assign an email
address to send text messages to your phone number.
