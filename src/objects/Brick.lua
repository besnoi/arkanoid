Brick=Class{}

function Brick:init(skin,color,x,y)
	self.skin=skin
	self.color=color
	self.x=x
	self.y=y
	self.destroyed=false
	self.psystem=love.graphics.newParticleSystem(gTextures['particle'], 64)
	self.psystem:setParticleLifetime(0, 0.5)
	self.psystem:setEmissionArea('ellipse',40,10)
	love.colors:setParticleColors(self.psystem,"white",1)	
	self.psystem:setLinearAcceleration(-5,0,15,10)
	return self
end

function Brick:update(dt)
	if not self.destroyed then
		self.psystem:update(dt)
	end
	if self.destroyed and self.animf==nil then
		self.animf=42+self.color
		self.timer=0
	end
	if self.animf and self.animf~=-1 then
		self.timer=self.timer+dt
		if self.timer>0.05 then
			self.animf=self.animf+7
			self.timer=0
		end
		if self.animf>77 then self.animf=-1 end
	end
end

function Brick:render()
	if not self.destroyed then
		-- print((self.skin-1)*7+self.color)
		love.graphics.draw(gTextures['main'],gSprites['brick'][(self.skin-1)*7+self.color],self.x,self.y)
		-- love.graphics.draw(gTextures['main'],gSprites['brick'][84],self.x,self.y)
		love.graphics.draw(self.psystem,self.x+23,self.y+13,0,0.9,0.9)
	else
		if self.animf and self.animf~=-1 then
			love.graphics.draw(gTextures['main'],gSprites['brick'][self.animf],self.x-3,self.y-3)
		end
	end
end

function Brick:hit()	
	local score=0
	if self.skin==12 then
		self.psystem:emit(20)
		return 0
	end
	if self.skin==1 or self.skin==2 then
		score=self.skin==1 and 1 or 3
		self.destroyed=true
	elseif self.skin~=6 then
		if BALL_TOUGHNESS~=3 then self.psystem:emit(40) end
		if BALL_TOUGHNESS==1 then
			score=1
			self.skin=self.skin+1
		elseif BALL_TOUGHNESS==2 then
			score=math.min(6,self.skin+2)-self.skin
			self.skin=math.min(6,self.skin+2)
		else
			score=4
			self.destroyed=true
		end
	else
		score=1
		self.destroyed=true
	end		
	if not self.destroyed then
		gSounds['brick-hit-1']:play()
	else
		gSounds['brick-hit-2']:play()
	end		
	return score
end