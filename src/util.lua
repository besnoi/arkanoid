
function generateQuadsBorderNeon()
	local quads={
		['top-left']=love.graphics.newQuad(0,0,32,37,gTextures['main']:getDimensions()),
		['top-right']=love.graphics.newQuad(32,0,32,37,gTextures['main']:getDimensions()),
		['bottom-left']=love.graphics.newQuad(0,35,28,35,gTextures['main']:getDimensions()),
		['bottom-right']=love.graphics.newQuad(28,35,28,35,gTextures['main']:getDimensions()),
		['horizontal']=love.graphics.newQuad(64,32,32,25,gTextures['main']:getDimensions()),		
		['vertical']=love.graphics.newQuad(64,0,26,32,gTextures['main']:getDimensions()),
		['pipe-vertical']=love.graphics.newQuad(0,96,32,112,gTextures['main']:getDimensions()),		
		['pipe-horizontal']=love.graphics.newQuad(32,96,112,32,gTextures['main']:getDimensions())
	}
	return quads
end

function generateQuadsPaddle()
	local quads,counter={},1
	local y=210+60+32
	for i=1,7 do 
		quads[counter]=love.graphics.newQuad(0,y,58,30,gTextures['main']:getDimensions())
		quads[counter+1]=love.graphics.newQuad(58,y,90,30,gTextures['main']:getDimensions())
		quads[counter+2]=love.graphics.newQuad(58+90,y,128,30,gTextures['main']:getDimensions())
		quads[counter+3]=love.graphics.newQuad(58+90+128,y,176,30,gTextures['main']:getDimensions())
		y=y+30
		counter=counter+4
	end
	return quads
end

function generateQuadsBall()
	local quads={}
	for i=1,2 do 
		for j=1,4 do
			quads[j+(i-1)*4]=love.graphics.newQuad(32+(j-1)*16,176+(i-1)*16,16,16,gTextures['main']:getDimensions())
		end
	end
	quads[9]=love.graphics.newQuad(96,128,32,32,gTextures['main']:getDimensions()) --football
	quads[10]=love.graphics.newQuad(96,160,32,32,gTextures['main']:getDimensions()) --galactic ball
	quads[11]=love.graphics.newQuad(96,160+32,32,32,gTextures['main']:getDimensions()) --basket ball
	return quads
end

function generateQuadsBrick()
	--[[
		1-6 are what could be easily guessed from the spritesheet (the top-right part)
		7-11 are the animations
		12 is the key-blocks - i.e. only if you have the key could you open the lock. These
		blocks are the most difficult cause key would drop if you hit these block without a key and
		then you will have to hit the block again with that key- but there's a twist you have to do that
		within 10 seconds. After 10 seconds it would like you never had the key. So you could do this infinite times
		hitting the blocking - getting the key - not hitting the block within 10 seconds. And if this loop isn't all
		then there's another difficulty - opening the key doesn't mean you break it. And remember the blocks are
		the dangerous 4-hit blocks and another thing- you get absolutely no points for obtaining the key or for unlocking
		the block
	]]
	local quads={}
	for i=1,6 do 
		for j=1,7 do
			quads[j+(i-1)*7]=love.graphics.newQuad(324+(j-1)*54,(i-1)*22,54,22,gTextures['main']:getDimensions())
		end
	end
	for i=1,5 do
		for j=1,7 do
			quads[42+j+(i-1)*7]=love.graphics.newQuad(255+(j-1)*64,138+(i-1)*32,64,32,gTextures['main']:getDimensions())
		end
	end
	for i=1,3 do
		for j=1,2 do
			-- print("here",i,j)
			quads[77+j+(i-1)*2]=love.graphics.newQuad(594+(j-1)*54,308+(i-1)*22,54,22,gTextures['main']:getDimensions())
		end
	end
	quads[84]=love.graphics.newQuad(594,374,54,22,gTextures['main']:getDimensions())
	
	return quads
end

function generateQuadsLife()
	local quads={}
	for i=1,2 do
		for j=1,4 do
			quads[j+(i-1)*4]=love.graphics.newQuad(453+(j-1)*32,448+(i-1)*32,32,32,gTextures['main']:getDimensions())
		end
	end
	return quads
end

function generateQuadsHUD()
	return {
		--our banner
		love.graphics.newQuad(103,0,36,61,gTextures['main']:getDimensions()),
		love.graphics.newQuad(103+36,0,32,61,gTextures['main']:getDimensions()),
		love.graphics.newQuad(103+36+32,0,36,61,gTextures['main']:getDimensions()),

		--the backdrop behind the score and lives
		love.graphics.newQuad(123,222,123,74,gTextures['main']:getDimensions())
	}
end

function generateQuadsPowerupIcons()
	local quads={}
	for i=1,4 do
		quads[i]=love.graphics.newQuad(224+(i-1)*16,32,16,16,gTextures['main']:getDimensions())
	end
	return quads
end

function generateQuadsPowerup()
	local quads={}
	quads[1]=love.graphics.newQuad(86,59,32,32,gTextures['main']:getDimensions())
	quads[2]=love.graphics.newQuad(86+32,59,32,32,gTextures['main']:getDimensions())
	for i=1,2 do
		for j=1,2 do
			quads[j+i*2]=love.graphics.newQuad(150+(j-1)*32,59+(i-1)*32,32,32,gTextures['main']:getDimensions())
		end
	end
	quads[7]=love.graphics.newQuad(246,59,32,32,gTextures['main']:getDimensions())
	quads[8]=love.graphics.newQuad(246+32,59,32,32,gTextures['main']:getDimensions())
	return quads
end