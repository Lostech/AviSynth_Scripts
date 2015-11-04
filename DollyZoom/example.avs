#Import DollyZoom script
Import("DollyZoom.avsi")

#create example clip 1 without round mask
TempClip=ColorBars()
TempClip=Subtitle(TempClip, "DollyZoom example without mask", font="arial", size=24, text_color=$FFFFFF, align=5)
Clip1=DoDollyZoomAnimation(TempClip, 5, false)

#create example clip 2 with round mask
TempClip=ColorBars()
TempClip=Subtitle(TempClip, "DollyZoom example with round mask", font="arial", size=24, text_color=$FFFFFF, align=5)
Clip2=DoDollyZoomAnimation(TempClip, 5, true)

#combine clips
Output=Clip1 ++ Clip2

#return output
return Output
