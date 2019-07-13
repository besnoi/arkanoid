--scale the texture to fit the window size
function drawBackground(texture)
    if texture=='sci-fi' then 
        love.graphics.draw(gTextures[texture])
        return
    end
    love.graphics.draw(gTextures[texture],0,0,0,
        VIRTUAL_WIDTH/(gTextures[texture]:getWidth()-1),
        VIRTUAL_HEIGHT/(gTextures[texture]:getHeight()-1)
    )
end

function renderLife(lives,paddleid)
    love.colors:setColor('cadetblue')
    if lives>=5 then
        love.graphics.draw(gTextures['main'],gSprites['hud'][4],VIRTUAL_WIDTH-186,7,0,1.52,0.85)
    elseif lives==4 then
        love.graphics.draw(gTextures['main'],gSprites['hud'][4],VIRTUAL_WIDTH-150,7,0,1.2,0.85)
    else
        love.graphics.draw(gTextures['main'],gSprites['hud'][4],VIRTUAL_WIDTH-114,7,0,0.9,0.85)
    end
    love.colors:reset()
    _n_lives=math.min(5,math.max(3,lives))
    for i=1,_n_lives do
        love.graphics.draw(gTextures['main'],gSprites['life'][lives>0 and paddleid or 8],VIRTUAL_WIDTH-12-_n_lives*32+(i-1)*32,23)
        if lives~=0 then lives=lives-1 end
    end
end

function renderScore(score)
    love.colors:setColor('cadetblue')
    if score<100 then
        love.graphics.draw(gTextures['main'],gSprites['hud'][4],3,7,0,1.35,0.85)
    -- assumption: score will be less than 500
    elseif score<200 or (score>200 and score<=210) or (score>300 and score<=310) or ((score>400 and score<=410))   then
        love.graphics.draw(gTextures['main'],gSprites['hud'][4],3,7,0,1.45,0.85)
    else
        love.graphics.draw(gTextures['main'],gSprites['hud'][4],3,7,0,1.55,0.85)        
    end
    love.colors:reset()
    love.graphics.setFont(gFonts.medium)
    love.graphics.print("Score: "..score,20,28)  
end

function renderHUD(lives,paddleid,score)
    love.graphics.draw(gTextures['main'],gSprites['hud'][1],0,0,0,1,1.2)
	for i=1, 23 do love.graphics.draw(gTextures['main'],gSprites['hud'][2],36+(i-1)*32,0,0,1,1.2) end
	love.graphics.draw(gTextures['main'],gSprites['hud'][3],36+23*32,0,0,0.8,1.2)
	love.colors:reset()
	renderLife(lives,paddleid)
    renderScore(score)
end

function drawBorderNeon()
    local border=generateQuadsBorderNeon()
    love.graphics.draw(gTextures['main'],border['top-left'],2,75)
    love.graphics.draw(gTextures['main'],border['top-right'],VIRTUAL_WIDTH-36,75)
    for i=1,16 do 
        love.graphics.draw(gTextures['main'],border['vertical'],2,75+37+32*(i-1))
        love.graphics.draw(gTextures['main'],border['vertical'],VIRTUAL_WIDTH-30,75+37+32*(i-1))
    end
    for i=1,23 do 
        love.graphics.draw(gTextures['main'],border['horizontal'],2+32*i,75+2)
    end
    love.colors:setOpacity(0.3)
    -- for i=2,6,2 do
    --     love.graphics.draw(gTextures['main'],border['pipe-vertical'],0,18*i+90*(i-2))
    --     love.graphics.draw(gTextures['main'],border['pipe-vertical'],VIRTUAL_WIDTH-32-2,18*i+90*(i-2))
    --     love.graphics.draw(gTextures['main'],border['pipe-horizontal'],10+40*i+90*(i-2),0)
    -- end
    love.colors:setOpacity(1)
end

function displayFPS()

    love.colors:setColor("red")
    love.graphics.setFont(gFonts.large)
    love.graphics.printf("FPS:"..love.timer.getFPS(),10,30,VIRTUAL_WIDTH,'left')
    love.graphics.setFont(gFonts.medium)
    love.colors:reset()
end

