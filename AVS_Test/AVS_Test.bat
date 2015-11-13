rem Batch Script:		AVS_Test.bat
rem Version:			1.0
rem Copyright:			© Lostech 2015
rem Homepage:			www.lostech.de.vu
rem 					www.github.com/lostech
rem License:			GPLv2
rem 					https://www.gnu.org/licenses/gpl-2.0.html
rem Description:		Helper batch file for display AviSynth error outputs in case of AVS script errors etc.
rem 
@echo off
cls
IF [%1]==[] goto error1
echo.
echo Trying to start AviSynth script:
echo %1
if exist "./Temp.avs" del "./Temp.avs"
echo #Temporary wrapper AviSynth script > ./Temp.avs
echo StartScript = %1 > ./Temp.avs
echo try { >> ./Temp.avs
echo   import(StartScript) >> ./Temp.avs
echo } catch (ErrorMsg) { >> ./Temp.avs
echo   return BlankClip().Subtitle(ErrorMsg, align=4, lsp=0, size=12) >> ./Temp.avs
echo } >> ./Temp.avs
start /wait ./Temp.avs
if exist "./Temp.avs" del "./Temp.avs"
exit

:error1
echo.
echo AviSynth test can not be started. No Avisynth script argument given.
echo.
echo Usage:
echo %~nx0 Script.avs
echo.
echo Or drag and drop your script file on the %~nx0 batch file.
echo.
echo Remarks:
echo.
echo 1.) The *.avs file extension must be associated with a proper media player
echo     which does support AviSynth playback. Without being associated Windows may
echo     show up with an app selection dialogue where you must select on your own
echo     an AviSynth capable media player. 
echo 2.) Not all errors can be catched this way. Depending on the media player
echo     and/or script mistakes it can happen that the mediaplayer does crash
echo     before showing the catched AviSynth error description output. In
echo     some cases it may help trying another mediaplayer.
echo 3.) AviSynth is somewhat picky with special chars for e.g. german "Umlaute"
echo     like ae,oe,ue etc. Try to avoid such special chars in your filenames
echo     and filepaths. Sometimes also a Space char " " within filename/-path
echo     may also lead to problems. Try to avoid the Space or use another
echo     ASCII char for e.g. "_".
echo.
pause
