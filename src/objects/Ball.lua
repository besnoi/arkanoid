Ball=Class{}

function Ball:init(skinid)
	self:setSkin(skinid)
	local speed={-1,1}
	-- self.dx=speed[math.random(2)]*BALL_SPEED
	self.dy=-220-BALL_SPEED
	self.dx=0
	self.x=(VIRTUAL_WIDTH-self.width)/2
	self.y=VIRTUAL_HEIGHT-self.height-30-5
	self.remove=false
	return self
end


function Ball:update(dt)
	self.x=self.x+self.dx*dt
	self.y=self.y+self.dy*dt
	if self.x<=28 then
		self.x=29
		self.dx=-self.dx
		gSounds['wall-hit']:play()
	elseif self.x+self.width>=VIRTUAL_WIDTH-28 then
		self.x=VIRTUAL_WIDTH-28-self.width-1
		self.dx=-self.dx
		gSounds['wall-hit']:play()
	elseif self.y<=60+28+10 then
		self.y=60+28+10
		self.dy=-self.dy
		gSounds['wall-hit']:play()
	end
	self.x=math.max(0,self.x)
	self.y=math.max(0,self.y)
	self.x=math.min(VIRTUAL_WIDTH-self.width,self.x)
end

function Ball:render()
	love.graphics.draw(gTextures['main'],gSprites['ball'][self.skin],self.x,self.y)
end

function Ball:collides(target,...)
	local TARGET_WIDTH,TARGET_HEIGHT=target.width,target.height
	if not TARGET_WIDTH or not TARGET_HEIGHT then
		TARGET_WIDTH,TARGET_HEIGHT=...
	end
	if self.x+self.width<target.x or self.x>target.x+TARGET_WIDTH or self.y+self.height<target.y or self.y>target.y+TARGET_HEIGHT then
		return false
	end
	return true
end

function Ball:setSkin(skinid)
	self.skin=skinid
	if skinid>8 then
		self.width,self.height=32,32
	else
		self.width,self.height=16,16
	end
	--[[
		FootBall:
			speciality of football it that it is huge and it is average in both toughness and speed
			limitation of  football is that it's toughness is no better than galactic ball and its speed is no better than an basketball
		Galactic Ball:
			speciality is that is is very good looking and supports the aesthetic of the game (space). Okay so its speciality is that it is huge and also very tough (it can hit those hard blocks with one shot, no kidding)
			limitation of galactic ball is that it can be slow but you can also see this as your advantage
		BasketBall:
			speciality of basketball it is huge at the same time very fast
			limitation of  basketball is that unlike galactic ball it's toughness is no better than an ordinary ball  and sometimes its speed can be its limitation cause it can be difficult to move at the pace of basketball for too long
	]]
	
	if skinid==11 then
		BALL_SPEED=100
		BALL_TOUGHNESS=1
	elseif skinid==10 then
		BALL_SPEED=100
		BALL_TOUGHNESS=3
	elseif skinid==9 then
		BALL_SPEED=50
		BALL_TOUGHNESS=2
	else
		BALL_SPEED=0
		BALL_TOUGHNESS=1
	end

end
