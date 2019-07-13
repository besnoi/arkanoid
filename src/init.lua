math.randomseed(os.time())
push:setupScreen(VIRTUAL_WIDTH,VIRTUAL_HEIGHT,WINDOW_WIDTH,WINDOW_HEIGHT,{
    vsync=true
})
love.window.setTitle("Arkanoid!!!")
love.graphics.setFont(gFonts.small)
love.graphics.setDefaultFilter('nearest','nearest')
gStateMachine:change('main-menu')

gSounds.music:setVolume(0.4)
gSounds.music:play()
gSounds.music:setLooping(true)