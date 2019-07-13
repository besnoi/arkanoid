ServeState=Class{__includes=BaseState}

function ServeState:enter(params)
	self.bricks=params.bricks
	self.paddle=params.paddle
	self.paddle:setSize(2)
	self.ball=Ball(math.random(8))
	self.lives=params.lives
	self.level=params.level	
	self.score=params.score
	self.begin=params.begin
	self.rhpoints=params.rhpoints or 3	
	self.hudbox,self.levelanim=Anima:init(),Anima:init()
	self.hudbox:newAnimation("scale",0,0.4)
	self.hudbox:animationStart()
	self.levelanim:newAnimation("move",0,30)	
	self.levelanim:animationStart()
	self.enterpressed=false

	--it is very important that we donot waste resources on these stupid particle effects especially when we cant see them 
	--so check if we are doing a particle animation and accordingly react to that

	self.particleanimation=params.particle
	if self.particleanimation then
		self.explodeanim={
			['particle']=love.graphics.newParticleSystem(gTextures['particle2'],params.particle.buffer or 20),
			['x']=params.particle.x,
			['y']=params.particle.y,
		}
		if not self.explodeanim.x or not self.explodeanim.y then self.particleanimation=nil end
		self.explodeanim.particle:setEmissionArea('ellipse', params.particle.spreadx or 10,params.particle.spready or 10)
		love.colors:setParticleColors(self.explodeanim.particle,"white",1,"white",1,"white",0)
		self.explodeanim.particle:setParticleLifetime(0, params.particle.maxlt or 0.5)
		self.explodeanim.particle:setLinearAcceleration(-10,-10,10,10)
		self.explodeanim.particle:emit(params.particle.buffer or 8)
		self.timer=0
	end
end

function ServeState:update(dt)
	if self.particleanimation then 
		self.timer=self.timer+dt
		if self.timer>self.explodeanim.particle:getParticleLifetime()+0.5 then
			self.particleanimation=nil
		else
			self.explodeanim.particle:update(dt)
		end
	end
	self.levelanim:updateM(0,self.enterpressed and 1 or 0.8)
	self.hudbox:updateS()
	self.paddle:update(dt)
	if not self.enterpressed then self.ball.x=self.paddle.x+self.paddle.width/2-self.ball.width/2 end
	if (love.keyboard.lastKeyPressed=='return' or love.keyboard.lastKeyPressed=='enter') and  self.hudbox:animationOver() and self.levelanim:animationOver() and not self.enterpressed then
		self.enterpressed=true
		self.levelanim:animationMark()
		self.hudbox:animationMark()		
		self.levelanim:newAnimation('move',0,-50,true)
		self.levelanim:animationStart()
		self.hudbox:newAnimation("scale",0,-0.6,true)
		self.hudbox:animationStart()
	end
	if self.enterpressed then self.ball:update(dt) end

	--note that the collision check for brikcs in ServeState is little different than that of PlayState
	for i,brick in ipairs(self.bricks) do
		if self.ball:collides(brick,BRICK_WIDTH,BRICK_HEIGHT) and not brick.destroyed then
			if self.ball.x+self.ball.width>brick.x+BRICK_WIDTH and self.ball.dx<0 then
				self.ball.dx=-self.ball.dx
				self.ball.x=brick.x+BRICK_WIDTH
			elseif self.ball.x<brick.x and self.ball.dx>0 then
				self.ball.dx=-self.ball.dx				
				self.ball.x=brick.x-self.ball.width
			elseif self.ball.y<brick.y then
				self.ball.y=brick.y-self.ball.height
				self.ball.dy=-self.ball.dy
			else
				self.ball.y=brick.y+BRICK_HEIGHT
				self.ball.dy=-self.ball.dy
			end
			self.ball.dy=self.ball.dy*1.02
			self.score=self.score+(brick:hit())
			break
		end
		brick:update(dt)
	end


	if self.enterpressed and self.levelanim:animationOver() and self.hudbox:animationOver() then
		gStateMachine:change('play',{
			paddle=self.paddle,
			bricks=self.bricks,
			level=self.level,
			ball=self.ball,
			lives=self.lives,
			score=self.score,
			rhpoints=self.rhpoints
		})
	end
end

function ServeState:render()
	drawBackground('background')
	love.colors:setColor('cyan')
	drawBorderNeon()	
	renderHUD(self.lives,self.paddle.color,self.score)
	-- renderLevel(5)

	love.colors:setColor('azure',0.9)
    --1.3 to 1 and 1.53 to 1.23
	self.hudbox:render(gTextures['hud'],321,-6,0,1,0.23)
	self.levelanim:print("Level: "..self.level,(self.level > 9 and 348 or 352),-10)
	

	love.colors:setColor('skyblue')
	for i in ipairs(self.bricks) do self.bricks[i]:render() end
	love.colors:reset()
	love.graphics.setFont(gFonts.large)
	if self.begin and not self.enterpressed then
		love.graphics.printf("Press Enter to Serve!",0,VIRTUAL_HEIGHT/2-20,VIRTUAL_WIDTH,'center')
	end
	self.paddle:render()
	self.ball:render()
	love.colors:reset()
	if self.particleanimation then
		love.graphics.draw(self.explodeanim.particle,self.explodeanim.x,self.explodeanim.y)
	end
	
end