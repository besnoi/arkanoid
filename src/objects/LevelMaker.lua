LevelMaker={}

function LevelMaker.generateLevel(level,type)
	if type=='dragon' then return LevelMaker.generateDragon() end
	local count=1
	local bricks={}
	local skipblock,skiprow,shapes,printshapes
	local skipmiddleblock=level>3 and math.random(2)==1 and level<15
	local alternatecolors,allsamecolor
	for i=1,math.min(12,5+math.floor(level/3)) do 
		shapes={
			math.random(3)==1 and {1,11},
			math.random(3)==1 and {1,6,11},
			math.random(3)==1 and {1,5,7,11},
			math.random(3)==1 and {1,5,6,7,11}
		}
		skipblock=(math.random(2+math.ceil(level/2))==1 and level<20) or nil
		skiprow=math.random(2+level)==1 and level<20

		--the probability that large no of the rows are skipped in higher levels (<20) still exists, but it's highly unlikely
		--if you want to stay on the safer side then you can have a extra variable to keep count of how many rows you have skipped and you know what i mean
		alternatecolors=math.random(2)==1 and {math.random(7),math.random(7)}
		allsamecolor=math.random(7)
		if alternatecolors and alternatecolors[1]==alternatecolors[2] then
			alternatecolors[1]=alternatecolors[2] + (alternatecolors[2]>1 and -1 or 1)
		end
		if skiprow and i~=3 then
			--i~=3 so the third row will never be skipped
			goto continue
		end
		printshapes=(math.random(1+level)==1) and level<20
		for j=1,11 do
			for k,shape in ipairs(shapes) do 
				if shape and printshapes then
					if not table.exists(shape,j) then
						goto innercontinue
					else
						skipblock=true
						--true cause in the next line it is going to be false
					end
				end
			end
			if skipblock~=nil and level<20 then skipblock=skipblock==false end
			if not skipblock and ((skipmiddleblock and j~=6) or not skipmiddleblock)then
				bricks[count]=Brick(
					(level<5 or math.random(level-4)==1) and 1 or (math.random(5)==1 and (math.random(4)==1 and 12 or 2) or 3),
					alternatecolors and alternatecolors[j%2+1] or allsamecolor,
					100+(j-1)*54,125+(i-1)*22)
				count=count+1
			end
			::innercontinue::
		end
		::continue::
	end
	--very very dangerous code here but everything should be (probabistically) fine for level<6
	--infact for level 1,2,3 i suggest you make a ton of bricks like i made this generateDragon thing
	--and choose between them. that'd be more efficient, but it's alright since we are not doing this only
	--once so frame rate will drop only for a small period of time and once level is generated it'd be back to normal
	if (level<6 and (#bricks>level*14 or #bricks<level*10)) then
		-- print('recursion')
		return LevelMaker.generateLevel(level,type)
	end
	return bricks
end

function LevelMaker.generateDragon()
	local bricks={}
	for j=1,10 do
		bricks[j]=Brick(1,math.random(7),125+(j-1)*54,125)
	end
	-- local math.random(7)=math.random(7)
	bricks[11]=Brick(1,math.random(7),125,125+22)
	bricks[12]=Brick(1,math.random(7),125+4*54,125+22)
	bricks[13]=Brick(1,math.random(7),125+5*54,125+22)
	bricks[14]=Brick(1,math.random(7),125+486,125+22)
	
	bricks[15]=Brick(1,math.random(7),125,125+44)
	bricks[16]=Brick(1,math.random(7),125+108,125+44)
	bricks[17]=Brick(1,math.random(7),125+4*54,125+44)
	bricks[18]=Brick(1,math.random(7),125+5*54,125+44)
	bricks[19]=Brick(1,math.random(7),125+7*54,125+44)
	bricks[20]=Brick(1,math.random(7),125+486,125+44)

	bricks[21]=Brick(1,math.random(7),125,125+66)
	bricks[22]=Brick(1,math.random(7),125+4*54,125+66)
	bricks[23]=Brick(1,math.random(7),125+5*54,125+66)
	bricks[24]=Brick(1,math.random(7),125+486,125+66)
	

	bricks[25]=Brick(1,math.random(7),125,125+88)
	bricks[26]=Brick(1,math.random(7),125+3*54,125+88)
	bricks[27]=Brick(1,math.random(7),125+4*54,125+88)
	bricks[28]=Brick(1,math.random(7),125+5*54,125+88)
	bricks[29]=Brick(1,math.random(7),125+6*54,125+88)
	bricks[30]=Brick(1,math.random(7),125+486,125+88)

	bricks[31]=Brick(1,math.random(7),125,125+110)
	bricks[32]=Brick(1,math.random(7),125+3*54,125+110)
	bricks[33]=Brick(1,math.random(7),125+6*54,125+110)
	bricks[34]=Brick(1,math.random(7),125+486,125+110)

	bricks[35]=Brick(1,math.random(7),125,125+132)
	bricks[36]=Brick(1,math.random(7),125+3*54,125+132)
	bricks[37]=Brick(1,math.random(7),125+6*54,125+132)
	bricks[38]=Brick(1,math.random(7),125+486,125+132)


	bricks[39]=Brick(1,math.random(7),125,125+154)
	bricks[40]=Brick(1,math.random(7),125+4*54,125+154)
	bricks[41]=Brick(1,math.random(7),125+5*54,125+154)
	bricks[42]=Brick(1,math.random(7),125+486,125+154)
	
	bricks[43]=Brick(1,math.random(7),125,125+176)
	bricks[44]=Brick(1,math.random(7),125+4.5*54,125+176)
	bricks[45]=Brick(1,math.random(7),125+486,125+176)
	
	bricks[46]=Brick(1,math.random(7),125,125+198)
	bricks[47]=Brick(1,math.random(7),125+4.5*54,125+198)
	bricks[48]=Brick(1,math.random(7),125+486,125+198)
	

	for j=1,10 do
		bricks[48+j]=Brick(1,math.random(7),125+(j-1)*54,125+198+22)
	end

	return bricks
end