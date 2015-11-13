Batch Script:		AVS_Test.bat
Version:			1.0
Copyright:			© Lostech 2015
Homepage:			www.lostech.de.vu
					www.github.com/lostech
License:			GPLv2
					https://www.gnu.org/licenses/gpl-2.0.html
Description:		Helper batch file for display AviSynth error outputs in case of AVS script errors etc.


When scripting with AviSynth often a script fails to playback but not every media player does show the
returned AviSynth error output.
This Batch script is a workaround for this issue.
At start it creates a temporary wrapper for the specified AVS script which catches the error output
and creates a new clip for the media player to play now showing the error description output.


Usage:

	AVS_Test.bat Script.avs

Or drag and drop your script file on the AVS_Test.bat batch file.


Remarks:

1.) The *.avs file extension must be associated with a proper media player which does support AviSynth playback.
	Without being associated Windows may show up with an app selection dialogue where you must select on your own
	an AviSynth capable media player. 
2.) Not all errors can be catched this way. Depending on the media player and/or script mistakes it can happen that
	the mediaplayer does crash before showing the catched AviSynth error description output. In some cases it may
	help trying another mediaplayer.
3.) AviSynth is somewhat picky with special chars for e.g. german "Umlaute" like ä,ö,ü etc. Try to avoid such special
	chars in your filenames and filepaths. Sometimes also a Space char " " within filename/-path may also lead to problems.
	Try to avoid the Space or use another ASCII char for e.g. "_".
