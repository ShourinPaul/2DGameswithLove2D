PlayState = Class{__includes= BaseState}

PIPE_SPEED = 60
PIPE_WIDTH = 70
PIPE_HEIGHT = 288

BIRD_WIDTH = 38
BIRD_HEIGHT = 24

function PlayState:init()

	self.lastY= -PIPE_HEIGHT + math.random(80)+20
end

math.randomseed(os.time())

function PlayState:update(dt)

	if love.keyboard.wasPressed('tab') then
		gStateMachine:change('pause',{
			bird=self.bird,
			pipePairs=self.pipePairs,
			score=self.score,
			timer=self.timer
		})
	end

	self.timer=self.timer+dt

	if self.timer>1.5 then
		
		--Here we randomized the gap to generate more difficulty 
		gap=100+math.random(-20,10)
		local y=math.max(-PIPE_HEIGHT + 10, 
            math.min(self.lastY + math.random(-20, 20), VIRTUAL_HEIGHT - gap - PIPE_HEIGHT))
		self.lastY=y

		table.insert(self.pipePairs,PipePair(y,gap))

		self.timer=math.random(-2,0)
	end

	for k,pair in pairs(self.pipePairs) do
		if not pair.scored then
			if pair.x+PIPE_WIDTH<self.bird.x then
				self.score=self.score+1
				pair.scored=true
				sounds['score']:play()
			end
		end 
		pair:update(dt)
	end


	for k,pair in pairs(self.pipePairs) do
		if pair.remove then
			table.remove(self.pipePairs,k)
		end
	end

	self.bird:update(dt)

	for k, pair in pairs (self.pipePairs) do
		for l,pipe in pairs(pair.pipes) do
			if self.bird:collides(pipe) then

				sounds['explosion']:play()
				sounds['hurt']:play()
				gStateMachine:change('score',{score=self.score})
			end
		end
	end

	if self.bird.y>VIRTUAL_HEIGHT-15 then

		sounds['explosion']:play()
		sounds['hurt']:play()

		gStateMachine:change('score',{score=self.score})
	end
end

function PlayState:render()
	for k,pair in pairs(self.pipePairs) do
		pair:render()
	end

	love.graphics.setFont(flappyFont)
	love.graphics.print('Score: '..tostring(self.score),8,8)
	
	self.bird:render()
end

function PlayState:enter(params)
    -- if we're coming from death, restart scrolling
    scrolling = true
    love.audio.play(sounds['music'])
    self.bird = params.bird
    self.pipePairs = params.pipePairs
    self.score = params.score
    self.timer = params.timer
end