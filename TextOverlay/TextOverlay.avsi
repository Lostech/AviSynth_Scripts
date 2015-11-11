/*
Avisynth Script:	TextOverlay.avsi
Version:			1.0
Copyright:			© Lostech 2015
Homepage:			www.lostech.de.vu
					www.github.com/lostech
License:			GPLv2
					https://www.gnu.org/licenses/gpl-2.0.html
Description:		Text overlay functions for e.g. for titles or subtitles
Function API:		TextFadeInOut(clip BaseClip, int X, int Y, int StartFrame, int EndFrame, string Text, string FontName, int MaxFontSize, int FontColor, int FontBorderColor)
					TextMoveInOut(clip BaseClip, int X, int Y, int X2, int Y2, int StartFrame, int EndFrame, string Text, string FontName, int MaxFontSize, int FontColor, int FontBorderColor)
					* clip BaseClip			= video clip on which the text overlay shall be created
					* int X, int Y			= start position offset for text overlay
					* int X2, int Y2		= end position offset for text overlay
					* int StartFrame		= define first frame of BaseClip at which text overlay shall start
					* int EndFrame			= define last frame of BaseClip at which text overlay shall end
					* string Text			= text to show in overlay
					* string FontName		= define font to be used for text overlay
					* int MaxFontSize		= define the (maximal) fontsize within overlay text animation
					* int FontColor			= color of the text overlay
					* int FontBorderColor	= border color of the text overlay
					
Remarks:			* Colors can be defined as usual in AviSynth as hexadecimal RGB values or also as constants.
					  See AviSynth documentation: http://avisynth.nl/index.php/Color_presets
					* If a text border isn´t desired set both FontColor & FontBorderColor to the same color value.
					* For a line break insert "\n" in your Text string.
					* To move a text with TextMoveInOut() completely from outside the border into the clip
					  set negative X/Y or greater than BaseClip width/height start coordinates.
					* Animation speed and duration is defined by the difference: EndFrame - StartFrame
					  Decrease the difference for a faster and increase for a slower animation/duration.
					* Multiline text can not be done in different colors but instead it is possible to create overlays
					  for every single line with its own color.
*/

#Wrapper for SubTitle() function for later easier usage in Animate() which enables line break option
function SubtitleWrapperForAnimate(clip BaseClip, string Text, int X, int Y, int StartFrame, int EndFrame, string FontName, int MaxFontSize, int FontColor, int FontBorderColor) {
    BaseClip.Subtitle(Text, X, Y, StartFrame, EndFrame, font=FontName, size=MaxFontSize, text_color=FontColor, halo_color=FontBorderColor, lsp=0)
}

#Fade text in and out by scaling the text size from 0 to maximum back to 0
function TextFadeInOut(clip BaseClip, int X, int Y, int StartFrame, int EndFrame, string Text, string FontName, int MaxFontSize, int FontColor, int FontBorderColor){
	#insert warning in case of empty text
	Text=(Text == "")?Eval("""return "Error: no text""""):Text
	
	#calculate 25% of duration for "fade in frames"
	Pos1=StartFrame + Round ((EndFrame - StartFrame ) * 0.25)
	#calculate 25% of duration for "fade out frames"
	Pos2=EndFrame - Round ((EndFrame - StartFrame ) * 0.25)

	#Do animation
	BaseClip=Animate(BaseClip, StartFrame, Pos1, "SubtitleWrapperForAnimate", Text, X, Y, StartFrame, Pos1, FontName, 0, FontColor, FontBorderColor, Text, X, Y, StartFrame, Pos1, FontName, MaxFontSize, FontColor, FontBorderColor)
	BaseClip=Animate(BaseClip, Pos1, Pos2, "SubtitleWrapperForAnimate", Text, X, Y, Pos1, Pos2, FontName, MaxFontSize, FontColor, FontBorderColor, Text, X, Y, Pos1, Pos2, FontName, MaxFontSize, FontColor, FontBorderColor)
	BaseClip=Animate(BaseClip, Pos2, EndFrame, "SubtitleWrapperForAnimate", Text, X, Y, Pos2, EndFrame, FontName, MaxFontSize, FontColor, FontBorderColor, Text, X, Y, Pos2, EndFrame, FontName, 0, FontColor, FontBorderColor)
	return BaseClip
}

#Move text in and out at given coordinates
function TextMoveInOut(clip BaseClip, int X, int Y, int X2, int Y2, int StartFrame, int EndFrame, string Text, string FontName, int MaxFontSize, int FontColor, int FontBorderColor){
	#insert warning in case of empty text
	Text=(Text == "")?Eval("""return "Error: no text""""):Text

	#calculate 25% of duration for "fade in frames"
	Pos1=StartFrame + Round ((EndFrame - StartFrame ) * 0.25)
	#calculate 25% of duration for "fade out frames"
	Pos2=EndFrame - Round ((EndFrame - StartFrame ) * 0.25)

	#Do animation
	BaseClip=Animate(BaseClip, StartFrame, Pos1, "SubtitleWrapperForAnimate", Text, X, Y, StartFrame, Pos1, FontName, MaxFontSize, FontColor, FontBorderColor, Text, X2, Y2, StartFrame, Pos1, FontName, MaxFontSize, FontColor, FontBorderColor)
	BaseClip=Animate(BaseClip, Pos1, Pos2, "SubtitleWrapperForAnimate", Text, X2, Y2, Pos1, Pos2, FontName, MaxFontSize, FontColor, FontBorderColor, Text, X2, Y2, Pos1, Pos2, FontName, MaxFontSize, FontColor, FontBorderColor)
	BaseClip=Animate(BaseClip, Pos2, EndFrame, "SubtitleWrapperForAnimate", Text, X2, Y2, Pos2, EndFrame, FontName, MaxFontSize, FontColor, FontBorderColor, Text, X, Y, Pos2, EndFrame, FontName, MaxFontSize, FontColor, FontBorderColor)
	return BaseClip
}

#Move and fade text in and out at given coordinates
function TextFadeMoveInOut(clip BaseClip, int X, int Y, int X2, int Y2, int StartFrame, int EndFrame, string Text, string FontName, int MaxFontSize, int FontColor, int FontBorderColor){
	#insert warning in case of empty text
	Text=(Text == "")?Eval("""return "Error: no text""""):Text
	
	#calculate 25% of duration for "fade in frames"
	Pos1=StartFrame + Round ((EndFrame - StartFrame ) * 0.25)
	#calculate 25% of duration for "fade out frames"
	Pos2=EndFrame - Round ((EndFrame - StartFrame ) * 0.25)

	#Do animation
	BaseClip=Animate(BaseClip, StartFrame, Pos1, "SubtitleWrapperForAnimate", Text, X, Y, StartFrame, Pos1, FontName, 0, FontColor, FontBorderColor, Text, X2, Y2, StartFrame, Pos1, FontName, MaxFontSize, FontColor, FontBorderColor)
	BaseClip=Animate(BaseClip, Pos1, Pos2, "SubtitleWrapperForAnimate", Text, X2, Y2, Pos1, Pos2, FontName, MaxFontSize, FontColor, FontBorderColor, Text, X2, Y2, Pos1, Pos2, FontName, MaxFontSize, FontColor, FontBorderColor)
	BaseClip=Animate(BaseClip, Pos2, EndFrame, "SubtitleWrapperForAnimate", Text, X2, Y2, Pos2, EndFrame, FontName, MaxFontSize, FontColor, FontBorderColor, Text, X, Y, Pos2, EndFrame, FontName, 0, FontColor, FontBorderColor)
	return BaseClip
}
__end__ #of script
