push=require 'lib/push'
Class=require 'lib/class'
love.colors=require 'lib/colorcodes'
Anima=require '../../lib/Anima'
csvfile=require '../../lib/tinyCSV'

require 'lib/itable'
require 'lib/StateMachine'
require 'lib/xkf'

require 'src/constants'

--defines the utility functions related to generating quads
require 'src/util'

--initialise the global objects such as gStateMachine,gFonts,etc and
require 'src/resources'

--defines the functions such as drawBackground,etc
require'src/custom'

--require the prototypes/classes for our game objects
require 'src/objects/Paddle'
require 'src/objects/Ball'
require 'src/objects/Brick'
require 'src/objects/Powerup'
require 'src/objects/LevelMaker'

--require the states

require 'src/states/BaseState'
require 'src/states/MainMenu'
require 'src/states/PaddleSelectState'
require 'src/states/ServeState'
require 'src/states/PlayState'
require 'src/states/LevelCompleteState'
require 'src/states/GameOverState'
require 'src/states/EnterNameState'
require 'src/states/HighScoreState'
