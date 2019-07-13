Powerup=Class{}

function Powerup:init(id,x,y)
	self.id=id
	self.x=x
	self.y=y
	self.width,self.height=32,32
	self.vy=0
end

function Powerup:hit()
	self.vy=100
end

function Powerup:update(dt)
	self.y=self.y+self.vy*dt
end

function Powerup:render()
	love.graphics.draw(gTextures['main'],gSprites['powerup'][self.id],self.x,self.y)
end