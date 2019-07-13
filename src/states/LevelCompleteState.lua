LevelCompleteState=Class{__includes=BaseState}
function LevelCompleteState:enter(params)
	self.paddle=params.paddle
	self.level=params.level
	self.lives=params.lives
	self.score=params.score
	self.explodeanim={
		['particle']=love.graphics.newParticleSystem(gTextures['particle2'],20),
		['x']=params.x,
		['y']=params.y
	}
	self.explodeanim.particle:setEmissionArea('ellipse', 10,10)
	love.colors:setParticleColors(self.explodeanim.particle,"white",1,"white",1,"white",0)
	self.explodeanim.particle:setParticleLifetime(0, 0.5)
	self.explodeanim.particle:setLinearAcceleration(-10,-10,10,10)
	self.explodeanim.particle:emit(8)
end
function LevelCompleteState:update(dt)
	self.explodeanim.particle:update(dt)
	if love.keyboard.lastKeyPressed=='return' or love.keyboard.lastKeyPressed=='enter' then
		gStateMachine:change('serve',{
			level=self.level+1,
			paddle=self.paddle,
			bricks=LevelMaker.generateLevel(self.level+1),
			lives=self.lives,
			score=self.score,
			begin=true
		})
	end
end
function LevelCompleteState:render()
	drawBackground('background')	
	love.colors:setColor('cyan')
	drawBorderNeon()
	renderHUD(self.lives,self.paddle.color,self.score)
	self.paddle:render()
	love.graphics.setFont(gFonts.large)	
	love.graphics.printf("Level Complete!!!",0,VIRTUAL_HEIGHT/2-20,VIRTUAL_WIDTH,'center')
	love.graphics.draw(self.explodeanim.particle,self.explodeanim.x,self.explodeanim.y)
end