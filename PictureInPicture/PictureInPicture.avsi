/*
Avisynth Script:	PictureInPicture.avsi
Version:			1.0
Copyright:			© Lostech 2015
Homepage:			www.lostech.de.vu
					www.github.com/lostech
License:			GPLv2
					https://www.gnu.org/licenses/gpl-2.0.html
Description:		Picture-in-Picture (PiP) / Picture-and-Picture (PaP) functions
Function API:		PictureInPicture(clip Master, clip Slave, int Quadrant, float Scalefactor)
					MultiPictureInPicture(clip Master, clip TopLeft, clip TopRight, clip BottomLeft, clip BottomRight, clip Center, float Scalefactor)
					PictureAndPicture(clip Master, clip Slave, bool KeepMasterInputSize)
					MultiPictureAndPicture(clip Master, clip TopRight, clip BottomLeft, clip BottomRight, bool KeepMasterInputSize)
					
					General arguments for all functions (use only those depending on the desired function call):
					* clip Master	 	= video for fullscreen (PiP) or left side (PaP)
					* clip Slave		= video for PiP window or right side (PaP)
					* int Quadrant		= quadrant position for PiP window. Allowed values: 1-5
					
											1=top left				2=top right
														  5=center
											3=bottom left			4=bottom right
					
					* clip TopLeft		= MultiPicture clip for top left PiP window, set to "BlankClip(length=0)" for hiding this PiP window
					* clip TopRight		= MultiPicture clip for top right PiP window, set to "BlankClip(length=0)" for hiding this PiP window
					* clip BottomLeft	= MultiPicture clip for bottom left PiP window, set to "BlankClip(length=0)" for hiding this PiP window
					* clip BottomRight	= MultiPicture clip for bottom right PiP window
					* clip Center		= MultiPicture clip for center PiP window
					* Scalefactor		= floating value between >0.01 and <1
										  for the scale of the PiP window compared to the master width
										  recommended values are between 0.3 and 0.4 but may differ depending on video sizes
					* bool KeepMasterInputSize	= true/false for PaP output video will be scaled down to master input size
					
Remarks:			* All slave/PiP videos will be scaled to master video size maintaining aspect ratio by adding black bars (aka letterbox/pillarbox).
					  If you want those videos without black bars then resize them to master video size before calling PiP/PaP functions.
					* Only master video will play audio, all other input clip will be muted.
					* For hiding a PiP window in MultiPictureInPicture set the according video clip to "BlankClip(length=0)"
					* For hiding a PaP window in MultiPictureAndPicture set the according video clip to "BlankClip(<clip Master>)"
					* Scalefactor values lower than ~0.02 may lead to a script failure due to PiP video sized to zero depending on master video size
*/

function PictureInPicture(clip Master, clip Slave, int Quadrant, float Scalefactor){
	#Mute audio for slave
	Slave=Slave.KillAudio()
	
	#border offset for PiP slave position
	boff=0.05

	#limit scalefactor to base value if > 1
	Scalefactor=(Scalefactor > 1)?Eval("""return 0.4"""):Scalefactor

	#limit scalefactor to base value if < 0.01 (more or less to prevent zero size)
	Scalefactor=(Scalefactor < 0.01)?Eval("""return 0.4"""):Scalefactor
	
	#new size for slave calculated by maximum master width * scale factor
	Slave=LanczosResize(Slave, Round(Master.Width * Scalefactor), Round(Round(Master.Width * Scalefactor) * Slave.Height / Slave.Width))
	
	#overlay slave on master
	Output=Master	#Fallback to master video if wrong quadrant is given
	#Quadrant 1 "top left"
	Output=(Quadrant == 1)?Eval("""Overlay(Master, Slave, x=Round(Master.Width * boff), y=Round(Master.Height * boff), mode="blend", opacity=1)"""):Output
	#Quadrant 2 "top right"
	Output=(Quadrant == 2)?Eval("""Overlay(Master, Slave, x=Round(Master.Width - (Master.Width * boff) - Slave.Width), y=Round(Master.Height * boff), mode="blend", opacity=1)"""):Output
	#Quadrant 3 "bottom left"
	Output=(Quadrant == 3)?Eval("""Overlay(Master, Slave, x=Round(Master.Width * boff), y=Round(Master.Height - (Master.Height * boff) - Slave.Height), mode="blend", opacity=1)"""):Output
	#Quadrant 4 "bottom right"
	Output=(Quadrant == 4)?Eval("""Overlay(Master, Slave, x=Round(Master.Width - (Master.Width * boff) - Slave.Width), y=Round(Master.Height - (Master.Height * boff) - Slave.Height), mode="blend", opacity=1)"""):Output
	#Quadrant 5 "Center"
	Output=(Quadrant == 5)?Eval("""Overlay(Master, Slave, x=Round(Master.Width / 2) - Round (Slave.Width / 2), y=Round(Master.Height / 2) - Round (Slave.Height / 2), mode="blend", opacity=1)"""):Output
	
	#return output
	return Output
}

function MultiPictureInPicture(clip Master, clip TopLeft, clip TopRight, clip BottomLeft, clip BottomRight, clip Center, float Scalefactor){
	#Mute audio for all slaves
	TopLeft=TopLeft.KillAudio()
	TopRight=TopRight.KillAudio()
	BottomLeft=BottomLeft.KillAudio()
	BottomRight=BottomRight.KillAudio()
	Center=Center.KillAudio()
	
	#border offset for PiP slave position
	boff=0.05

	#limit scalefactor to base value if > 1
	Scalefactor=(Scalefactor > 1)?Eval("""return 0.4"""):Scalefactor
	
	#new size for slave calculated by maximum master width * scale factor
	TopLeft=LanczosResize(TopLeft, Round(Master.Width * Scalefactor), Round(Round(Master.Width * Scalefactor) * TopLeft.Height / TopLeft.Width))
	TopRight=LanczosResize(TopRight, Round(Master.Width * Scalefactor), Round(Round(Master.Width * Scalefactor) * TopRight.Height / TopRight.Width))
	BottomLeft=LanczosResize(BottomLeft, Round(Master.Width * Scalefactor), Round(Round(Master.Width * Scalefactor) * BottomLeft.Height / BottomLeft.Width))
	BottomRight=LanczosResize(BottomRight, Round(Master.Width * Scalefactor), Round(Round(Master.Width * Scalefactor) * BottomRight.Height / BottomRight.Width))
	Center=LanczosResize(Center, Round(Master.Width * Scalefactor), Round(Round(Master.Width * Scalefactor) * Center.Height / Center.Width))
	
	#overlay PiP video windows on master only if framecount for according clip is higher than 0
	Output=Master	#Fallback to master video if no PiP video clip is available
	#Quadrant 1 "top left"
	Output=(TopLeft.FrameCount != 0)?Eval("""Overlay(Master, TopLeft, x=Round(Master.Width * boff), y=Round(Master.Height * boff), mode="blend", opacity=1)"""):Output
	#Quadrant 2 "top right"
	Output=(TopRight.FrameCount != 0)?Eval("""Overlay(Output, TopRight, x=Round(Master.Width - (Master.Width * boff) - TopRight.Width), y=Round(Master.Height * boff), mode="blend", opacity=1)"""):Output
	#Quadrant 3 "bottom left"	
	Output=(BottomLeft.FrameCount != 0)?Eval("""Overlay(Output, BottomLeft, x=Round(Master.Width * boff), y=Round(Master.Height - (Master.Height * boff) - BottomLeft.Height), mode="blend", opacity=1)"""):Output
	#Quadrant 4 "bottom right"
	Output=(BottomRight.FrameCount != 0)?Eval("""Overlay(Output, BottomRight, x=Round(Master.Width - (Master.Width * boff) - BottomRight.Width), y=Round(Master.Height - (Master.Height * boff) - BottomRight.Height), mode="blend", opacity=1)"""):Output
	#Quadrant 5 "center"
	Output=(Center.FrameCount != 0)?Eval("""Overlay(Output, Center, x=Round(Master.Width / 2) - Round (Center.Width / 2), y=Round(Master.Height / 2) - Round (Center.Height / 2), mode="blend", opacity=1)"""):Output
	
	#return output
	return Output
}

function PictureAndPicture(clip Master, clip Slave, bool KeepMasterInputSize){
	#Mute audio for slave
	Slave=Slave.KillAudio()
	
	#backup original master size
	x=Master.Width
	y=Master.Height
	
	#backup slave aspect ratio
	sar=(Float(Slave.Width) / Float(Slave.Height))
	
	#resize slave height with keeping aspect ratio if master height is smaller
	(Slave.Height >= y)?Eval("""
			sy=y
			sx=int(float(sy) * sar)
			sx=((sx / 2) * 2)
			Slave=LanczosResize(Slave, sx, sy)			
			Slave=AddBorders(Slave,(((x - Slave.Width) / 4) * 2), 0, (((x - Slave.Width) / 4) * 2), 0, $000000)
			return Slave
			"""): Eval("""""")
			
	#resize slave width with keeping aspect ratio if master width is smaller
	(Slave.Width >= x)?Eval("""
			sx=x
			sy=int(float(sx) / sar)
			sy=((sy / 2) * 2)	
			Slave=LanczosResize(Slave, sx, sy)			
			Slave=AddBorders(Slave, 0, (((y - Slave.Height) / 4) * 2), 0, (((y - Slave.Height) / 4) * 2), $000000)
			return Slave
			"""): Eval("""""")

	#make slave 100% fit to master size to prevent small differences due to rounding
	Slave=LanczosResize(Slave, x, y)
	
	#stack master and slave for new output
	Output=StackHorizontal(Master, Slave)
	
	#resize output to original master size if desired
	#first squeeze output
	Output=(KeepMasterInputSize == true)?Eval("""LanczosResize(Output, x, Round(y / 2))"""):Output
	#finally add letterbox borders
	Output=(KeepMasterInputSize == true)?Eval("""AddBorders(Output, 0, Round((y - Output.Height) / 2), 0, Round((y - Output.Height) / 2), $000000)"""):Output
	
	#return output
	return Output
}

function MultiPictureAndPicture(clip Master, clip TopRight, clip BottomLeft, clip BottomRight, bool KeepMasterInputSize){
	#combine master and top right video
	TopRow=PictureAndPicture(Master, TopRight, KeepMasterInputSize)
	
	#mute BottomLeft video to maintain master audio as only audio
	BottomLeft.KillAudio()
	
	#combine bottom right and bottom left video
	BottomRow=PictureAndPicture(BottomLeft, BottomRight, KeepMasterInputSize)
	
	#scale bottom row size to top row size if different and maintain aspect ratio
	((BottomRow.Width != TopRow.Width) || (BottomRow.Height != TopRow.Height))?Eval("""
			bx=TopRow.Width
			by=int(float(bx) / (BottomRow.Width / BottomRow.Height))
			by=((by / 2) * 2)
			BottomRow=LanczosResize(BottomRow, bx, by)
			return BottomRow
			"""): Eval("""""")			
			
	#stack both rows
	return StackVertical(TopRow, BottomRow)
}
__end__ #of script

	bx=TopRow.Width
	by=int(float(bx) / (BottomRow.Width / BottomRow.Height))
	by=((by / 2) * 2)
	BottomRow=LanczosResize(BottomRow, bx, by)