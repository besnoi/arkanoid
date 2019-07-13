require 'src/dependencies'

function love.load()
    require 'src/init'
end

function love.update(dt)
    gStateMachine:update(dt)
    love.keyboard.lastKeyPressed=nil
end

function love.draw()
    push:start()
    gStateMachine:render()  
    -- displayFPS()
    push:finish()
end

function love.resize(w,h)
    push:resize(w,h)
end

function love.keypressed(key)
    love.keyboard.lastKeyPressed=key
end