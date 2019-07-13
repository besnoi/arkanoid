--[[
	XKF LIBRARY by Neer: (modified for this game)
	Extra Keyboard Functionality: adds extra functionality to love.keyboard like readText
	To use this library to must define love.keyboard.lastKeyPressed on YOUR OWN
	just add love.keyboard.lastKeyPressed=nil at the END of love.update and love.keyboard.lastKeyPressed=key
	at the BEGINNING of love.keypressed(key) and everything should be fine from then
]]

--assume that capslock is turned on (very stupid assumption)
--in the upcoming version of xkf, I (sort of) promise that i would fix this issue
--i may fail to do so or i may lose my interest in love2d so i request the reader to take this step
--and save humanity by implementing a lua function which would return whether or not is caps lock turned on or off
--and from there this library would take over
local caps=true

--checks if letter keys were pressed in the last frame
function love.keyboard.isAlpha()
	return love.keyboard.lastKeyPressed~=nil and love.keyboard.lastKeyPressed:len()==1 and love.keyboard.lastKeyPressed:byte()>=97 and love.keyboard.lastKeyPressed:byte()<=122
end

--checks if number keys were pressed in the last frame
function love.keyboard.isDigit()
	return love.keyboard.lastKeyPressed~=nil and love.keyboard.lastKeyPressed:len()==1 and love.keyboard.lastKeyPressed:byte()>=48 and love.keyboard.lastKeyPressed:byte()<=57
end

--one thing you can do is to not have  any functionality for different case later i.e. remove this capslock logic
function love.keyboard.readText(str,maxlen)
	if love.keyboard.lastKeyPressed=='capslock' then
		caps=not caps and true or false
	elseif love.keyboard.isAlpha() then
		str=str..string.char(love.keyboard.lastKeyPressed:byte()-(caps and 32 or 0))
		if str:len()>maxlen then 
			gSounds['buzz']:play()
			str=str:sub(1,maxlen)
		else
			gSounds['key']:play()		
		end
	elseif love.keyboard.isDigit() then
		str=str..tostring(love.keyboard.lastKeyPressed:byte()):char()
		if str:len()>maxlen then 
			gSounds['buzz']:play()
			str=str:sub(1,maxlen)
		else
			gSounds['key']:play()					
		end
	elseif love.keyboard.lastKeyPressed=='space' then
		str=str..string.char(32)
		if str:len()>maxlen then 
			gSounds['buzz']:play()
			str=str:sub(1,maxlen)
		else
			gSounds['key']:play()		
		end
	elseif love.keyboard.lastKeyPressed=='backspace' then
		gSounds['key']:play()
		if str:len()-1==0 then
			str=""
		else
			str=str:sub(1,str:len()-1)
		end
	end
	return str
end