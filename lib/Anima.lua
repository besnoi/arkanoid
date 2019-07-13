--[[
    Anima: The unofficial Keyframe animation library of LOVE2D
    Licensed Under GPLv3
    Author: Neer 
]]

local Anima={}
--note that animOver(private) is for internal usage and animEnd(public) is for external usage
function Anima:init()
    local obj={stage=nil,rforever={x=true,y=true,r=true,sx=true,sy=true,op=true},mark={x=0,y=0,r=0,sx=0,sy=0,op=0},key={x=0,y=0,r=0,sx=0,sy=0,op=0},x=0,y=0,r=0,sx=0,sy=0,op=0,animStart=false,animOver=false,animEnd=false}
    setmetatable(obj,self)
    self.__index=self
    return obj
end

function Anima:setRepeat(x,y,r,sx,sy,op)
    self.rforever={x=x,y=y,r=r,sx=sx,op=op}
end

function Anima:setRepeatScale(sx,sy)
    self.rforever.sx=sx
    self.rforever.sy=sy
end

function Anima:setRepeatMove(x,y)
    self.rforever.x=x
    self.rforever.y=y
end

function Anima:setRepeatOpacity(op)
    self.rforever.op=op
end

function Anima:setRepeatRotation(r)
    self.rforever.r=r
end

function Anima:newAnimation(animation,...)
    local width,height,mark;
    if animation=='cscale' then
        self.key.sx,self.key.sy,width,height,mark=...
        assert(width and height,"Width and Height cannot be nil. Please provide a value")
        self:newAnimation('scale',self.key.sx,self.key.sy,mark)
        self:newAnimation('move',-width*self.key.sx/2,-height*self.key.sy/2,mark)
        return
    elseif animation=='scale' then
        self.key.sx,self.key.sy,mark=...
    elseif animation=='move' then
        self.key.x,self.key.y,mark=...
    elseif animation=='rotate' then
        self.key.r,mark=...
    elseif animation=='opacity' then
        self.key.op,mark=...
    else
        self.key.x,self.key.y,self.key.r,self.key.sx,self.key.sy,self.op,mark=animation,...
    end
    self.key.sx=self.key.sx or 0
    self.key.sy=self.key.sy or 0
    self.key.x=self.key.x or 0
    self.key.y=self.key.y or 0
    self.key.r=self.key.r or 0
    self.key.op=self.key.op or 0
    
    if not mark then
        self.mark={x=0,y=0,r=0,sx=0,sy=0,op=0}
    end
end

function Anima:startNewAnimation(...)
    self:newAnimation(...)
    self:animationStart()
end

--useful if you want to roll back animation
function Anima:animationRollBack(operation,mark)
    if operation=='move' then
        self:newAnimation('move',-self.x,-self.y,mark)
    elseif operation=='rotate' then
        self:newAnimation('rotate',-self.r,mark)
    elseif operation=='scale' then
        self:newAnimation('scale',-self.sx,-self.sy,mark)
    elseif operation=='opacity' then
        self:newAnimation('opacity',-self.op,mark)
    else
        self:newAnimation(-self.x,-self.y,-self.r,-self.sx,-self.sy,-self.op,mark)
    end
end
function Anima:animationStart(x,y,r,sx,sy,op)
    self.x,self.y=x or 0,y or 0
    self.r=r or 0
    self.sx,self.sy=sx or 0,sy or 0
    self.op=op or 0
    self.animStart,self.animOver=true,false
    self.animEnd=false
end
--instead of resetting the values like in animationStart(), animationStartOver() uses the default values
function Anima:animationStartOver(x,y,r,sx,sy,op)
    self.x,self.y=x or self.x,y or self.y
    self.r=r or self.r
    self.sx,self.sy=sx or self.sx,sy or self.sy
    self.op=op or self.op
    self.animStart,self.animOver=true,false
    self.animEnd=false
end
function Anima:animationStarted()
    return self.animStart
end
function Anima:animationRunning()
    return not self.animEnd
end
function Anima:animationOver()
    return self.animEnd
end
function Anima:animationStop(arg)
    if arg==nil then arg=true end
    self.animEnd=arg
end
function Anima:resetAnimation()
    self.x,self.y,self.r,self.sx,self.sy,self.op=0,0,0,0,0,0
end
function Anima:resetKey()
    self.key={x=0,y=0,r=0,sx=0,sy=0,op=0}
end
function Anima:resetKeyM()
    self.key.x=0
    self.key.y=0
end
function Anima:resetKeyS()
    self.key.sx=0
    self.key.sy=0
end
function Anima:resetKeyO()
    self.key.op=0
end
--Many times you want to mark a position for various reasons - maybe you want to continue
--from where you stopped and you can do this on your own but I'd discourage you 'cause you 
--are only wasting your time since it has already been done for you in animationMark
function Anima:animationMark(x,y,r,sx,sy,op)
    if x==nil then
        self.mark={x=self.mark.x+self.x,y=self.mark.y+self.y,r=self.mark.r+self.r,sx=self.mark.sx+self.sx,sy=self.mark.sy+self.sy,op=self.mark.op+self.op}
    else
        self.mark.x=self.mark.x+x
        self.mark.y=self.mark.y+(y or 0)
        self.mark.r=self.mark.r+(r or 0)
        self.mark.sx=self.mark.sx+(sx or 0)
        self.mark.sy=self.mark.sy+(sy or 0)
        self.mark.op=self.mark.op+(op or 0)
    end
end
function Anima:animationMarkKey()
    self.mark=self.key
end
function Anima:markM()
    self:animationMark(self.x,self.y,0)
end
function Anima:markR()
    self:animationMark(0,0,self.r)
end
function Anima:markS()
    self:animationMark(0,0,0,self.sx,self.sy)
end
function Anima:markO()
    self:animationMark(0,0,0,0,0,self.op)
end
function Anima:updateT(animtbl,cmts,funcs)
    for i in ipairs(animtbl) do
        --think of i as the self.stage
        if not self.stage or (self:animationOver() and self.stage==i) then
            if not self.stage then self.stage=1 end
            self:animationMark()
            if cmts and funcs then
                assert(type(cmts)=='table',"Oops! Table expected in #2nd argument, got '"..type(cmts).."''")
                assert(type(funcs)=='table',"Oops! Table expected in #3rd argument, got '"..type(funcs).."''")
                for cmt in pairs(cmts) do 
                    if cmts[cmt]==animtbl[i]['comment'] then
                        assert(type(funcs[cmt])=='function',"Oops! Function expected for #3rd argument table at key '"..cmt.."'")
                        funcs[cmt]()
                    end
                end    
            end
            self:newAnimation(animtbl[i]['x'],animtbl[i]['y'],animtbl[i]['r'],animtbl[i]['sx'],animtbl[i]['sy'],animtbl[i]['op'],true)
            self:animationStart()
            self.stage=self.stage+1
        end
    end    
    if cmts and (not funcs) then
        assert(type(cmts)=='table',"Oops! Table expected in #2nd argument, got '"..type(cmts).."''")
        self:update(cmts['dx'],cmts['dy'],cmts['dr'],cmts['dsx'],cmts['dsy'],cmts['dop'],cmts['f']) 
    else
        self:update(animtbl[self.stage-1]['dx'],animtbl[self.stage-1]['dy'],animtbl[self.stage-1]['dr'],animtbl[self.stage-1]['dsx'],animtbl[self.stage-1]['dsy'],animtbl[self.stage-1]['dop'],animtbl[self.stage-1]['f'])
    end
end
function Anima:update(stepx,stepy,stepr,stepsx,stepsy,stepop,forever)
    --(self.x<self.key.x and 1 or -1)
    --(self.y>self.key.y and 1 or -1)
    if type(stepx)=='table' then
        self:updateT(stepx,stepy,stepr)
        return
    end
    stepx=stepx or 1
    stepy=stepy or 1
    stepr=stepr or math.pi/20
    stepsx=stepsx or 0.01
    stepsy=stepsy or 0.01
    stepop=stepop or 0.01
    if self.animStart and not self.animOver then
        if self.key.x~=0 and self.key.x~=self.x then self.x=self.x+(self.x<self.key.x and stepx or -stepx) end
        if self.key.y~=0 and self.key.y~=self.y then self.y=self.y+(self.y<self.key.y and stepy or -stepy) end
        if self.key.sx~=0 and self.key.sx~=self.sx then self.sx=self.sx+(self.sx<self.key.sx and stepsx or -stepsx) end
        if self.key.sy~=0 and self.key.sy~=self.sy then self.sy=self.sy+(self.sy<self.key.sy and stepsy or -stepsy) end
        if self.key.r~=0 and self.key.r~=self.r then self.r=self.r+(self.r<self.key.r and stepr or -stepr) end
        if self.key.op~=0 and self.key.op~=self.op then self.op=self.op+(self.op<self.key.op and stepop or -stepop) end
        if (self.key.x>0 and self.x>self.key.x) or (self.key.x<0 and self.x<self.key.x) then
            self.x=self.key.x
        end
        if (self.key.sx>0 and self.sx>self.key.sx) or (self.key.sx<=0 and self.sx<self.key.sx) then
            self.sx=self.key.sx
        end
        if (self.key.y>0 and self.y>self.key.y) or (self.key.y<=0 and self.y<self.key.y) then
            self.y=self.key.y
        end
        if (self.key.sy>0 and self.sy>self.key.sy) or (self.key.sy<=0 and self.sy<self.key.sy) then
            self.sy=self.key.sy
        end
        if (self.key.r>0 and self.r>self.key.r) or (self.key.r<=0 and self.r<self.key.r) then
            self.r=self.key.r
        end
        if (self.key.op>0 and self.op>self.key.op) or (self.key.op<=0 and self.op<self.key.op) then
            self.op=self.key.op
        end
        if self.x==self.key.x and self.y==self.key.y and self.r==self.key.r and self.sx==self.key.sx and self.sy==self.key.sy and self.op==self.key.op then
            --print("hell yeah")
            if forever then
                if self.rforever.x then self.key.x=-self.key.x end
                if self.rforever.y then self.key.y=-self.key.y end
                if self.rforever.r then self.key.r=-self.key.r end
                if self.rforever.sx then self.key.sx=-self.key.sx end
                if self.rforever.sy then self.key.sy=-self.key.sy end
                if self.rforever.op then self.key.op=-self.key.op end
            else
                self.animOver=true
                self.animEnd=true
            end
        end
    end
end
function Anima:updateF(x,y,r,sx,sy,op)
    self:update(x or 1,y or 1,r or math.pi/20,sx or 0.01,sy or 0.01,op or 0.01,true)
end
function Anima:updateM(stepx,stepy)
    self:update(stepx,stepy)
end

function Anima:updateR(stepr,forever)
    self:update(1,1,stepr,forever)
end

function Anima:updateS(stepsx,stepsy,forever)
    self:update(1,1,math.pi/20,stepsx,stepsy,forever)
end

function Anima:updateO(stepo,forever)
    self:update(1,1,math.pi/20,0.01,0.01,stepo,forever)
end
--render the animation
function Anima:render(img,x,y,r,sx,sy,addKey,...)
    --you may want - sometimes - to have the render before the animation part look just like
    --how it would look after animation for that addKey must be true
    --P.S. FOR MORE CONTROL I RECOMMEND YOU USE animationOver() AND RENDER IN TWO DIFFERENT WAYS
    --assert(img,"The 'render' function requires atleast a drawable object as an argument")
    x=(x or 0) + (addKey==true and self.key.x or 0)
    y=(y or 0) + (addKey==true and self.key.y or 0)
    r=(r or 0) + (addKey==true and self.key.r or 0)
    sx=(sx or 1) + (addKey==true and self.key.sx or 0)
    sy=(sy or 1) + (addKey==true and self.key.sy or 0 )
    if addKey~=true and addKey then args=addKey end
    local cr,cg,cb,ca=love.graphics.getColor()
    love.graphics.setColor(cr,cg,cb,ca+self.op+(addKey and self.key.op or 0))
    
    love.graphics.draw(img,x+self.mark.x+self.x,y+self.mark.y+self.y,r+self.mark.r+self.r,sx+self.mark.sx+self.sx,sy+self.mark.sy+self.sy,args,...)
    love.graphics.setColor(cr,cg,cb,ca)
end

--i could have done this automatically in render function, but it would have been slower

function Anima:print(text,x,y,r,sx,sy,addKey,...)
    x=(x or 0) + (addKey==true and self.key.x or 0)
    y=(y or 0) + (addKey==true and self.key.y or 0)
    r=(r or 0) + (addKey==true and self.key.r or 0)
    sx=(sx or 1) + (addKey==true and self.key.sx or 0)
    sy=(sy or 1) + (addKey==true and self.key.sy or 0 )
    if addKey~=true and addKey then args=addKey end
    local cr,cg,cb,ca=love.graphics.getColor()
    love.graphics.setColor(cr,cg,cb,ca+self.op+(addKey and self.key.op or 0))
    
    love.graphics.print(text,x+self.mark.x+self.x,y+self.mark.y+self.y,r+self.mark.r+self.r,sx+self.mark.sx+self.sx,sy+self.mark.sy+self.sy,args,...)
    love.graphics.setColor(cr,cg,cb,ca)
end

function Anima:printf(text,x,y,limit,alignmode,r,sx,sy,addKey,...)
    x=(x or 0) + (addKey==true and self.key.x or 0)
    y=(y or 0) + (addKey==true and self.key.y or 0)
    r=(r or 0) + (addKey==true and self.key.r or 0)
    sx=(sx or 1) + (addKey==true and self.key.sx or 0)
    sy=(sy or 1) + (addKey==true and self.key.sy or 0 )
    if addKey~=true and addKey then args=addKey end
    local cr,cg,cb,ca=love.graphics.getColor()
    love.graphics.setColor(cr,cg,cb,ca+self.op+(addKey and self.key.op or 0))
    
    love.graphics.printf(text,x+self.mark.x+self.x,y+self.mark.y+self.y,limit,alignmode,r+self.mark.r+self.r,sx+self.mark.sx+self.sx,sy+self.mark.sy+self.sy,args,...)
    love.graphics.setColor(cr,cg,cb,ca)
end

function Anima:getX(x)
    x=x or 0
    --note x is the initial abscissa
    return x+self.mark.x+self.x
end
function Anima:getY(y)
    y=y or 0
    --note y is the initial ordinate
    return y+self.mark.y+self.y
end
function Anima:getSX(sx)
    sx=sx or 0
    --note sx is the initial scale along x axis
    return sx+self.mark.sx+self.sx
end
function Anima:getSY(sy)
    sy=sy or 0
    --note sy is the initial scale along y axis
    return sy+self.mark.sy+self.sy
end
function Anima:getPosition(x,y)
    --note x and y are the initial positions
    return self:getX(x),self:getY(y)
end
function Anima:getRotation(r)
    --note r is the initial angle of rotation
    r=r or 0
    return r+self.mark.r+self.r
end
function Anima:getScale(sx,sy)
     --note sx and sy are the scale values
    return self:getSX(sx),self:getSY(sy)
end
function Anima:renderQuad(img,quad,x,y,r,sx,sy,addKey,...)
    x=(x or 0) + (addKey and self.key.x or 0)
    y=(y or 0) + (addKey and self.key.y or 0)
    r=(r or 0) + (addKey and self.key.r or 0)
    sx=(sx or 1) + (addKey and self.key.sx or 0)
    sy=(sy or 1) + (addKey and self.key.sy or 0 )
    
    local cr,cg,cb,ca=love.graphics.getColor()
    love.graphics.setColor(cr,cg,cb,ca+self.op+(addKey and self.key.op or 0))

    love.graphics.draw(img,quad,x+self.mark.x+self.x,y+self.mark.y+self.y,r+self.mark.r+self.r,sx+self.mark.sx+self.sx,sy+self.mark.sy+self.sy,...)
    love.graphics.setColor(cr,cg,cb,ca)
end
return Anima
