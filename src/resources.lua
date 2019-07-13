gFonts={
    ['small']=love.graphics.newFont("assets/fonts/arial.ttf",12),
    ['normal']=love.graphics.newFont("assets/fonts/orbitron.ttf",15),
    ['idle']=love.graphics.newFont("assets/fonts/orbitron.ttf",20),    
    ['medium']=love.graphics.newFont("assets/fonts/orbitron.ttf",24),
    ['italic']=love.graphics.newFont("assets/fonts/Hack-BoldItalic.ttf",10),
    ['score-font']=love.graphics.newFont("assets/fonts/orbitron.ttf",32),
    ['large']=love.graphics.newFont("assets/fonts/orbitron.ttf",40),
    ['huge']=love.graphics.newFont("assets/fonts/orbitron.ttf",60)
}
gTextures={
    --textures for main-menu
    ['title']=love.graphics.newImage("assets/images/mainmenu/title.png"),
    ['credit']=love.graphics.newImage("assets/images/mainmenu/credit.png"),

    ['play']={},
    ['highscores']={},
    ['quit']={},


    --left and right sprites
    ['left']={},
    ['right']={},

    --textures for the 
    
    ['background']=love.graphics.newImage("assets/images/bac.png"),
    ['main']=love.graphics.newImage("assets/images/neon_version.png"),
    ['hud']=love.graphics.newImage("assets/images/ui/hud.png"),
    ['particle'] = love.graphics.newImage('assets/images/particles/particle0.png'),
    ['particle2'] = love.graphics.newImage('assets/images/particles/particle1.png'),
    ['hback']=love.graphics.newImage("assets/images/ui/Window.png"),
    ['win']=love.graphics.newImage("assets/images/ui/button_003_p.png")

}
gTextures['play'][0]=love.graphics.newImage("assets/images/mainmenu/buttons/try8.png")
gTextures['play'][1]=love.graphics.newImage("assets/images/mainmenu/buttons/try.png")
gTextures['highscores'][0]=love.graphics.newImage("assets/images/mainmenu/buttons/try5.png")
gTextures['highscores'][1]=love.graphics.newImage("assets/images/mainmenu/buttons/try2.png")
gTextures['quit'][0]=love.graphics.newImage("assets/images/mainmenu/buttons/try4.png")
gTextures['quit'][1]=love.graphics.newImage("assets/images/mainmenu/buttons/try3.png")

gTextures['left'][0]=love.graphics.newImage("assets/images/ui/left0.png")
gTextures['left'][1]=love.graphics.newImage("assets/images/ui/left1.png")
gTextures['right'][0]=love.graphics.newImage("assets/images/ui/right0.png")
gTextures['right'][1]=love.graphics.newImage("assets/images/ui/right1.png")

gSprites={
    ['paddle']=generateQuadsPaddle(),
    ['ball']=generateQuadsBall(),
    ['brick']=generateQuadsBrick(),
    ['powerup']=generateQuadsPowerup(),
    ['life']=generateQuadsLife(),
    ['hud']=generateQuadsHUD(),
}

gSounds = {
    ['blip'] = love.audio.newSource('assets/sounds/blip.wav','static'),
    ['paddle-hit'] = love.audio.newSource('assets/sounds/paddle_hit.wav','static'),
    ['score'] = love.audio.newSource('assets/sounds/score.wav','static'),
    ['wall-hit'] = love.audio.newSource('assets/sounds/wall_hit.wav','static'),
    ['confirm'] = love.audio.newSource('assets/sounds/confirm.wav','static'),
    ['select'] = love.audio.newSource('assets/sounds/select.wav','static'),
    ['no-select'] = love.audio.newSource('assets/sounds/no-select.wav','static'),
    ['buzz'] = love.audio.newSource('assets/sounds/buzz.wav','static'),
    ['brick-hit-1'] = love.audio.newSource('assets/sounds/brick-hit-1.wav','static'),
    ['brick-hit-2'] = love.audio.newSource('assets/sounds/brick-hit-2.wav','static'),
    ['hurt'] = love.audio.newSource('assets/sounds/hurt.wav','static'),
    ['victory'] = love.audio.newSource('assets/sounds/victory.wav','static'),
    ['recover'] = love.audio.newSource('assets/sounds/recover.wav','static'),
    ['shrink'] = love.audio.newSource('assets/sounds/recover.wav','static'),
    ['powerup'] = love.audio.newSource('assets/sounds/powerup.wav','static'),
    ['electric'] = love.audio.newSource('assets/sounds/electric.wav','static'),
    ['high-score'] = love.audio.newSource('assets/sounds/high_score.wav','static'),
    ['pause'] = love.audio.newSource('assets/sounds/pause.wav','static'),
    ['key'] = love.audio.newSource('assets/sounds/click_tiny.wav','static'),
    ['key-open'] = love.audio.newSource('assets/sounds/key_open.wav','static'),
    ['hitkey'] = love.audio.newSource('assets/sounds/switch2.wav','static'),
    ['win'] = love.audio.newSource('assets/sounds/win3.wav','static'),
    ['lose'] = love.audio.newSource('assets/sounds/lose.wav','static'),
    ['music'] = love.audio.newSource('assets/sounds/music.wav','static')
}

gStateMachine=StateMachine({
    ['main-menu']=function() return MainMenu() end,
    ['paddle-select']=function() return PaddleSelectState() end,
    ['serve']=function() return ServeState() end,
    ['play']=function() return PlayState() end,
    ['level-complete']=function() return LevelCompleteState() end,
    ['game-over']=function() return GameOverState() end,
    ['enter-name']=function() return EnterNameState() end,
    ['highscore']=function() return HighScoreState() end
})
