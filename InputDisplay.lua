-- Input Direction Lua "Encoding Version"
-- Authors: MKDasher, Xander, ShadoXFM
-- Hacker: Eddio0141
-- Special thanks to Pannenkoek2012 and Peter Fedak for angle calculation support.
-- Also thanks to MKDasher to making the code very clean
-- Other contributors:
--	Madghostek

PATH = debug.getinfo(1).source:sub(2):match("(.*\\)") .. "\\InputDisplay\\"

dofile (PATH .. "Drawing.lua")
Drawing.resizeScreen()

dofile (PATH .. "Memory.lua")
dofile (PATH .. "Settings.lua")
dofile (PATH .. "Joypad.lua")
dofile (PATH .. "Angles.lua")
dofile (PATH .. "Engine.lua")
dofile (PATH .. "Buttons.lua")
dofile (PATH .. "Input.lua")
dofile (PATH .. "Program.lua")
dofile (PATH .. "MoreMaths.lua")
dofile (PATH .. "Actions.lua")
dofile (PATH .. "Timer.lua")
-- dofile (PATH .. "TimerJP.lua")
-- dofile (PATH .. "Task Timers\\Task 2 Timer.lua")
-- dofile (PATH .. "Task Timers\\Task 8 Timer.lua")

Program.initFrame()
Memory.UpdatePrevPos()
function main()
	Program.initFrame()
	Program.main()
	Joypad.send()
end

function drawing()
	Drawing.paint()
end

function update()
	if Input.update() then
		Drawing.paint()
	end
end

function atstop()
    Drawing.UnResizeScreen()
end

emu.atinput(main)
emu.atvi(drawing,false)
emu.atinterval(update, false)
emu.atstop(atstop)