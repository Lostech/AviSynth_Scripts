#Import PictureInPicture script
Import("PictureInPicture.avsi")

/*---------------------------------------*/
#Values for example clip duration
/*---------------------------------------*/
#define FPS
ClipFPS=25
#define number of frames
ClipLength=50
/*---------------------------------------*/

/*---------------------------------------*/
#Value for PiP window size
/*---------------------------------------*/
Scalefactor=0.4
/*---------------------------------------*/

#create example clip 1 (Master, black)
Clip1=BlankClip(color=$000000, fps=ClipFPS, length=ClipLength)
Clip1=Subtitle(Clip1, "CLIP 1", font="arial", size=24, text_color=$FFFFFF, align=5)

#create example clip 2	(Slave, red)
Clip2=BlankClip(color=$FF0000, fps=ClipFPS, length=ClipLength)
Clip2=Subtitle(Clip2, "CLIP 2", font="arial", size=24, text_color=$FFFFFF, align=5)

#create example clip 3	(Slave, green)
Clip3=BlankClip(color=$00FF00, fps=ClipFPS, length=ClipLength)
Clip3=Subtitle(Clip3, "CLIP 3", font="arial", size=24, text_color=$FFFFFF, align=5)

#create example clip 4	(Slave, blue)
Clip4=BlankClip(color=$0000FF, fps=ClipFPS, length=ClipLength)
Clip4=Subtitle(Clip4, "CLIP 4", font="arial", size=24, text_color=$FFFFFF, align=5)

#create example clip 5	(Slave, grey)
Clip5=BlankClip(color=$808080, fps=ClipFPS, length=ClipLength)
Clip5=Subtitle(Clip5, "CLIP 5", font="arial", size=24, text_color=$FFFFFF, align=5)

#create example clip 6	(Slave, white)
Clip6=BlankClip(color=$FFFFFF, fps=ClipFPS, length=ClipLength)
Clip6=Subtitle(Clip6, "CLIP 6", font="arial", size=24, text_color=$000000, align=5)

#PictureInPicture example
TempClip=BlankClip(color=$000000, fps=ClipFPS, length=ClipLength)
TempClip=Subtitle(TempClip, "PictureInPicture example with all possible PiP windows", font="arial", size=24, text_color=$FFFFFF, align=5)
TempClip=TempClip ++ PictureInPicture(Clip1, Clip2, 1, Scalefactor)
TempClip=TempClip ++ PictureInPicture(Clip1, Clip2, 2, Scalefactor)
TempClip=TempClip ++ PictureInPicture(Clip1, Clip2, 3, Scalefactor)
TempClip=TempClip ++ PictureInPicture(Clip1, Clip2, 4, Scalefactor)
TempClip=TempClip ++ PictureInPicture(Clip1, Clip2, 5, Scalefactor)

#PictureInPicture example
TempClip2=BlankClip(color=$000000, fps=ClipFPS, length=ClipLength)
TempClip2=Subtitle(TempClip2, "MultiPictureInPicture example with all possible PiP windows", font="arial", size=24, text_color=$FFFFFF, align=5)
TempClip2=TempClip2 ++ MultiPictureInPicture(Clip1, Clip2, BlankClip(length=0), BlankClip(length=0), BlankClip(length=0), BlankClip(length=0), Scalefactor)
TempClip2=TempClip2 ++ MultiPictureInPicture(Clip1, Clip2, Clip3, BlankClip(length=0), BlankClip(length=0), BlankClip(length=0), Scalefactor)
TempClip2=TempClip2 ++ MultiPictureInPicture(Clip1, Clip2, Clip3, Clip4, BlankClip(length=0), BlankClip(length=0), Scalefactor)
TempClip2=TempClip2 ++ MultiPictureInPicture(Clip1, Clip2, Clip3, Clip4, Clip5, BlankClip(length=0), Scalefactor)
TempClip2=TempClip2 ++ MultiPictureInPicture(Clip1, Clip2, Clip3, Clip4, Clip5, Clip6, Scalefactor)

#PictureInPicture example
TempClip3=BlankClip(color=$000000, fps=ClipFPS, length=ClipLength)
TempClip3=Subtitle(TempClip3, "PictureAndPicture example", font="arial", size=24, text_color=$FFFFFF, align=5)
TempClip3=TempClip3 ++ PictureAndPicture(Clip1, Clip2, true)

#MultiPictureAndPicture example
TempClip4=BlankClip(color=$000000, fps=ClipFPS, length=ClipLength)
TempClip4=Subtitle(TempClip4, "MultiPictureAndPicture example\nwith all possible PiP/PaP windows ", font="arial", size=24, text_color=$FFFFFF, align=5, lsp=0)
TempClip5=MultiPictureAndPicture(Clip1, BlankClip(Clip1), BlankClip(Clip1), BlankClip(Clip1), false)
TempClip5=TempClip5 ++ MultiPictureAndPicture(Clip1, Clip2, BlankClip(Clip1), BlankClip(Clip1), false)
TempClip5=TempClip5 ++ MultiPictureAndPicture(Clip1, Clip2, Clip3, BlankClip(Clip1), false)
TempClip5=TempClip5 ++ MultiPictureAndPicture(Clip1, Clip2, Clip3, Clip4, false)
TempClip4=TempClip4 ++ LanczosResize(TempClip5, TempClip4.Width, TempClip4.Height)

#return all temp clips combined as output
return TempClip ++ TempClip2 ++ TempClip3 ++ TempClip4
