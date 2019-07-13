PaddleSelectState=Class{__includes=BaseState}

local anima={
	paddle=Anima:init(),
	left=Anima:init(),
	right=Anima:init(),
	text=Anima:init()
}


local rightpressed,leftpressed=0,0
local frametimer,presstimer=0,0

function PaddleSelectState:init()
	self.paddle=Paddle(1,4)
	self.paddle.y=VIRTUAL_HEIGHT/2-self.paddle.height/2
	anima.paddle:newAnimation("move",0,5)
	anima.paddle:newAnimation("scale",0.35,0.35)
	--so repeat the movement but donot repeat the scaling behaviour i.e. scale only once but move forever
	anima.paddle:setRepeatScale(false,false)
	anima.paddle:animationStart()
	anima.text:newAnimation("opacity",-1)
	anima.text:animationStart()
	self.beginframe=114
	self.frame=114
	self.endframe=14
	self.skipframe=false
	self.framedir=1
	self.background=love.graphics.newImage("assets/images/paddle-select/frames/frame-"..self.frame..".jpg")
end

function PaddleSelectState:update(dt)
	frametimer=frametimer+dt
	presstimer=presstimer+dt
	--the fps speed would be different depending on whether or not we are skipping frames (fast if yes normal if no)
	if not DEBUG_GAME and (self.skipframe and frametimer>0.02 or frametimer>0.2) then		
		if self.skipframe and (self.frame==self.beginframe or self.frame==self.endframe) then
			self.skipframe=false
		end

		if not self.skipframe then
			if self.frame==self.endframe  then
				self.framedir=-1
			elseif self.frame==self.beginframe then
				self.framedir=1
			end
		end
		self.frame=self.frame+self.framedir
		if self.frame>119 then
			self.frame=0
		elseif self.frame<0 then
			self.frame=119
		end
		self.background=love.graphics.newImage("assets/images/paddle-select/frames/frame-"..self.frame..".jpg")
		frametimer=0		
	end
	if presstimer>0.4 then
		rightpressed,leftpressed=0,0
		presstimer=0
	end
	anima.paddle:updateF(0.1,0.1,0,0.028,0.028)
	anima.left:update(0.1,0.7)
	anima.right:update(0.1,0.7)
	if love.keyboard.lastKeyPressed=='right' and not self.skipframe then
		if self.paddle.color==7 then
			gSounds['no-select']:play()
		else
			--it is hardcoded because there is no pattern in the frames like 21,18, 17 and then some another seemingly random no
			if not DEBUG_GAME then
				self.skipframe=true		
				self.framedir=-1
				if self.beginframe==114 then self.frame,self.beginframe=114,84 self.endframe=100
				elseif self.beginframe==28 then self.frame,self.beginframe=28,114 self.endframe=14
				elseif self.beginframe==59 then self.frame,self.beginframe=59,28 self.endframe=45
				elseif self.beginframe==84 then self.frame,self.beginframe=84,59 self.endframe=70
				end				
			end
			rightpressed=1		
			gSounds['blip']:play()			
		end
		anima.paddle:resetAnimation()
		anima.right:newAnimation('move',0,5)
		anima.right:animationStart()
		self.paddle.color=math.min(7,self.paddle.color+1)
	elseif love.keyboard.lastKeyPressed=='left'  and not self.skipframe then
		if self.paddle.color==1 then
			gSounds['no-select']:play()
		else
			leftpressed=1		
			if not DEBUG_GAME then
				self.framedir=1
				self.skipframe=true
				if self.beginframe==114 then self.frame,self.beginframe=14,28 self.endframe=45 
				elseif self.beginframe==28 then self.frame,self.beginframe=45,59 self.endframe=70
				elseif self.beginframe==59 then self.frame,self.beginframe=70,84 self.endframe=100
				elseif self.beginframe==84 then self.frame,self.beginframe=100,114 self.endframe=14
				end
			end

			gSounds['blip']:play()
		end
		anima.paddle:resetAnimation()
		anima.left:newAnimation('move',0,5)
		anima.left:animationStart()		
		self.paddle.color=math.max(1,self.paddle.color-1)
	elseif love.keyboard.lastKeyPressed=='return' or love.keyboard.lastKeyPressed=='enter' then
		gStateMachine:change('serve',{
			paddle=Paddle:init(self.paddle.color,2),
			ball=Ball(math.random(1)),
			bricks=LevelMaker.generateLevel(10),
			level=10,
			score=0,
			lives=3,
			begin=true
		})
	elseif love.keyboard.lastKeyPressed=='escape' or love.keyboard.lastKeyPressed=='backspace' then
		gStateMachine:change('main-menu')
	end
	anima.text:updateF()
end

function PaddleSelectState:render()
	love.graphics.draw(self.background)
	anima.paddle:renderQuad(gTextures['main'],gSprites['paddle'][self.paddle.size+(self.paddle.color-1)*4],self.paddle.x+self.paddle.width/2,self.paddle.y+self.paddle.height/2,0,0.8,0.8,false,self.paddle.width/2,self.paddle.height/2)
	if self.paddle.color~=1 or leftpressed==1 then
		anima.left:render(gTextures['left'][leftpressed],50,VIRTUAL_HEIGHT/2-30)
	end
	if self.paddle.color~=7 or rightpressed==1 then
		anima.right:render(gTextures['right'][rightpressed],VIRTUAL_WIDTH-104,VIRTUAL_HEIGHT/2-30)	
	end
	love.graphics.setFont(gFonts['score-font'])	
	love.colors:setOpacity(0.45)
	love.graphics.line(35,85,440,85)
	love.colors:setOpacity(1)	
	love.graphics.print("Select your Paddle",35,45)
	love.graphics.setFont(gFonts.medium)
	anima.text:print("Hit Enter to Continue",VIRTUAL_WIDTH/2-135,VIRTUAL_HEIGHT/2+260)
end
