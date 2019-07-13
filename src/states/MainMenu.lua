MainMenu=Class{__includes=BaseState}
local timer=0
--there is a good reason why most of the time you wouldn't want initialise anima over and over.
--In this anima is a local object and not part of MainMenu prototype and this is because when you transition from some other state to main menu state it wouldn't look good cause the animations would be hanging and every thing would be haphazard 
local anima={
    selected=Anima:init(),
    left=Anima:init(),
    right=Anima:init(),
}

local left=gTextures['highscores']
local right=gTextures['quit']
local selected=gTextures['play']
function MainMenu:init()
    --select the first option by default
    self.frame=1
    self.background=love.graphics.newImage("assets/images/mainmenu/frames/screen1.png")
end

function MainMenu:update(dt)
    if love.keyboard.lastKeyPressed=='escape' then
        love.event.quit() 
    elseif love.keyboard.lastKeyPressed=='enter' or love.keyboard.lastKeyPressed=='return' then

        if selected==gTextures['play'] then
            gStateMachine:change('paddle-select')            
        elseif selected==gTextures['highscores'] then
            gStateMachine:change('highscore')
        else
            love.event.quit()
        end
    end
    if self.frame>177 then
        self.frame=1
    end
    if timer > 0.05 and DEBUG_GAME==false then
        self.background=love.graphics.newImage("assets/images/mainmenu/frames/screen"..self.frame..".png")  
        self.frame=self.frame+1
        timer=0
    end
    if love.keyboard.lastKeyPressed=='right' then
        gSounds['blip']:play()
        anima.selected:newAnimation('move',0,20)
        anima.left:newAnimation('move',-20,-20)
        anima.left:newAnimation('scale',-0.05,-0.05)
        anima.right:newAnimation('move',20,-20)
        anima.right:newAnimation('scale',-0.05,-0.05)        
        left,selected,right=selected,right,left  
        leftanim=1
        rightanim=1  
        selectedanim=1      
        anima.left:animationStart()
        anima.selected:animationStart()
        anima.right:animationStart()
    end
    if love.keyboard.lastKeyPressed=='left' then
        gSounds['blip']:play()
        anima.selected:newAnimation('move',0,20)
        anima.left:newAnimation('move',-20,-20)
        anima.left:newAnimation('scale',-0.05,-0.05)
        anima.right:newAnimation('move',20,-20)
        anima.right:newAnimation('scale',-0.05,-0.05)        
        left,selected,right=right,left,selected
        leftanim=1
        rightanim=1        
        anima.left:animationStart()
        anima.selected:animationStart()
        anima.right:animationStart()
    end
    
    if leftanim==nil or leftanim==2 then
        anima.left:updateF(0.1,0.1)
    else
        anima.left:update(0.8,0.8)
    end
    if rightanim==nil or rightanim==2 then
        anima.right:updateF(0.1,0.1)
    else
        anima.right:update(0.8,0.8)
    end
    if selectedanim==nil or selectedanim==2 then
        anima.selected:updateF(0.4,0.4)
    else
        anima.selected:update()
    end
    
    if (anima.left:animationOver() and leftanim==1) or leftanim==nil then
        if leftanim==nil then
            anima.left:animationMark(-20,-20,0,-0.05,-0.05)
        else
            anima.left:animationMarkKey()        
        end
        anima.left:resetKey()
        anima.left:newAnimation("move",0,-5,true)
        anima.left:animationStart()
        leftanim=2
    end
    if (anima.right:animationOver() and rightanim==1) or rightanim==nil then
             
        if rightanim==nil then
            anima.right:animationMark(15,-20,0,-0.05,-0.05)
        else
            anima.right:animationMarkKey()        
        end
        
        anima.right:resetKey()
        anima.right:newAnimation("move",0,-5,true)
        anima.right:animationStart()
        rightanim=2
    end
    if (anima.selected:animationOver() and selectedanim==1) or selectedanim==nil then 
        if selectedanim==nil then
            anima.selected:animationMark(0,20)
        else
            anima.selected:animationMarkKey()        
        end
        anima.selected:resetKey()
        anima.selected:newAnimation("move",0,-10,true)
        anima.selected:animationStart()
        selectedanim=2
    end
    if DEBUG_GAME==false then timer=timer+dt end
end


function MainMenu:render()
    love.graphics.draw(self.background,0,0)
    --drawBackground('main-menu')
    --love.colors:setColor("white")
    --love.graphics.setFont(gFonts.italic)    
    love.graphics.draw(gTextures['credit'],VIRTUAL_WIDTH/2+170,VIRTUAL_HEIGHT/2+30)
    --love.graphics.printf("Made By Neer",0,180,VIRTUAL_WIDTH-205,'right')        
    --love.graphics.setFont(gFonts.large)
    --love.graphics.printf("Brickk",0,50,VIRTUAL_WIDTH,'center')    
    love.colors:reset()
    love.graphics.draw(gTextures['title'],VIRTUAL_WIDTH/2-270,VIRTUAL_HEIGHT/2-67)
    --love.graphics.printf("Break Breaker",0,145,VIRTUAL_WIDTH,'center')    
    love.graphics.setFont(gFonts.medium)   
    anima.selected:render(selected[1],VIRTUAL_WIDTH/2-64,VIRTUAL_HEIGHT-180,0,0.55,0.5)
    --love.graphics.draw(selected[1],VIRTUAL_WIDTH/2-gx,VIRTUAL_HEIGHT-gy,0,0.55,0.5)    
    
    anima.left:render(left[0],VIRTUAL_WIDTH/2-150,VIRTUAL_HEIGHT-160,0,0.4,0.4)                
    anima.right:render(right[0],VIRTUAL_WIDTH/2+87,VIRTUAL_HEIGHT-160,0,0.4,0.4)        
    love.graphics.setFont(gFonts.small)   
    love.graphics.printf("Copyright (C) Okra Softmakers",0,VIRTUAL_HEIGHT-16,VIRTUAL_WIDTH,'left')
    
end
