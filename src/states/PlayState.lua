PlayState=Class{__includes=BaseState}

local allbrickscleared,lastbrick
local keytimer=0
function PlayState:enter(params)
	self.bricks=params.bricks
	self.paddle=params.paddle
	self.balls={params.ball}
	self.level=params.level
	self.lives=params.lives
	self.score=params.score
	--the reason why we are not having a powerup table is because any two powerups (doesn't matter if they are of the same type/id) will never share the same stage because of their rivalry (just kidding - this is just a tradeoff cause we want particle effects for the upgrades when they disappear and when we have too many of them fps can be really down)
	self.powerup=nil
	--drop health powerup when a certain amount of points have been achieved (note- this is total points so we will add total score to it every time a health upgrade is dropped)
	self.rhpoints=params.rhpoints

	self.haskey=false
end

function PlayState:update(dt)
	keytimer=keytimer+dt
	if keytimer>10 then
		self.haskey=false
		keytimer=0
	end
	if love.keyboard.lastKeyPressed=='a' then
		self.paddle.ai=self.paddle.ai==false
	end
	self.paddle:update(dt,self.balls[1].x)
	allbrickscleared=true
	for i=1,#self.balls do
		self.balls[i]:update(dt)
		for _,brick in ipairs(self.bricks) do
			if not brick.destroyed then allbrickscleared=false end		
			if self.balls[i]:collides(brick,BRICK_WIDTH,BRICK_HEIGHT) and not brick.destroyed then
				if self.balls[i].x+self.balls[i].width>brick.x+BRICK_WIDTH and self.balls[i].dx<0 then
					self.balls[i].dx=-self.balls[i].dx
					self.balls[i].x=brick.x+BRICK_WIDTH
				elseif self.balls[i].x<brick.x and self.balls[i].dx>0 then
					self.balls[i].dx=-self.balls[i].dx				
					self.balls[i].x=brick.x-self.balls[i].width
				elseif self.balls[i].y<brick.y then
					self.balls[i].y=brick.y-self.balls[i].height
					self.balls[i].dy=-self.balls[i].dy
				else
					self.balls[i].y=brick.y+BRICK_HEIGHT
					self.balls[i].dy=-self.balls[i].dy
				end
				self.balls[i].dy=self.balls[i].dy*1.02
				
				self.score=self.score+(brick:hit())

				--special code for locked block
				if brick.skin==12 then
					--open the key block if you have the key					
					if self.haskey then
						gSounds['key-open']:play()
						brick.skin=3
					else
						if not self.powerup then
							gSounds['hitkey']:play()
							self.powerup=Powerup(8,brick.x+BRICK_WIDTH/2-16,brick.y+BRICK_HEIGHT/2-16)
							self.powerup:hit()
						else
							gSounds.buzz:play()
						end
					end
				end
					
				--other powerups will drop if the player has cleared a certain number of bricks
				--most priority will be given to the health powerup
				-- the existing powerup should not be erased and show powerup only if the brick is destroyed
				if self.score>self.rhpoints and brick.destroyed and not self.powerup then
					self.rhpoints=math.min(self.score+25,self.rhpoints+self.score)
					self.powerup=Powerup(math.random(3)==1 and 1 or math.random(2,7),brick.x+BRICK_WIDTH/2-16,brick.y+BRICK_HEIGHT/2-16)
					self.powerup:hit()
				end

				break
			end
			brick:update(dt)
			lastbrick=brick
		end
		if self.balls[i]:collides(self.paddle) then
			local shiftx,shifty=0,0
			self.balls[i].y = self.paddle.y - self.balls[i].width
			if self.balls[i].x<self.paddle.x+self.paddle.width/2 and self.paddle.dir==-1 then
				self.balls[i].dx=-(150+5*math.abs(self.paddle.x+self.paddle.width/2-self.balls[i].x))
			elseif self.balls[i].x>self.paddle.x+self.paddle.width/2 and self.paddle.dir==1 then
				self.balls[i].dx=150+5*math.abs(self.paddle.x+self.paddle.width/2-self.balls[i].x)
			end
			gSounds['paddle-hit']:play()
			self.balls[i].dy=-self.balls[i].dy
		end
		--destroy the powerup if it passes the bottom edge of the screen
		if self.powerup and self.powerup.y>VIRTUAL_HEIGHT then
			self.powerup=nil
		end

		if self.balls[i].y>VIRTUAL_HEIGHT then 
			if #self.balls==1 then
				gSounds['hurt']:play()
				if self.lives==1 then
					gStateMachine:change('game-over',{
						score=self.score
					})
				else
					gStateMachine:change('serve',{
						paddle=self.paddle,
						bricks=self.bricks,
						level=self.level,
						lives=self.lives-1,
						score=self.score,
						rhpoints=self.rhpoints,
						particle={
							x=self.powerup and self.powerup.x,
							y=self.powerup and self.powerup.y
						}
					})
				end
			else
				self.balls[i].remove=true
				--just a stupid way to say break out of every loop except the outermose 
				goto continue
			end
		end
		::continue::	
	end
	for i=1,#self.balls do
		if self.balls[i].remove then
			table.remove(self.balls,i)
			break
		end
	end
	if allbrickscleared and lastbrick.animf==-1 then
		gSounds['wall-hit']:stop()
		gSounds['victory']:play()
		gStateMachine:change('level-complete',{
			paddle=self.paddle,
			bricks=self.bricks,
			level=self.level,
			lives=self.lives,
			score=self.score,
			x=self.balls[1].x,
			y=self.balls[1].y
		})
	end
	
	
	if self.powerup then
		 self.powerup:update(dt) end
	if self.powerup and self.paddle:collides(self.powerup) and not self.powerup.destroyed then
		--the health powerup
		if self.powerup.id==1 then
			gSounds.recover:play()
			self.lives=math.min(5,self.lives+1)
		--the balls powerup
		elseif self.powerup.id>=2 and self.powerup.id<=4 then
			gSounds.powerup:play()
			for i=1,#self.balls do
				self.balls[i]:setSkin(7+self.powerup.id)
			end

		--the paddle size decrease powerup (actually its not a powerup) take it twice and you die
		elseif self.powerup.id==5 then
			if self.paddle.size~=1 then
				gSounds.shrink:play()
				self.paddle:setSize(1)
				self.paddle.x=self.paddle.x+self.paddle.width/4
			else
				gSounds.hurt:play()
				
				gStateMachine:change('serve',{
					paddle=Paddle(self.paddle.color,2,self.paddle.x-self.paddle.width/4,self.paddle.y),
					bricks=self.bricks,
					level=self.level,
					lives=self.lives-1,
					score=self.score,
					rhpoints=self.rhpoints,
					particle={
						spreadx=50,
						spready=10,
						x=self.paddle.x+self.paddle.width/2,
						y=self.paddle.y+self.paddle.height/2,
						buffer=30,
						maxlt=1
					}
				})
			end
		--the paddle size increase powerup
		elseif self.powerup.id==6 then
			gSounds.powerup:play()
			if self.paddle.size~=4 then self.paddle:setSize(self.paddle.size+1) 
			self.paddle.x=self.paddle.x-self.paddle.width/4 end
		--the extra balls powerup, now you know why we treated self.balls[i] as tables
		elseif self.powerup.id==7 then
			gSounds.electric:play()	
			--PLEASE NOTE THAT
			--self.balls[#self.balls+1]=self.balls[#self.balls] WILL BE COMPLETELY WRONG
			--cause two tables are equal only if they are the same tables and making a table equal to another
			--table doesn't mean you are making a copy of that it is the same damn table and same is true for functions
			self.balls[#self.balls+1]=Ball(self.balls[1].skin)
			self.balls[#self.balls].dx=self.balls[1].dx
			self.balls[#self.balls].dy=self.balls[1].dy
			self.balls[#self.balls].x=self.paddle.x+self.paddle.width/2
		--the key powerup used to unlock the key blocks so you can destroy them
		elseif self.powerup.id==8 then
			gSounds.select:play()	
			self.haskey=true
			keytimer=0
		end
		self.powerup=nil
	end
end

function PlayState:render()
	drawBackground('background')	
	love.colors:setColor('cyan')
	drawBorderNeon()	
	renderHUD(self.lives,self.paddle.color,self.score)
	--draw the key timer
	love.graphics.setFont(gFonts.large)
	if self.haskey then
		love.graphics.printf(10-math.floor(keytimer),0,22,VIRTUAL_WIDTH,'center')
	end


	self.paddle:render()
	for i=1,#self.balls do self.balls[i]:render() end
	love.colors:setColor('skyblue')
	for i=1,#self.bricks do self.bricks[i]:render() end
	love.colors:reset()
	if self.powerup then self.powerup:render() end
	--love.graphics.draw(gTextures['pipe'],0,gTextures['pipe']:getHeight())

end
