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
	BreitbandGraphics.renderers.d2d.fill_rectangle({
		x = Drawing.Screen.Width,
		y = 0,
		width = Drawing.WIDTH_OFFSET,
		height = Drawing.Screen.Height
	}, {
		r = 253,
		g = 253,
		b = 253
	})

	for i = 1, #Buttons, 1 do
		if Buttons[i].type == ButtonType.button then
			-- if Buttons[i].name == "record ghost" then
			-- 	Drawing.drawButton(Buttons[i].box[1], Buttons[i].box[2], Buttons[i].box[3], Buttons[i].box[4],
			-- 		Buttons.getGhostButtonText(), Buttons[i].pressed())
			-- else
			-- 	Drawing.drawButton(Buttons[i].box[1], Buttons[i].box[2], Buttons[i].box[3], Buttons[i].box[4],
			-- 		Buttons[i].text, Buttons[i].pressed())
			-- end
			if Mupen_lua_ugui.button({
					uid = i,
					is_enabled = Buttons[i].enabled(),
					rectangle = {
						x = Buttons[i].box[1],
						y = Buttons[i].box[2],
						width = Buttons[i].box[3],
						height = Buttons[i].box[4]
					},
					text = Buttons[i].name
				}) then
				Buttons[i].onclick(Buttons[i])
			end
		elseif Buttons[i].type == ButtonType.textArea then
			Mupen_lua_ugui.textbox({
				uid = i,
				is_enabled = Buttons[i].enabled(),
				rectangle = {
					x = Buttons[i].box[1],
					y = Buttons[i].box[2],
					width = Buttons[i].box[3],
					height = Buttons[i].box[4]
				},
				text = tostring(Buttons[i].value())
			})
		end
	end

	Mupen_lua_ugui.joystick({
		uid = 9999,
		is_enabled = true,
		rectangle = {
			x = Drawing.Screen.Width + 5,
			y = 145,
			width = 128,
			height = 128
		},
		position = {
			x = (Joypad.input.X - (-128)) / (127 - (-128)),
			y = (-Joypad.input.Y - (-127)) / (128 - (-127)),
		}
	})

	d2d.draw_ellipse(
		{
			x = (Drawing.Screen.Width + 5 + 64) - Settings.goalMag / 2,
			y = (145 + 64) - Settings.goalMag / 2,
			width = Settings.goalMag,
			height = Settings.goalMag,
		},
		BreitbandGraphics.colors.red,
		1
	)

	d2d.draw_text({
		x = Drawing.Screen.Width + 5,
		y = 145 + 128,
		width = 64,
		height = 15
	}, 'start', 'center', {}, BreitbandGraphics.colors.black, 11, "MS Sans Serif", "X " .. Joypad.input.X)


	d2d.draw_text({
		x = Drawing.Screen.Width + 5 + 64,
		y = 145 + 128,
		width = 64,
		height = 15
	}, 'start', 'center', {}, BreitbandGraphics.colors.black, 11, "MS Sans Serif", "Y " .. -Joypad.input.Y)
	Drawing.drawMiscData(Drawing.Screen.Width + 5, 310)
	Memory.Refresh()
end

function Drawing.drawAngles(x, y)
	if Settings.ShowEffectiveAngles then
		Drawing.text(x, y, "Yaw (Facing): " .. Engine.getEffectiveAngle(Memory.Mario.FacingYaw))
		Drawing.text(x, y + 15, "Yaw (Intended): " .. Engine.getEffectiveAngle(Memory.Mario.IntendedYaw))
		Drawing.text(x + 132, y, "O: " .. (Engine.getEffectiveAngle(Memory.Mario.FacingYaw) + 32768) % 65536)  --Drawing.text(x, y + 30, "Opposite (Facing): " ..  (Engine.getEffectiveAngle(Memory.Mario.FacingYaw) + 32768) % 65536)
		Drawing.text(x + 132, y + 15, "O: " .. (Engine.getEffectiveAngle(Memory.Mario.IntendedYaw) + 32768) % 65536) --Drawing.text(x, y + 45, "Opposite (Intended): " ..  (Engine.getEffectiveAngle(Memory.Mario.IntendedYaw) + 32768) % 65536)
	else
		Drawing.text(x, y, "Yaw (Facing): " .. Memory.Mario.FacingYaw)
		Drawing.text(x, y + 15, "Yaw (Intended): " .. Memory.Mario.IntendedYaw)
		Drawing.text(x + 132, y, "O: " .. (Memory.Mario.FacingYaw + 32768) % 65536)  --Drawing.text(x + 45, y, "Opposite (Facing): " ..  (Memory.Mario.FacingYaw + 32768) % 65536)
		Drawing.text(x + 132, y + 15, "O: " .. (Memory.Mario.IntendedYaw + 32768) % 65536) --Drawing.text(x, y + 45, "Opposite (Intended): " ..  (Memory.Mario.IntendedYaw + 32768) % 65536)
	end
end

function Drawing.drawAnalogStick(x, y)
	Mupen_lua_ugui.renderer = BreitbandGraphics.renderers.d2d
	Mupen_lua_ugui.stylers.windows_10.draw_joystick({
		rectangle = {
			x = x - 64,
			y = y - 64,
			width = 128,
			height = 128,
		},
		position = {
			x = (Joypad.input.X - (-128)) / (127 - (-128)),
			y = (-Joypad.input.Y - (-127)) / (128 - (-127)),
		}
	})
	d2d.draw_ellipse(
		{
			x = x - Settings.goalMag / 2,
			y = y - Settings.goalMag / 2,
			width = Settings.goalMag,
			height = Settings.goalMag,
		},
		BreitbandGraphics.colors.red,
		1
	)
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
	-- Drawing.curFont = fontName
	-- Drawing.curFontSize = fontSize
	-- Drawing.curFontStyle = fontStyle
end

function Drawing.text(x, y, text)
	local size = d2d.get_text_size(text, 11, "MS Sans Serif")
	d2d.draw_text({
		x = x,
		y = y,
		width = 999999999999, -- emulate old behaviour (nowrap)
		height = size.height
	}, "start", "center", {}, BreitbandGraphics.colors.black, 11, "MS Sans Serif", text)
end

function Drawing.rect(x, y, height, width)
	local float_color = d2d.color_to_float(Drawing.curColor)
	-- wgui.d2d_fill_rectangle(x, y, x2, y2, float_color.r, float_color.g, float_color.b, 1.0)
	-- d2d.fill_rectangle({ x = x, y = y, height = height, width = width }, Drawing.curColor)
end

function Drawing.line(from, to)
	-- d2d.draw_line(from, to, Drawing.curColor, 1)
end
