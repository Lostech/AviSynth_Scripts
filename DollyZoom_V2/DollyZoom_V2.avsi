/*
Avisynth Script:	DollyZoom_V2.avsi
Version:			1.0
Copyright:			© Lostech 2015
Homepage:			www.lostech.de.vu
					www.github.com/lostech
License:			GPLv2
					https://www.gnu.org/licenses/gpl-2.0.html
Description:		Simple DollyZoom Animation Effect V2
Function API:		DoDollyZoomV2Animation(clip Frame, int Frames)
					DoDollyZoomV2Animation(string Picture, int Frames)
					DoDollyZoomV2InversAnimation(clip Frame, int Frames)
					DoDollyZoomV2InversAnimation(string Picture, int Frames)
					
					General arguments for all functions (use only those depending on the desired function call):
					* string Picture	= path to start picture file
					* clip Frame		= start clip
					* int Frames		= number of frames per transition step
*/

function DollyZoomV2(clip Frame, int Morph){
	#read in sources and make sure it is only one frame
	stillframe=Trim(Frame, Frame.FrameCount(), -1).ConvertToRGB32()			#make sure to get only the last frame
	
	#backup original size of stillframe picture
	Width=stillframe.Width
	Height=stillframe.Height
	
	#create 3 sections of the original pictures and shift them as planes
	
	#calculate section heights
	TopHeight=Round(Height / 3)
	MiddleHeight=Round(Height / 3)
	BottomHeight=Height - TopHeight - MiddleHeight
	
	#resize/crop from 100% to max. 150% for top section
	Top=LanczosResize(stillframe, Round(Width * (1.5 - (morph * 0.01))), Round(Height * (1.5 - (morph * 0.01))))
	Top=Crop(Top, Round((Top.Width-Width) / 2), Round((Top.Height-Height) / 2), Width, TopHeight) 
	Top=LanczosResize(Top, Width, TopHeight)
	
	#resize/crop to static 150% for middle section
	Middle=LanczosResize(stillframe, Round(Width * 1.5), Round(Height * 1.5))
	Middle=Crop(Middle, Round((Middle.Width - Width) / 2), Round((Middle.Height - Height) / 2) + TopHeight, Width, MiddleHeight)
	
	#resize/crop from 150% to max. 200% bottom section
	Bottom=LanczosResize(stillframe, Round(Width * (150 + Morph) / 100), Round(Height * (150 + Morph) / 100))
	Bottom=Crop(Bottom, Round((Bottom.Width - Width) / 2), Round((Bottom.Height - Height) / 2) + TopHeight + MiddleHeight, width, BottomHeight)
	
	#stack all plane sections back
	output=StackVertical(Top, Middle, Bottom)
	return Output
}

#create DollyZoom V2 animation
function ZoomAnimationV2(clip Frame, int Frames){
	Animation=DollyZoomV2(Frame, 0).Loop(Frames)
	Animation=Animation ++ DollyZoomV2(Frame, 5).Loop(Frames)
	Animation=Animation ++ DollyZoomV2(Frame, 10).Loop(Frames)
	Animation=Animation ++ DollyZoomV2(Frame, 15).Loop(Frames)
	Animation=Animation ++ DollyZoomV2(Frame, 20).Loop(Frames)
	Animation=Animation ++ DollyZoomV2(Frame, 25).Loop(Frames)
	Animation=Animation ++ DollyZoomV2(Frame, 30).Loop(Frames)
	Animation=Animation ++ DollyZoomV2(Frame, 35).Loop(Frames)
	Animation=Animation ++ DollyZoomV2(Frame, 40).Loop(Frames)
	Animation=Animation ++ DollyZoomV2(Frame, 45).Loop(Frames)
	Animation=Animation ++ DollyZoomV2(Frame, 50).Loop(Frames)
	return Animation.KillAudio()
}

#create inverted DollyZoom V2 animation
function ZoomAnimationV2Invers(clip Frame, int Frames){
	Animation=DollyZoomV2(Frame, 50).Loop(Frames)
	Animation=Animation ++ DollyZoomV2(Frame, 45).Loop(Frames)
	Animation=Animation ++ DollyZoomV2(Frame, 40).Loop(Frames)
	Animation=Animation ++ DollyZoomV2(Frame, 35).Loop(Frames)
	Animation=Animation ++ DollyZoomV2(Frame, 30).Loop(Frames)
	Animation=Animation ++ DollyZoomV2(Frame, 25).Loop(Frames)
	Animation=Animation ++ DollyZoomV2(Frame, 20).Loop(Frames)
	Animation=Animation ++ DollyZoomV2(Frame, 15).Loop(Frames)
	Animation=Animation ++ DollyZoomV2(Frame, 10).Loop(Frames)
	Animation=Animation ++ DollyZoomV2(Frame, 5).Loop(Frames)
	Animation=Animation ++ DollyZoomV2(Frame, 0).Loop(Frames)
	return Animation.KillAudio()
}	

#DollyZoomV2 animation wrapper
function DoDollyZoomV2Animation(clip Frame, int Frames){
	Animation=ZoomAnimationV2(Frame, Frames)
	return Animation
}

#DollyZoomV2 animation wrapper overloaded
function DoDollyZoomV2Animation(string Picture, int Frames){
	Frame=ImageSource(Picture, 1, 1)
	Animation=ZoomAnimationV2(Frame, Frames)
	return Animation
}

#DollyZoomV2Invers animation wrapper
function DoDollyZoomV2InversAnimation(clip Frame, int Frames){
	Animation=ZoomAnimationV2Invers(Frame, Frames)
	return Animation
}

#DollyZoomV2Invers animation wrapper overloaded
function DoDollyZoomV2InversAnimation(string Picture, int Frames){
	Frame=ImageSource(Picture, 1, 1)
	Animation=ZoomAnimationV2Invers(Frame, Frames)
	return Animation
}

__end__ #of script
