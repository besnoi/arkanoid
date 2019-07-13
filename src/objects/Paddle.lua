Paddle=Class{}
function Paddle:init(color,size,x,y)
	assert(size>0 and size<5,"Paddle must be less than 5")
	assert(color>0 and color<8,"Color must be less than 8")
	color=color or 1
	size=size or 2
	self.color=color
	self.ai=false
	self:setSize(size)
	self.dir=0
	self.height=30
	if not x then
		self:resetPosition()
	else
		self.x,self.y=x,y
	end
	return self
end


function Paddle:resetPosition()
	self.x=(VIRTUAL_WIDTH-self.width)/2
	self.y=VIRTUAL_HEIGHT-self.height-3
end


function Paddle:update(dt,ballx)
	if not self.ai then
		if love.keyboard.isDown('left') or love.keyboard.isDown('a') then
			self.dir=-1
		elseif love.keyboard.isDown('right') or love.keyboard.isDown('d') then
			self.dir=1
		else
			self.dir=0
		end
		self.x=self.x+self.dir*PADDLE_SPEED*dt
		
	else
		if ballx then
			self.x=ballx
		else
			self:resetPosition()
		end
	end
	self.x=math.max(28,self.x)
	self.x=math.min(VIRTUAL_WIDTH-self.width-28,self.x)
	
end

function Paddle:render()
	love.graphics.draw(gTextures['main'],gSprites['paddle'][self.size+(self.color-1)*4],self.x,self.y)
end

function Paddle:setSize(size)
	assert(size<=4,"Paddle's size must be less than or equal to 4")
	self.size=size
	if size==1 then
		self.width=58
	elseif size==2 then
		self.width=90
	elseif size==3 then
		self.width=128
	else
		self.width=176
	end
end


function Paddle:collides(obj)
	if self.x+self.width<obj.x or self.x>obj.x+obj.width or self.y+self.height<obj.y or self.y>obj.y+obj.height then
		return false
	end
	return true
end