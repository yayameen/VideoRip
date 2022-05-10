Getting Started With VideoRip
=============================

VideoRip only runs on Windows OS. It should run fine on any version of Windows
from XP to Windows11. Note that the tools used by VideoRip don't support older OS
but you can find archived versions of those tools that will still run.
VideoRip relies on free software to accomplish its capability. The following
software should be installed on your system.

1. HandBrake - ( https://handbrake.fr/downloads.php ) 
   HandBrake is a tool for converting video formats. Videos from DVDs and
   Blu-rays cannot be played directly due to their format and they have
   large file sizes.
   There are no special installation instructions, but see instructions.
2. HandBrakeCLI - ( https://handbrake.fr/downloads2.php )
   This is the command line tool for HandBrake. It installs into the same
   folder as HandBrake.
3. MakeMKV - ( https://www.makemkv.com/download/ )
   MakeMKV is a free toolfor copying videos from DVDs and Blu-rays. This tool
   is needed instead of using libdvdread or some other solution because it is
   the only tool that can unlock DVDs. Also, it can handle stubborn discs that
   are formatted incorrectly.
4. MediInfo - ( https://mediaarea.net/en/MediaInfo ) This tool is only needed
   to read the length of videos. You can edit the scripts if you don't want to
   use it. Place it inside the Mediainfo folder in the scripts file.
   

A note about MakeMKV. It is free, but you may need a license to use the command
line interface. The license is cheap and well worth the cost for the amount of
benefit.

Building The Software
===============================

The project should build with almost any recent version of Visual Studio. You can change
the target .NET Framework from 4.8 to any 4.x version. Once you have built the VideoRip.exe,
place it in a folder with the script files.

Getting Encoding Setup
===============================

VideoRip comes with some Handbrake settings (JSON) that are reasonable for most scenarios.
You can import these into HandBrake, modify them as you please, and resave them. Everyone
has their preference for quality vs. file size. You should also ensure that the settings
will work for your media player, although the basic settings should work in most circumstances.

Launch The App
===============================

Ensure that your script folder exists in a location where you have write and execute permissions.
Most folders in Windows should work. The Public user folder is a good choice. Launch VideoRip. The first
thing to do is click the settings tab. Chose a folder to rip to and to convert to. These folders
should not be the same. Next, set the Video Output folder. VideoRip creates a folder structure 
compatible with Plex. You can modify the script to alter this structure, if you like. Finally,
type a 3 letter language code ( https://www.iso.org/standard/4767.html ) or 
( https://en.wikipedia.org/wiki/List_of_ISO_639-1_codes ). eng is English. This code is used to choose
subtitles and audio from the disc.

Setup Your Conversion
===============================

Without doing anything, VideoRip will attempt to detect the disc you are converting, but manufacturers
do not make it easy, and some information is impossible to detect. 

Encoding - You can leave the Encoding setting as default unless you want better control over high def
content. There is also a cartoon setting for old 2D cartoons.

Media Type - Set to TV for anything that has multiple episodes. If a disc has more than one movie,
or has 2 different edits of a movie (and you want both) then select Film Collection. If a video has
multiple angles, VideoRip tries to copy just the first. The reason is because the only other way to do
it is to make separate copies of the movie for each angle.

Bonus Disc - Check this setting if the disc is only special features, or if the disc has multiple
short videos that aren't normal movies.

Repair/Restore - This settings fixes problems with videos at the cost of extra processing time. Repair
is the lightest. It will fix issues with interlacing and telecine stutter. Restore is for very
poor videos. It will try to remove MPEG artifacts, and sharpen the image. Don't use restore unless
the video is very damaged.

Length - This is the length of the movie. There is no need to set this setting unless there are
multiple videos on the disc that are movie length. This happens sometimes when a film has scenes
tailored for different regions (Toy Story), but this usually isn't an issue. The most common
use case for typing the movie length is Lionsgate discs. They usually cause a problem otherwise.

Title - Check the box to type in the title. If you don't VideoRip tries to detect the title, but
many times this ends up being the volume label on the disc. VideoRip will clean it up if
possible.

Release Year - Not strictly necessary, but it helps with movies and shows that have titles which
aren't unique.

Special Info - Any extra text you want asdded to the files names.

Go!!!
=====================================

Click Start and away you go. If a previous rip failed, you may want to hit the Clean
button to get back in a good state. There are still a lot of limitations to the software but
it is amazing what it can manage to figure out. See the details on the rip batch script
for more information about what can go wrong.

All titles are ripped before conversion begins, so ensure that you have enough hard drive space.
The reason is because otherwise it is almost impossible to figure out what state it was in
if the conversion is interrupted. If the computer restarts or some other problem occurs,
you can just restart VideoRip and it will pick up where it left off.
