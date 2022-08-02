-- Singlestar TAS Timing LUA script (v0.2)
-- Authors: 4232Nis, Superdavo0001, ShadoXFM

mode = -1 -- -1 = before level-entry, 0 = during transition or star-select, 1 = timing active, 2 = star-grab completed, 3 = all timing completed
initialVI = 0 --First VI at the start of the run (1f after the level loads, as per TAS timing)
currentVI = 0 --The current VI on a given frame
lastVI = 0 --The VI of the frame before the current frame (used to detect savestate loading)
finalVI = 0 --The final VI at the end of the run in TAS timing (the VI when Mario lands after collecting the star & turns to face the camera)
finalVI_Stargrab = 0 --The final VI at the end of the run in stargrab timing (the VI when the star is replaced by a 'poof' of dust particles)

currentFrame = 0 --The current input frame being handled
initialFrame = 0 --First input frame at the start of the run (1f after the level loads, as per TAS timing)
finalFrame = 0 --The final input frame at the end of the run in TAS timing (the input frame when Mario lands after collecting the star & turns to face the camera)
finalFrame_Stargrab = 0 --The final input frame at the end of the run in stargrab timing (the input frame when the star is replaced by a 'poof' of dust particles)

action = 0x0B3B17C --dword
actionJP = 0x80339E0C
animation = 0x00B47B00 --sshort
paction = 0x0B3B180 --dword
atimer = 0x0B3B198 --byte
animtimer = 0x0B4A828 --word

effMarioObj = 0x00B61158 --dword, =0 in star-select but has a specific nonzero value otherwise
effMarioObjJP = 0x80346758

function main()
	currentVI = emu.framecount()
	currentFrame = emu.samplecount()
	-- print(memory.readdword(effMarioObjJP))

	if mode == -1 then --If level transition or star-select not already reached, check for entering star-select, signified by Mario's object being null
		if (memory.readdword(effMarioObj) == 0) then
			mode = 0
		end
	end

	if mode == 0 then --If in star-select or a level transition, check for Mario's effective object being nonzero - which occurs when the new level loads, and if found, set initial VI/frame & start the timer
	    if (memory.readdword(effMarioObj) > 0) then
			initialVI = emu.framecount()
			initialFrame = emu.samplecount()
			mode = 1
		end
	end

	if mode == 1 then --If the timer is running, check if Mario is in the star-falling action. If so, set the final VI/frame for stargrab timing. This cue occurs 1f late so subtract 2 VIs to make up the difference
		if (memory.readdword(action) == 0x00001904) then
			finalVI_Stargrab = emu.framecount()
			finalFrame_Stargrab = emu.samplecount()
			mode = 2
		end
	end

	if mode == 1 then --If the timer is running, check if Mario is in the star dance water action. If so, set the final VI/frame for stargrab timing. This cue occurs 1f late so subtract 2 VIs to make up the difference
		if (memory.readdword(action) == 0x00001303) then
			finalVI_Stargrab = emu.framecount() - 2
			finalFrame_Stargrab = emu.samplecount() - 1
			mode = 2
		end
	end

	if mode==1 or mode == 2 then --Check if Mario is in the star-ground action. If so, set the final VI/frame for TAS/XCam timing and stop timing. If the stargrab timing hasn't stopped, stop that now (can happen when Mario hits the star on the ground)
		if (memory.readdword(action) == 0x00001302) then
			finalVI = emu.framecount()
			finalFrame = emu.samplecount()

			if mode==1 then
				finalVI = emu.framecount() - 2
				finalFrame = emu.samplecount() - 1
				finalFrame_Stargrab = emu.samplecount() - 1
				finalVI_Stargrab = emu.framecount() - 2
			end

			mode = 3
		end
	end

	if mode==1 or mode == 2 then --Check if Mario is in the star dance no exit action. If so, set the final VI/frame for TAS/XCam timing and stop timing. If the stargrab timing hasn't stopped, stop that now (can happen when Mario hits the star on the ground)
		if (memory.readdword(action) == 0x00001307) then
			finalVI = emu.framecount()
			finalFrame = emu.samplecount()

			if mode==1 then
				finalVI = emu.framecount() - 2
				finalFrame = emu.samplecount() - 1
				finalFrame_Stargrab = emu.samplecount() - 1
				finalVI_Stargrab = emu.framecount() - 2
			end

			mode = 4
		end
	end

	if mode == 4 then
		if (memory.readdword(action) ~= 0x00001307) then
			mode = 1
		end
	end

	if mode==1 or mode == 2 then --Check if Mario is in the star dance water action. If so, set the final VI/frame for TAS/XCam timing and stop timing. If the stargrab timing hasn't stopped, stop that now (can happen when Mario hits the star on the ground)
		if (memory.readdword(action) == 0x00001303) then
			finalVI = emu.framecount()
			finalFrame = emu.samplecount()

			if mode==1 then
				finalVI = emu.framecount() - 2
				finalFrame = emu.samplecount() - 1
				finalFrame_Stargrab = emu.samplecount() - 1
				finalVI_Stargrab = emu.framecount() - 2
			end

			mode = 3
		end
	elseif mode > 2 then --After timing is completed nothing else needs to be done here
	end

	if currentVI < lastVI then --If the VI has decreased since the last frame, an earlier savestate must have been loaded. In this case, reset the script by setting mode to -1
		mode = -1
	end

	lastVI = currentVI --Sets lastVI for use in the next frame

end

function getTime(vi) --Calculates the time for a given VI count (to 2 decimal places)
	return math.floor(vi * 10 / 6 + 0.5) / 100
end

function getTime_IGT(vi) --Calculates the time for a given VI count, as it would be if using an in-game timer which accounts for lag (2 VIs slower than getTime())
	return math.floor((vi+4) * 10 / 6 + 0.5)/100
end

function getTime_IGT_Frames(frame) --Calculates the time for a given frame count, as it would be using an in-game timer (1 frame slower than TAS timing)
	return math.floor((frame+2) * 10 / 3 + 0.5)/100
end

function whiteLine() --Draws a solid white line across the screen by drawing text and using the background
	wgui.setbk("black")
	local i = 0
	local aux = "   "
	return aux
end

function drawDisplay()
	wgui.setfont(60,"Arial","b") --Set the font and size
	wgui.setcolor("white") --Set the text colour
	wgui.setbrush("black") --Sets the colour of any drawn geometry

	-- if mode <= 0 then --Before timing starts, just display a simple message
	-- 	wgui.text(995,625,"0.00")
	if mode == 1 then --Display the current time while timing is active
		if getTime(currentVI - initialVI) <= 9.99 then
		wgui.text(995,625,string.format("%.2f", getTime(currentVI - initialVI)))
		else wgui.text(976,625,string.format("%.2f", getTime(currentVI - initialVI))) end
	elseif mode == 3 then --Display the final times for all formats
		wgui.setcolor("#00dcbf")
		if getTime(finalVI - initialVI) <= 9.99 then
		wgui.text(995,625,string.format("%.2f", getTime(finalVI - initialVI)))
		else wgui.text(976,625,string.format("%.2f", getTime(finalVI - initialVI))) end
	elseif mode == 4 then -- Briefly display final time for star dance no exit star
		wgui.setcolor("#00dcbf")
		if getTime(finalVI - initialVI) <= 9.99 then
		wgui.text(995,625,string.format("%.2f", getTime(finalVI - initialVI)))
		else wgui.text(976,625,string.format("%.2f", getTime(finalVI - initialVI))) end
	end

end

emu.atinput(main)
emu.atupdatescreen(drawDisplay)