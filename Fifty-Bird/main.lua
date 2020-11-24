push = require 'push'

-- classic OOP class library
Class = require 'class'

-- bird class we've written
require 'Bird'

-- pipe class we've written
require 'Pipe'

-- class representing pair of pipes together
require 'PipePair'

require 'StateMachine'
require 'states/BaseState'
require 'states/PlayState'
require 'states/TitleScreenState'
require 'states/ScoreState'
require 'states/CountdownState' 
require 'states/PauseState'

-- physical screen dimensions
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720


-- virtual resolution dimensions
VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

-- background image and starting scroll location (X axis)
local background = love.graphics.newImage('background.png')
local backgroundScroll = 0

-- ground image and starting scroll location (X axis)
local ground = love.graphics.newImage('ground.png')
local groundScroll = 0

-- speed at which we should scroll our images, scaled by dt
local BACKGROUND_SCROLL_SPEED = 30
local GROUND_SCROLL_SPEED = 60

-- point at which we should loop our background back to X 0
local BACKGROUND_LOOPING_POINT = 413

-- point at which we should loop our ground back to X 0
local GROUND_LOOPING_POINT = 514



-- initialize our last recorded Y value for a gap placement to base other gaps off of
local lastY = -PIPE_HEIGHT + math.random(80) + 20

-- scrolling variable to pause the game when we collide with a pipe
scrolling = true

function love.load()
    -- initialize our nearest-neighbor filter
    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- app window title
    love.window.setTitle('Fifty Bird')

    smallFont = love.graphics.newFont('font.ttf', 8)
    mediumFont = love.graphics.newFont('flappy.ttf', 14)
    flappyFont = love.graphics.newFont('flappy.ttf', 28)
    hugeFont = love.graphics.newFont('flappy.ttf', 56)
    love.graphics.setFont(flappyFont)
    -- initialize our virtual resolution
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })

    sounds={
        ['jump']=love.audio.newSource('jump.wav','static'),
        ['explosion']=love.audio.newSource('explosion.wav','static'),
        ['hurt']=love.audio.newSource('hurt.wav','static'),
        ['score']=love.audio.newSource('score.wav','static'),

        ['music']=love.audio.newSource('marios_way.mp3','static')  

    }

    sounds['music']:setLooping(true)
    sounds['music']:play()

    gStateMachine=StateMachine{
        ['title']=function() return TitleScreenState() end,
        ['play']=function() return PlayState() end,
        ['score']=function() return ScoreState() end,
        ['countdown']=function() return CountdownState() end,
        ['pause']=function() return PauseState() end
    }

    gStateMachine:change('title')
    -- initialize input table
    love.keyboard.keysPressed = {}
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    -- add to our table of keys pressed this frame
    love.keyboard.keysPressed[key] = true
    
    if key == 'escape' then
        love.event.quit()
    end
end

--[[
    New function used to check our global input table for keys we activated during
    this frame, looked up by their string value.
]]
function love.keyboard.wasPressed(key)
    if love.keyboard.keysPressed[key] then
        return true
    else
        return false
    end
end

function love.update(dt)
    if scrolling then
        -- scroll background by preset speed * dt, looping back to 0 after the looping point
        backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt) 
            % BACKGROUND_LOOPING_POINT

        -- scroll ground by preset speed * dt, looping back to 0 after the screen width passes
        groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt) 
            % GROUND_LOOPING_POINT
    end
        gStateMachine:update(dt)
    love.keyboard.keysPressed = {}
end

function love.draw()
    push:start()

    -- draw the background at the negative looping point
    love.graphics.draw(background, -backgroundScroll, 0)

    -- render all the pipe pairs in our scene
    gStateMachine:render()

    -- draw the ground on top of the background, toward the bottom of the screen,
    -- at its negative looping point
    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16)

    -- render our bird to the screen using its own render logic
    
    push:finish()
end