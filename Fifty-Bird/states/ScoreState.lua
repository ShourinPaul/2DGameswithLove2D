ScoreState = Class{__includes = BaseState}

local BRONZE = love.graphics.newImage('BRONZE.jpg')
local SILVER = love.graphics.newImage('SILVER.jpg')
local GOLD = love.graphics.newImage('GOLD.jpg')

function ScoreState:enter(params)
	self.score=params.score
end

function ScoreState:update(dt)
    -- go back to play if enter is pressed
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('countdown')
    end
end

function ScoreState:render()
    -- simply render the score to the middle of the screen

    love.graphics.setFont(flappyFont)
    love.graphics.printf('Oof! You lost!', 0, 64, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(mediumFont)
    love.graphics.printf('Score: ' .. tostring(self.score), 0, 100, VIRTUAL_WIDTH, 'center')


    if self.score<3 then
        love.graphics.printf('SORRY!you did not achieve anything',0,130,VIRTUAL_WIDTH,'center')

    elseif self.score<11 then
        love.graphics.printf('You have earned BRONZE medel',0,130,VIRTUAL_WIDTH,'center')
         love.graphics.draw(BRONZE,VIRTUAL_WIDTH/2-17,VIRTUAL_HEIGHT/2+2,0,.05,.05)

    elseif self.score<21 then
        love.graphics.printf('You have earned SILVER medel',0,130,VIRTUAL_WIDTH,'center')
         love.graphics.draw(SILVER,VIRTUAL_WIDTH/2-17,VIRTUAL_HEIGHT/2+2,0,.15,.12)
    elseif self.score>20 then
        love.graphics.printf('You have earned GOLD medel',0,130,VIRTUAL_WIDTH,'center')
         love.graphics.draw(GOLD,VIRTUAL_WIDTH/2-17,VIRTUAL_HEIGHT/2+2,0,.15,.12)
    end

    love.graphics.printf('Press Enter to Play Again!', 0,210, VIRTUAL_WIDTH, 'center')
end