#Import DollyZoom_V2 script
Import("DollyZoom_V2.avsi")

#create example clip 1 with regular zoom effect
TempClip=ColorBars()
TempClip=Subtitle(TempClip, "DollyZoom V2 example", font="arial", size=24, text_color=$FFFFFF, align=5)
Clip1=DoDollyZoomV2Animation(TempClip, 5)

#create example clip 2 with invers zoom effect
TempClip=ColorBars()
TempClip=Subtitle(TempClip, "DollyZoom V2 example (invers)", font="arial", size=24, text_color=$FFFFFF, align=5)
Clip2=DoDollyZoomV2InversAnimation(TempClip, 5)

#combine clips
Output=Clip1 ++ Clip2

#return output
return Output
