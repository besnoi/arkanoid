GameOverState=Class{__includes=BaseState}

local function checkHighScore(score,highscores)
	if #highscores<10 and score>0 then return true end
	for _,tbl in ipairs(highscores) do
		if score>tonumber(tbl[2]) then
			return true
		end
	end
	return false
end


function GameOverState:enter(params)
	self.score=params.score
	--get the top ten (or less) highscores
	local allscores
	self.highscores=table.subset(table.isort(csvfile:readFile('highscores.lst',':'),function (a,b) return tonumber(a[2])>tonumber(b[2]) end),1,10)
	self.highscoreanim=Anima:init()
	self.highscoreanim:startNewAnimation('opacity',-0.7)
	self.ishighscore=checkHighScore(self.score,self.highscores)
	if self.ishighscore then 
		gSounds['win']:play()
	else
		gSounds['lose']:play()		
	end
end


function GameOverState:update()
	self.highscoreanim:updateF()	
	if (love.keyboard.lastKeyPressed=='return' or love.keyboard.lastKeyPressed=='enter') and not gSounds.win:isPlaying() then
		gSounds.blip:play()
		if self.ishighscore then
			gStateMachine:change('enter-name',{
				score=self.score
			})
		else
			gStateMachine:change('main-menu')
		end
	end
end
function GameOverState:render()
	drawBackground('background')
	love.colors:setColor('cyan')
	drawBorderNeon()	
	renderHUD(0,nil,self.score)
	love.graphics.setFont(gFonts.huge)	
	love.graphics.printf("Game Over!!!",0,VIRTUAL_HEIGHT/2-30,VIRTUAL_WIDTH,'center')
	love.graphics.setFont(gFonts.medium)
	love.graphics.printf("Your Score: "..self.score,0,VIRTUAL_HEIGHT/2+50,VIRTUAL_WIDTH,'center')	
	love.graphics.setFont(gFonts.idle)		
	
	if self.ishighscore then  
		love.graphics.setFont(gFonts.normal)		
		love.colors:setColor("orangered",0.5+math.abs(self.highscoreanim.op))
		love.graphics.draw(gTextures['main'],gSprites['hud'][1],280,VIRTUAL_HEIGHT/2-95,0,1,0.6)
		for i=1,5 do
			love.graphics.draw(gTextures['main'],gSprites['hud'][2],284+i*32,VIRTUAL_HEIGHT/2-95,0,1,0.6)
		end	
		love.graphics.draw(gTextures['main'],gSprites['hud'][3],284+6*32,VIRTUAL_HEIGHT/2-95,0,1,0.6)
		love.colors:setColor("white")	
		love.graphics.printf("New HighScore!!!",0,VIRTUAL_HEIGHT/2-82,VIRTUAL_WIDTH,'center')
	end
	self.highscoreanim:printf("Hit Enter to Continue!",0,VIRTUAL_HEIGHT/2+252,VIRTUAL_WIDTH,'center')
	
end

