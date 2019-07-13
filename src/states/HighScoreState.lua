HighScoreState=Class{__includes=BaseState}

local counter
local timer,dir=0,1

local anima={
	left=Anima:init(),
	right=Anima:init()
}

function HighScoreState:enter(params)
	self.frame=params and params.frame or 1
	--this frame thing is so that when we transition from EnterNameState to HighScoreState it doesn't look bad
	self.background=love.graphics.newImage("assets/images/highscores/frames/"..self.frame..".jpg")	
	self.allscores=csvfile:readFile('highscores.lst',':')
	--sort in descending order (note we need to do this tonumber thing otherwise it would compare them as strings which is stupid)
	table.sort(self.allscores,function (a,b) return tonumber(a[2])>tonumber(b[2]) end)
	--display 5 records per page	
	self.highscores,self.totalpages=table.divide(self.allscores,5)
	self.currentpage=1	
	anima.left:newAnimation('move',5)
	anima.right:newAnimation('move',5)
	anima.left:animationStart()
	anima.right:animationStart()
end

function HighScoreState:update(dt)
	timer=timer+dt
	if timer>0.1 then
		self.frame=self.frame+dir
		if self.frame>49 then dir=-1 end
		if self.frame<5 then dir=1 end
		self.background=love.graphics.newImage("assets/images/highscores/frames/"..self.frame..".jpg")
		timer=0
	end

	anima.left:updateF(0.6,0.6)
	anima.right:updateF(0.6,0.6)
	if love.keyboard.lastKeyPressed=='backspace' or love.keyboard.lastKeyPressed=='escape' then
		gSounds.blip:play()
		gStateMachine:change('main-menu')
	elseif love.keyboard.lastKeyPressed=='right' then
		gSounds.select:play()		
		self.currentpage=math.min(self.totalpages,self.currentpage+1)
	elseif love.keyboard.lastKeyPressed=='left' then
		gSounds.select:play()		
		
		self.currentpage=math.max(1,self.currentpage-1)
	end
end

function HighScoreState:render()
	love.graphics.draw(self.background)
	love.colors:setOpacity(0.7)	
	love.graphics.draw(gTextures['hback'],125,60)
	love.graphics.setFont(gFonts['normal'])	
	love.graphics.print("< Press Esc to return",10,580)
	love.colors:reset()		
	if self.currentpage~=1 then
		anima.left:render(gTextures['left'][0],30,300)	
	end
	if self.currentpage~=self.totalpages then
		anima.right:render(gTextures['right'][0],716,300)	
	end
	if not self.allscores then
		love.graphics.setFont(gFonts['medium'])		
		love.graphics.print("No records Found!",280,320)
	else
		love.graphics.printf(string.format("(%d of %d pages)",1,self.totalpages),360,130,200,'left')		
		love.graphics.setFont(gFonts['medium'])			
		counter=1	
		for i,record in ipairs(self.highscores[self.currentpage]) do
			--why aren't we doing i*70 instead of counter*70? - because i!=counter it may seem so but it only holds true in the first page
			love.graphics.printf(5*(self.currentpage-1)+counter..'.',155,130+counter*70,60,'left')
			love.graphics.printf(record[1],215,130+counter*70,340,'left')
			love.graphics.printf(record[2],575,130+counter*70,70,'right')
			counter=counter+1
		end
	end
	
	
	love.colors:setOpacity(1)	
	love.graphics.setFont(gFonts['large'])	
	
	love.graphics.print("HighScores",280,90)
	
end