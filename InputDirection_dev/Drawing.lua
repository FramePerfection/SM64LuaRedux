Drawing = {
	WIDTH_OFFSET = 222,
	Screen = {
		Height = 0,
		Width = 0
	},
	curColor = {},
	curFont = "",
	curFontSize = 10,
	curFontStyle = 0
}

local d2d = BreitbandGraphics.renderers.d2d

function Drawing.resizeScreen()
	screen = wgui.info()
	Drawing.Screen.Height = screen.height
	width10 = screen.width % 10
	if width10 == 0 or width10 == 4 or width10 == 8 then
		Drawing.Screen.Width = screen.width
		wgui.resize(screen.width + Drawing.WIDTH_OFFSET, screen.height)
	else
		Drawing.Screen.Width = screen.width - Drawing.WIDTH_OFFSET
	end
end

function Drawing.UnResizeScreen()
	wgui.resize(Drawing.Screen.Width, Drawing.Screen.Height)
end

function Drawing.paint()
	Drawing.setColor(Settings.Theme.Background)
	local rect = {x = Drawing.Screen.Width, y = Drawing.Screen.Height,
		width = Drawing.WIDTH_OFFSET, height = 20}
	d2d.fill_rectangle(rect, Drawing.curColor)
	Drawing.rect(Drawing.Screen.Width, Drawing.Screen.Height,
		Drawing.Screen.Width + Drawing.WIDTH_OFFSET, Drawing.Screen.Height - 20)
	for i = 1, table.getn(Buttons), 1 do
		if Buttons[i].type == ButtonType.button then
			if Buttons[i].name == "record ghost" then
				Drawing.drawButton(Buttons[i].box[1], Buttons[i].box[2], Buttons[i].box[3], Buttons[i].box[4], Buttons.getGhostButtonText(), Buttons[i].pressed())
			else
				Drawing.drawButton(Buttons[i].box[1], Buttons[i].box[2], Buttons[i].box[3], Buttons[i].box[4], Buttons[i].text, Buttons[i].pressed())
			end
		elseif Buttons[i].type == ButtonType.textArea then
			local value = Buttons[i].value()
			Drawing.drawTextArea(Buttons[i].box[1], Buttons[i].box[2], Buttons[i].box[3], Buttons[i].box[4], value and string.format("%0".. tostring(Buttons[i].inputSize) .."d", value) or string.rep('-', Buttons[i].inputSize), Buttons[i].enabled(), Buttons[i].editing())
		end
	end
	Drawing.drawAnalogStick(Drawing.Screen.Width + Drawing.WIDTH_OFFSET / 3, 210)
	Drawing.setColor(Settings.Theme.Text)
	Drawing.setFont("Arial", 10, 0)
	-- wgui.text(Drawing.Screen.Width + 149, 146, "Magnitude")
	Drawing.text(Drawing.Screen.Width + 149, 146, "Magnitude")
	Memory.Refresh()
	Drawing.drawAngles(Drawing.Screen.Width + 16, 280)
	Drawing.drawMiscData(Drawing.Screen.Width + 16, 310)
end

function Drawing.drawAngles(x, y)
	if Settings.ShowEffectiveAngles then
		Drawing.text(x, y, "Yaw (Facing): " .. Engine.getEffectiveAngle(Memory.Mario.FacingYaw))
		Drawing.text(x, y + 15, "Yaw (Intended): " .. Engine.getEffectiveAngle(Memory.Mario.IntendedYaw))
		Drawing.text(x + 132, y, "O: " ..  (Engine.getEffectiveAngle(Memory.Mario.FacingYaw) + 32768) % 65536)--Drawing.text(x, y + 30, "Opposite (Facing): " ..  (Engine.getEffectiveAngle(Memory.Mario.FacingYaw) + 32768) % 65536)
		Drawing.text(x + 132, y + 15, "O: " ..  (Engine.getEffectiveAngle(Memory.Mario.IntendedYaw) + 32768) % 65536)--Drawing.text(x, y + 45, "Opposite (Intended): " ..  (Engine.getEffectiveAngle(Memory.Mario.IntendedYaw) + 32768) % 65536)
	else
		Drawing.text(x, y, "Yaw (Facing): " .. Memory.Mario.FacingYaw)
		Drawing.text(x, y + 15, "Yaw (Intended): " .. Memory.Mario.IntendedYaw)
		Drawing.text(x + 132, y, "O: " ..  (Memory.Mario.FacingYaw + 32768) % 65536) --Drawing.text(x + 45, y, "Opposite (Facing): " ..  (Memory.Mario.FacingYaw + 32768) % 65536)
		Drawing.text(x + 132, y + 15, "O: " ..  (Memory.Mario.IntendedYaw + 32768) % 65536)--Drawing.text(x, y + 45, "Opposite (Intended): " ..  (Memory.Mario.IntendedYaw + 32768) % 65536)
	end
end

function Drawing.drawButton(x, y, width, length, text, pressed)
	-- wgui.setbrush(Settings.Theme.Button.Outline)
	-- wgui.setpen(Settings.Theme.Button.Outline)
	Drawing.setColor(Settings.Theme.Button.Outline)
	-- wgui.rect(x + 1, y + 1, x + width + 1, y + length + 1)
	Drawing.rect(x + 1, y + 1, x + width + 1, y + length + 1)
	if (pressed) then Drawing.setColor(Settings.Theme.Button.Pressed.Top) else Drawing.setColor(Settings.Theme.Button.Top) end
	--if (pressed) then wgui.setpen("#FF8888") else wgui.setpen("#888888") end
	Drawing.rect(x, y, x + width, y + length)
	if (pressed) then Drawing.setColor(Settings.Theme.Button.Pressed.Bottom) else Drawing.setColor(Settings.Theme.Button.Bottom) end
	-- if (pressed) then wgui.setpen(Settings.Theme.Button.Pressed.Bottom) else wgui.setpen(Settings.Theme.Button.Bottom) end
	Drawing.rect(x+1, y+1 + length/2, x-1 + width, y-1 + length)
	if (pressed) then
		Drawing.setColor(Settings.Theme.Button.InvertedText)
	elseif (Settings.Theme.Button.Text) then
		Drawing.setColor(Settings.Theme.Button.Text)
	else
		Drawing.setColor(Settings.Theme.Text)
	end
	Drawing.setFont("Arial", 10, 0)
	Drawing.text(x + width/1.5 - 4.5 * string.len(text), y + length/2 - 7.5, text)
end

function Drawing.drawTextArea(x, y, width, length, text, enabled, editing)
	Drawing.setColor(Settings.Theme.Text)
	Drawing.setFont("Courier", 16, 1)
	if (editing) then
		Drawing.setColor(Settings.Theme.InputField.Editing)
		-- if (Settings.Theme.InputField.EditingText) then wgui.setcolor(Settings.Theme.InputField.EditingText) end
	elseif (enabled) then
		Drawing.setColor(Settings.Theme.InputField.Enabled)
	else
		Drawing.setColor(Settings.Theme.InputField.Disabled)
	end
	Drawing.setColor(Settings.Theme.InputField.OutsideOutline)
	d2d.draw_rectangle({x = x + 1, y = y + 1, width = x + width + 1, height = y + length + 1}, Drawing.curColor, 1)
	Drawing.setColor(Settings.Theme.InputField.Outline)
	Drawing.line({x = x+2, y = y+2}, {x = x+2, y = y+length})
	Drawing.line({x = x+2, y = y+2}, {x = x+width, y = y+2})
	if (editing) then
		if (Settings.Theme.InputField.EditingText) then wgui.setcolor(Settings.Theme.InputField.EditingText) end
		selectedChar = Settings.Layout.TextArea.selectedChar
		Settings.Layout.TextArea.blinkTimer = (Settings.Layout.TextArea.blinkTimer + 1) % Settings.Layout.TextArea.blinkRate
		if (Settings.Layout.TextArea.blinkTimer == 0) then
			Settings.Layout.TextArea.showUnderscore = not Settings.Layout.TextArea.showUnderscore
		end
		if (Settings.Layout.TextArea.showUnderscore) then
			text = string.sub(text,1, selectedChar - 1) .. "_" .. string.sub(text, selectedChar + 1, string.len(text))
		end
	end
	Drawing.text(x + width/2 - 6.5 * string.len(text), y + length/2 - 8, text)
end

function Drawing.drawAnalogStick(x, y)
	Drawing.setColor(Settings.Theme.Joystick.Crosshair)
	d2d.draw_rectangle({x = x-64, y = y-64, width = x+64, height = y+64},
		Drawing.curColor, 1)
	Drawing.setColor(Settings.Theme.Joystick.Background)
	Drawing.rect(x-64,y-64,x+64,y+64)
	Drawing.setColor(Settings.Theme.Joystick.Circle)
	local float_color = d2d.color_to_float(Drawing.curColor)
	d2d.draw_ellipse({x = x-64, y = y-64, width = 128, height = 128}, Drawing.curColor, 1)
	if Settings.goalMag and Settings.goalMag < 127 then
		Drawing.setColor(Settings.Theme.Joystick.MagBoundary)
		local r = Settings.goalMag + 6
		d2d.fill_ellipse({x = x-r/2, y = y-r/2, width = x+r/2, height = y+r/2}, Drawing.curColor)
	end
	Drawing.line({x = x-64, y = y}, {x = x+64, y = y})
	Drawing.line({x = x, y = y-64}, {x = x, y = y+64})
	Drawing.setColor(Settings.Theme.Joystick.Stick)
	Drawing.line({x = x, y = y}, {x = x + Joypad.input.X/2, y = y - Joypad.input.Y/2})
	Drawing.setColor(Settings.Theme.Joystick.Dot)
	d2d.fill_ellipse({x = x-4 + Joypad.input.X/2, y = y-4 - Joypad.input.Y/2, width = 4 + Joypad.input.X/2,
		height = 4 - Joypad.input.Y/2}, Drawing.curColor)
	Drawing.setColor(Settings.Theme.Text)
	Drawing.setFont("Courier", 10, 0)
	local stick_y = Joypad.input.Y == 0 and "0" or -Joypad.input.Y
	Drawing.text(x + 90 - 2.5 * (string.len(stick_y)), y + 4, "y:" .. stick_y)
	Drawing.text(x + 90 - 2.5 * (string.len(Joypad.input.X)), y - 14, "x:" .. Joypad.input.X)
end

function Drawing.drawMiscData(x, y)
	speed = 0
	if Memory.Mario.HSpeed ~= 0 then
		speed = MoreMaths.DecodeDecToFloat(Memory.Mario.HSpeed)
	end
	Drawing.text(x, y, "H Spd: " .. MoreMaths.Round(speed, 5))

	Drawing.text(x, y + 45, "Spd Efficiency: " .. Engine.GetSpeedEfficiency() .. "%")

	speed = 0
	if Memory.Mario.VSpeed > 0 then
		speed = MoreMaths.Round(MoreMaths.DecodeDecToFloat(Memory.Mario.VSpeed), 6)
	end
	Drawing.text(x, y + 60, "Y Spd: " .. speed)

	Drawing.text(x, y + 15, "H Sliding Spd: " .. MoreMaths.Round(Engine.GetHSlidingSpeed(), 6))

	Drawing.text(x, y + 75, "Mario X: " .. MoreMaths.Round(MoreMaths.DecodeDecToFloat(Memory.Mario.X), 2))
	Drawing.text(x, y + 90, "Mario Y: " .. MoreMaths.Round(MoreMaths.DecodeDecToFloat(Memory.Mario.Y), 2))
	Drawing.text(x, y + 105, "Mario Z: " .. MoreMaths.Round(MoreMaths.DecodeDecToFloat(Memory.Mario.Z), 2))

	Drawing.text(x, y + 30, "XZ Movement: " .. MoreMaths.Round(Engine.GetDistMoved(), 6))

	Drawing.text(x, y + 120, "Action: " .. Engine.GetCurrentAction())

	Drawing.text(x + 172, y, "E: " .. Settings.Layout.Button.strain_button.arctanexp)
	Drawing.text(x + 132, y + 60, "R: " .. MoreMaths.Round(Settings.Layout.Button.strain_button.arctanr, 5))
	Drawing.text(x + 132, y + 75, "D: " .. MoreMaths.Round(Settings.Layout.Button.strain_button.arctand, 5))
	Drawing.text(x + 132, y + 90, "N: " .. MoreMaths.Round(Settings.Layout.Button.strain_button.arctann, 2))
	Drawing.text(x + 132, y + 105, "S: " .. MoreMaths.Round(Settings.Layout.Button.strain_button.arctanstart + 1, 2))

	Drawing.text(x, y + 136, "Read-write: ")
	if emu.isreadonly() then 
		readwritestatus = "disabled" 
		Drawing.setColor(Settings.Theme.Text)
	else
		readwritestatus = "enabled"
		Drawing.setColor(Settings.Theme.ReadWriteText)
	end
	Drawing.text(x + 68, y + 136, readwritestatus)

	Drawing.setColor(Settings.Theme.Text)
	Drawing.text(x, y + 220, "RNG Value: " .. Memory.RNGValue)
	Drawing.text(x, y + 235, "RNG Index: " .. get_index(Memory.RNGValue))

	distmoved = Engine.GetTotalDistMoved()
	if (Settings.Layout.Button.dist_button.enabled == false) then
		distmoved = Settings.Layout.Button.dist_button.dist_moved_save
	end
	Drawing.text(x, y + 280, "Moved Dist: " .. distmoved)
end

-- Emulating old functions

function Drawing.setColor(hexStr)
	Drawing.curColor = BreitbandGraphics.hex_to_color(hexStr)
end

function Drawing.setFont(fontName, fontSize, fontStyle)
	Drawing.curFont = fontName
	Drawing.curFontSize = fontSize
	Drawing.curFontStyle = fontStyle
end

function Drawing.text(x, y, text)
	-- are these values enough for most text?
	-- local float_color = d2d.color_to_float(Drawing.curColor)
	-- wgui.d2d_draw_text(x, y, x + 100, y + 100, float_color.r, float_color.g, float_color.b,
	-- 	1.0, text, Drawing.curFont, Drawing.curFontSize, Drawing.curFontStyle, 0, 0)
	d2d.draw_text({x=x, y=y, height=150, width=150}, 'start', 'start', Drawing.curColor,
		Drawing.curFontSize, Drawing.curFont, Drawing.curFontStyle, text)
end

function Drawing.rect(x, y, height, width)
	local float_color = d2d.color_to_float(Drawing.curColor)
	-- wgui.d2d_fill_rectangle(x, y, x2, y2, float_color.r, float_color.g, float_color.b, 1.0)
	d2d.fill_rectangle({x=x, y=y, height=height, width=width}, Drawing.curColor)
end

function Drawing.line(from, to)
	d2d.draw_line(from, to, Drawing.curColor, 1)
end