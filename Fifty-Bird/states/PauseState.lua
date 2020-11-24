PauseState=Class{__includes= BaseState}

local pause = love.graphics.newImage('sss.png')

function PauseState:enter(params)
	scrolling=false
	sounds['music']=love.audio.pause()
	self.bird=params.bird
	self.pipePairs=params.pipePairs
	self.score=params.score
	self.timer=params.timer
end
function PauseState:init( )
	
end


function PauseState:update(dt)
	if love.keyboard.wasPressed('tab') then
    	gStateMachine:change('play',{
                            bird = self.bird,
                            pipePairs = self.pipePairs,
                            score = self.score,
                            timer = self.timer
                            })
 	end
end

function PauseState:render()
	for k, pair in pairs(self.pipePairs) do
        pair:render()
    end

    love.graphics.setFont(flappyFont)
    love.graphics.print('Score: ' .. tostring(self.score), 8, 8)
    --love.graphics.print('HP: '..tostring(self.bird.health), 8, 40) 

    love.graphics.draw(pause,VIRTUAL_WIDTH/2-40,VIRTUAL_HEIGHT/2-40,0,.15,.15)

    self.bird:render()

end