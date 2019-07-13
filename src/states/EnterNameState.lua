EnterNameState=Class{__includes=BaseState}
local caps,debug=false,false
local timer,dir=0,1

function EnterNameState:enter(params)
	self.score=params.score

	self.name=""
	self.frozen=true
	self.enteranim=Anima:init()
	self.enteranim:newAnimation("opacity",-1)
	self.enteranim:animationStart()
	self.frame=1
	self.background=love.graphics.newImage("assets/images/highscores/frames/"..self.frame..".jpg")
end

function EnterNameState:update(dt)
	timer=timer+dt
	if timer>0.1 and not debug then
		self.frame=self.frame+dir
		if self.frame>49 then dir=-1 end
		if self.frame<5 then dir=1 end
		self.background=love.graphics.newImage("assets/images/highscores/frames/"..self.frame..".jpg")
		timer=0
	end
	self.enteranim:updateO(0.05,true)
	if love.keyboard.isAlpha() or love.keyboard.isDigit() then self.frozen=false end
	self.name=love.keyboard.readText(self.name,8)
	if (love.keyboard.lastKeyPressed=='return' or love.keyboard.lastKeyPressed=='enter') and not self.frozen then
		csvfile:appendFile('highscores.lst',{{self.name,self.score}},":",2)
		gStateMachine:change('highscore',{
			frame=self.frame
		})
	end
end

function EnterNameState:render()
	love.graphics.draw(self.background)
	love.graphics.setFont(gFonts['score-font'])
	love.colors:setColor("white",0.6)
	
	love.graphics.draw(gTextures['main'],gSprites['hud'][1],200,VIRTUAL_HEIGHT/2-285)	
	for i=1,10 do
		love.graphics.draw(gTextures['main'],gSprites['hud'][2],204+i*32,VIRTUAL_HEIGHT/2-285)	
	end	
	love.graphics.draw(gTextures['main'],gSprites['hud'][3],204+11*32,VIRTUAL_HEIGHT/2-285)
	love.colors:setColor("white")
	love.graphics.printf("Your Score : "..self.score,0,VIRTUAL_HEIGHT/2-268,VIRTUAL_WIDTH,'center')
	love.graphics.setFont(gFonts.medium)
	if not self.frozen then self.enteranim:print("Hit Enter to Continue",VIRTUAL_WIDTH/2-130,VIRTUAL_HEIGHT/2+240)
	else self.enteranim:print("Enter your Name",VIRTUAL_WIDTH/2-110,VIRTUAL_HEIGHT/2+240) end
	love.colors:setColor("white",0.7)
	love.graphics.draw(gTextures['win'],400,VIRTUAL_HEIGHT/2-85,0,1.4+(self.frozen and 1 or self.name:len()/10),1.4,gTextures['win']:getWidth()/2)
	love.colors:reset()
	love.graphics.setFont(gFonts.huge)
	if self.frozen then
		love.graphics.printf("YOUR NAME",0,VIRTUAL_HEIGHT/2-25,VIRTUAL_WIDTH,'center')
	else	
		love.graphics.printf(self.name,0,VIRTUAL_HEIGHT/2-25,VIRTUAL_WIDTH,'center')
	end
end