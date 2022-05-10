Common Problems
=====================================

Below are some common issues that you may run into when
using VideoRip. Many of them can be fixed if you want to
edit the batch script yourself.

1. VideoRip reports that a video failed even though it converted successfully.
---------------------------------------

This often happens for 2 reasons. a) Either the video is very short and converts
so fast that VideoRip doesn't know the conversion started. b) The video
and the audio are different lengths. This can sometimes happen in audio commentary
the dialog is longer than the movie. There are other scenarios as well, but
they are rare.

2. VideoRip can't find my Disc Drive
---------------------------------------

VideoRip uses the first optical drive that it finds. You can fix this issue by
changing the drive letter for the drive you want to use so that it comes first.

3. VideoRip can't read my DVD/Blu-ray
---------------------------------------

VideoRip relies on MakeMKV to read the disc. MakeMKV is amazing software, and
it does about as well as can be done without paying license royalties.

4. VideoRip skipped some videos on my DVD
---------------------------------------

Check the settings in MakeMKV. There is a minimum video limit. VideoRip will
copy any video longer than 29 seconds. Soometimes DVDs and Blu-rays contain
still frames or other short videos. You can lower the threshold on this time limit

Also VideoRip will ignore any videos that have no audio. It assumes they are
Copyright warnings or other irrelevant content.

VideoRip also ignores videos that are not in your desired language. There is some
extra logic that will still copy videos that aren't in your selected language in some
scenarios. For example: when there is no videos in your language on the disc. This
logic needs to be made more robust. I was mainly focused on English.

5. VideoRip can't find the movie/show on the disc
----------------------------------------

VideoRip does the best it can. It tries to eliminate videos that it thinks are not
the main title. There is no way to be certain about which titles are the main content.
VideoRip expects movies to be at least 1 hour 25 minutes long (85 minutes). TV shows
are expected to be at least 19 minutes long, but not longer than an hour 10 minutes
(70 minutes). You can change this behavior by selecting the episode length from
the dropdown. Once an episode length is detected, VideoRip expects other episodes to be 
of similar length.

6. VideoRip skipped a double length TV episode or copied episodes twice
------------------------------------------

VideoRip will allow episodes to be up to double the expected length. After that it
assumes the video is a sequence of episodes and ignores it. Sometimes a DVD may
only have 2 episodes on it. VideoRip may think it is 1 double length episode and
2 normal length episodes, when it is really just 2 episodes plus a "play all"
sequence.

This usually won't happen on Blu-rays because Blu-rays have unique segment numbers that
VideoRip can detect.

7. TV episodes are converted out of order
-------------------------------------------

There is no easy way to determine episode order from a disc. Usually VideoRip
will sort the episodes in alphabetic order (not the numerical title order or disc order)
and hope the order is correct. This is the case more often than not, but that still
leaves a lot of circumstances when the order is wrong. Also note that sometimes the 
episodes are not released on disc in the same order as they aired, or the order listed 
on sites like TVDb and IMDb.

8. VideoRip copies commercials I don't want to see/ skipped commercials I want
--------------------------------------------

Normally commercials have no language identifier. VideoRip detects this and skips
those videos. This isn't a definitive rule. Sometimes this can cause special
features to be skipped as well (rarely). Yoyu can remove this rule from the batch
file, if you want to keepo all the videos.
