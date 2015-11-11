#Import TextOverlay script
Import("TextOverlay.avsi")

/*---------------------------------------*/
#Values for example clip duration
/*---------------------------------------*/
#define FPS
ClipFPS=25
#define number of frames
ClipLength=125

#define start & end frame for text overlay
StartFrame=25
EndFrame=ClipLength-StartFrame
/*---------------------------------------*/

#create example base clip
Clip1=BlankClip(color=$FFFFFF, fps=ClipFPS, length=ClipLength)
Clip1=Subtitle(Clip1, "BASECLIP", font="Arial", size=24, text_color=$FFFFFF, halo_color=$000000, align=5)

#create TextFadeInOut example
TextFadeInOutClip=TextFadeInOut(Clip1, 100, 100, StartFrame, EndFrame, "TextFadeInOut", "Arial", 50,  color_crimson, $000000)

#create TextMoveInOut example
TextMoveInOutClip=TextMoveInOut(Clip1, -280, -200, 100, 100, StartFrame, EndFrame, "TextMoveInOut\n1. Example", "Arial", 50,  color_lightsteelblue, $000000)

#create TextMoveInOut example 2
TextMoveInOutClip=TextMoveInOutClip ++ TextMoveInOut(Clip1, -280, 300, 300, 300, StartFrame, EndFrame, "TextMoveInOut\n2. Example", "Arial", 50,  color_lightsteelblue, $000000)

#create TextMoveInOut example 3
TextMoveInOutClip=TextMoveInOutClip ++ TextMoveInOut(Clip1, 640, 300, 100, 300, StartFrame, EndFrame, "TextMoveInOut\n3. Example", "Arial", 50,  color_lightsteelblue, $000000)

#create TextMoveInOut example 4
TextMoveInOutClip=TextMoveInOutClip ++ TextMoveInOut(Clip1, 640, 480, 240, 280, StartFrame, EndFrame, "TextMoveInOut\n4. Example", "Arial", 50,  color_lightsteelblue, $000000)

#create TextFadeMoveInOut example
TextFadeMoveInOut=TextFadeMoveInOut(Clip1, -280, -200, 100, 100, StartFrame, EndFrame, "TextFadeMoveInOut\n1. Example", "Arial", 50,  color_forestgreen, $000000)

#create TextFadeMoveInOut example 2
TextFadeMoveInOut=TextFadeMoveInOut ++ TextFadeMoveInOut(Clip1, -280, 300, 200, 300, StartFrame, EndFrame, "TextFadeMoveInOut\n2. Example", "Arial", 50,  color_forestgreen, $000000)

#create TextFadeMoveInOut example 3
TextFadeMoveInOut=TextFadeMoveInOut ++ TextFadeMoveInOut(Clip1, 640, 300, 100, 300, StartFrame, EndFrame, "TextFadeMoveInOut\n3. Example", "Arial", 50,  color_forestgreen, $000000)

#create TextFadeMoveInOut example 4
TextFadeMoveInOut=TextFadeMoveInOut ++ TextFadeMoveInOut(Clip1, 640, 480, 200, 280, StartFrame, EndFrame, "TextFadeMoveInOut\n4. Example", "Arial", 50,  color_forestgreen, $000000)

#combine test clips for output
Output=TextFadeInOutClip ++ TextMoveInOutClip ++ TextFadeMoveInOut

#output
return Output