/*
Avisynth Script:	DollyZoom.avsi
Version:			1.0
Copyright:			© Lostech 2015
Homepage:			www.lostech.de.vu
					www.github.com/lostech
License:			GPLv2
					https://www.gnu.org/licenses/gpl-2.0.html
Description:		Simple DollyZoom Animation Effect
Function API:		DoDollyZoomAnimation(string Picture, int Frames, bool UseRoundMask)
					DoDollyZoomAnimation(clip Frame, int Frames, bool UseRoundMask)
					DoDollyExchangeAnimation(string Picture, string Picture2, int Frames, bool UseRoundMask)
					DoDollyExchangeAnimation(clip Frame, clip Frame2, int Frames, bool UseRoundMask)
					
					General arguments for all functions (use only those depending on the desired function call):
					* string Picture	= path to start picture file
					* string Picture2	= path to end picture file
					* clip Frame		= start clip
					* clip Frame2		= end clip
					* int Frames		= number of frames per transition step
					* bool UseRoundMask	= rounded inner animation (true) or regular square inner animation (false) !will slow down script execution speed!
*/

#constants
global DollyZoomMask="DollyZoomMask.bmp"		#Bitmap file for round mask

#main DollyZoom function
function DollyZoom(clip Frame, clip Frame2, int Percent, bool UseRoundMask){
	#read in sources and make sure it is only one frame
	pic1=Trim(Frame, Frame.FrameCount(), -1).ConvertToRGB32()			#make sure to get only the last frame
	pic2=Trim(Frame2, 0, -1).ConvertToRGB32()							#make sure to get only the first frame
	
	#backup original size of first picture
	Width=pic1.Width
	Height=pic1.Height

	#resize and crop picture 1 as new background
	pic1=LanczosResize(pic1, Round(pic1.Width * (200 - Percent) / 100), Round(pic1.Height * (200 - Percent) / 100))
	pic1=Crop(pic1, Round((pic1.Width - Width) / 2), Round((pic1.Height - Height) / 2), -(Round((pic1.Width - Width) / 2)), -(Round((pic1.Height - Height) / 2)))
	pic1=LanczosResize(pic1, Width, Height)

	#resize picture 2 as new foreground with base size of picture 1 otherwise animation will not run fluidly to 100% if picture size is different
	pic2=LanczosResize(pic2, Round(Width * Percent / 100), Round(Height * Percent / 100))
	
	#create optional rounded mask on picture 2
	circle=(UseRoundMask == true)?Eval("""ImageSource(DollyZoomMask, 1, 1).ConvertToRGB32()"""):NOP()
	circle=(UseRoundMask == true)?Eval("""LanczosResize(circle,pic2.Width,pic2.Height)"""):NOP()
	mask=(UseRoundMask == true)?Eval("""BlankClip(circle, color=$000000)"""):NOP()
	mask=(UseRoundMask == true)?Eval("""ColorKeyMask(circle, $000000, 100)"""):NOP()
	pic2=(UseRoundMask == true)?Eval("""Overlay(circle, pic2, 0, 0, mask=ShowAlpha(mask), mode="Blend", opacity=1)"""):pic2
	mask=(UseRoundMask == true)?Eval("""ColorKeyMask(pic2, $000000, 0)"""):NOP()

	#overlay foreground picture 2 on background picture 1
	output=(UseRoundMask == true)?Eval("""Overlay(pic1, pic2, Round((Width / 2)-(pic2.Width / 2)), (Height / 2)-(pic2.Height / 2), mask=ShowAlpha(mask), mode="Blend", opacity=1)"""):Eval("""Overlay(pic1, pic2, Round((Width / 2)-(pic2.Width / 2)), (Height / 2)-(pic2.Height / 2), mode="Blend", opacity=1)""")
	return output
}

#Build zoom animation based on DollyZoom with still frames as source
function ZoomAnimation(clip Frame, clip Frame2, int Frames, bool UseRoundMask){
	Animation=DollyZoom(Frame, Frame2, 1, UseRoundMask).Loop(Frames)
	Animation=Animation ++ DollyZoom(Frame, Frame2, 5, UseRoundMask).Loop(Frames)
	Animation=Animation ++ DollyZoom(Frame, Frame2, 10, UseRoundMask).Loop(Frames)
	Animation=Animation ++ DollyZoom(Frame, Frame2, 15, UseRoundMask).Loop(Frames)
	Animation=Animation ++ DollyZoom(Frame, Frame2, 20, UseRoundMask).Loop(Frames)
	Animation=Animation ++ DollyZoom(Frame, Frame2, 25, UseRoundMask).Loop(Frames)
	Animation=Animation ++ DollyZoom(Frame, Frame2, 30, UseRoundMask).Loop(Frames)
	Animation=Animation ++ DollyZoom(Frame, Frame2, 35, UseRoundMask).Loop(Frames)
	Animation=Animation ++ DollyZoom(Frame, Frame2, 40, UseRoundMask).Loop(Frames)
	Animation=Animation ++ DollyZoom(Frame, Frame2, 45, UseRoundMask).Loop(Frames)
	Animation=Animation ++ DollyZoom(Frame, Frame2, 50, UseRoundMask).Loop(Frames)
	Animation=Animation ++ DollyZoom(Frame, Frame2, 55, UseRoundMask).Loop(Frames)
	Animation=Animation ++ DollyZoom(Frame, Frame2, 60, UseRoundMask).Loop(Frames)
	Animation=Animation ++ DollyZoom(Frame, Frame2, 65, UseRoundMask).Loop(Frames)
	Animation=Animation ++ DollyZoom(Frame, Frame2, 70, UseRoundMask).Loop(Frames)
	Animation=Animation ++ DollyZoom(Frame, Frame2, 75, UseRoundMask).Loop(Frames)
	Animation=Animation ++ DollyZoom(Frame, Frame2, 80, UseRoundMask).Loop(Frames)
	Animation=Animation ++ DollyZoom(Frame, Frame2, 85, UseRoundMask).Loop(Frames)
	Animation=Animation ++ DollyZoom(Frame, Frame2, 90, UseRoundMask).Loop(Frames)
	Animation=Animation ++ DollyZoom(Frame, Frame2, 95, UseRoundMask).Loop(Frames)
	Animation=Animation ++ Trim(Frame2, 0, -1).LanczosResize(Animation.Width, Animation.Height).ConvertToRGB32().Loop(Frames)
	return Animation.KillAudio()
}

#Build zoom animation based on DollyZoom with animation as source
function ZoomAnimation2(clip Video, clip Video2, int Frames, bool UseRoundMask){
	#trim single frames of the video clips and animate them
	#single frames for background animation are derived from "Video" endpostion - the according frame position, for e.g. end-19 for step 0, end-20 for step 1 etc.
	#single frames for foreground animation are derived from "Video2" startpostion + the according frame position, for e.g. start+0 for step 0, start+1 for step 1 etc.
	
	#Offset for starting position in "Video" clip
	VideoFrameCount=Video.FrameCount()
	
	#animate with changing frames
	Frame=Trim(Video, VideoFrameCount-19, -1)
	Frame2=Trim(Video2, 0, -1)
	Animation=DollyZoom(Frame, Frame2, 1, UseRoundMask).Loop(Frames)
	Frame=Trim(Video, VideoFrameCount-18, -1)
	Frame2=Trim(Video2, 1, -1)
	Animation=Animation ++ DollyZoom(Frame, Frame2, 5, UseRoundMask).Loop(Frames)
	Frame=Trim(Video, VideoFrameCount-17, -1)
	Frame2=Trim(Video2, 2, -1)
	Animation=Animation ++ DollyZoom(Frame, Frame2, 10, UseRoundMask).Loop(Frames)
	Frame=Trim(Video, VideoFrameCount-16, -1)
	Frame2=Trim(Video2, 3, -1)
	Animation=Animation ++ DollyZoom(Frame, Frame2, 15, UseRoundMask).Loop(Frames)
	Frame=Trim(Video, VideoFrameCount-15, -1)
	Frame2=Trim(Video2, 4, -1)
	Animation=Animation ++ DollyZoom(Frame, Frame2, 20, UseRoundMask).Loop(Frames)
	Frame=Trim(Video, VideoFrameCount-14, -1)
	Frame2=Trim(Video2, 5, -1)
	Animation=Animation ++ DollyZoom(Frame, Frame2, 25, UseRoundMask).Loop(Frames)
	Frame=Trim(Video, VideoFrameCount-13, -1)
	Frame2=Trim(Video2, 6, -1)
	Animation=Animation ++ DollyZoom(Frame, Frame2, 30, UseRoundMask).Loop(Frames)
	Frame=Trim(Video, VideoFrameCount-12, -1)
	Frame2=Trim(Video2, 7, -1)
	Animation=Animation ++ DollyZoom(Frame, Frame2, 35, UseRoundMask).Loop(Frames)
	Frame=Trim(Video, VideoFrameCount-11, -1)
	Frame2=Trim(Video2, 8, -1)
	Animation=Animation ++ DollyZoom(Frame, Frame2, 40, UseRoundMask).Loop(Frames)
	Frame=Trim(Video, VideoFrameCount-10, -1)
	Frame2=Trim(Video2, 9, -1)
	Animation=Animation ++ DollyZoom(Frame, Frame2, 45, UseRoundMask).Loop(Frames)
	Frame=Trim(Video, VideoFrameCount-9, -1)
	Frame2=Trim(Video2, 10, -1)
	Animation=Animation ++ DollyZoom(Frame, Frame2, 50, UseRoundMask).Loop(Frames)
	Frame=Trim(Video, VideoFrameCount-8, -1)
	Frame2=Trim(Video2, 11, -1)
	Animation=Animation ++ DollyZoom(Frame, Frame2, 55, UseRoundMask).Loop(Frames)
	Frame=Trim(Video, VideoFrameCount-7, -1)
	Frame2=Trim(Video2, 12, -1)
	Animation=Animation ++ DollyZoom(Frame, Frame2, 60, UseRoundMask).Loop(Frames)
	Frame=Trim(Video, VideoFrameCount-6, -1)
	Frame2=Trim(Video2, 13, -1)
	Animation=Animation ++ DollyZoom(Frame, Frame2, 65, UseRoundMask).Loop(Frames)
	Frame=Trim(Video, VideoFrameCount-5, -1)
	Frame2=Trim(Video2, 14, -1)
	Animation=Animation ++ DollyZoom(Frame, Frame2, 70, UseRoundMask).Loop(Frames)
	Frame=Trim(Video, VideoFrameCount-4, -1)
	Frame2=Trim(Video2, 15, -1)
	Animation=Animation ++ DollyZoom(Frame, Frame2, 75, UseRoundMask).Loop(Frames)
	Frame=Trim(Video, VideoFrameCount-3, -1)
	Frame2=Trim(Video2, 16, -1)
	Animation=Animation ++ DollyZoom(Frame, Frame2, 80, UseRoundMask).Loop(Frames)
	Frame=Trim(Video, VideoFrameCount-2, -1)
	Frame2=Trim(Video2, 17, -1)
	Animation=Animation ++ DollyZoom(Frame, Frame2, 85, UseRoundMask).Loop(Frames)
	Frame=Trim(Video, VideoFrameCount-1, -1)
	Frame2=Trim(Video2, 18, -1)
	Animation=Animation ++ DollyZoom(Frame, Frame2, 90, UseRoundMask).Loop(Frames)
	Frame=Trim(Video, VideoFrameCount, -1)
	Frame2=Trim(Video2, 19, -1)
	Animation=Animation ++ DollyZoom(Frame, Frame2, 95, UseRoundMask).Loop(Frames)

	#last frame = full Video2 first frame
	Animation=Animation ++ Trim(Frame2, 0, -1).LanczosResize(Animation.Width, Animation.Height).ConvertToRGB32().Loop(Frames)
	return Animation.KillAudio()
}

#DollyZoom animation wrapper
function DoDollyZoomAnimation(string Picture, int Frames, bool UseRoundMask){
	Frame=ImageSource(Picture, 1, 1)
	Animation=ZoomAnimation(Frame, Frame, Frames, UseRoundMask)
	return Animation
}
#DollyZoom animation wrapper overloaded
function DoDollyZoomAnimation(clip Frame, int Frames, bool UseRoundMask){
	Animation=ZoomAnimation(Frame, Frame, Frames, UseRoundMask)
	return Animation
}
#DollyZoom animation wrapper for clips instead of still frames
function DoDollyZoomAnimation2(clip Video, int Frames, bool UseRoundMask){
	Animation=ZoomAnimation2(Video, Video, Frames, UseRoundMask)
	return Animation
}

#DollyZoom exchange animation wrapper
function DoDollyExchangeAnimation(string Picture, string Picture2, int Frames, bool UseRoundMask){
	Frame=ImageSource(Picture, 1, 1)
	Frame2=ImageSource(Picture2, 1, 1)
	Animation=ZoomAnimation(Frame, Frame2, Frames, UseRoundMask)
	return Animation
}
#DollyZoom exchange animation wrapper overloader
function DoDollyExchangeAnimation(clip Frame, clip Frame2, int Frames, bool UseRoundMask){
	Animation=ZoomAnimation(Frame, Frame2, Frames, UseRoundMask)
	return Animation
}
#DollyZoom exchange animation wrapper for clips instead of still frames
function DoDollyExchangeAnimation2(clip Video, clip Video2, int Frames, bool UseRoundMask){
	Animation=ZoomAnimation2(Video, Video2, Frames, UseRoundMask)
	return Animation
}

__end__ #of script
