PlayerWalkState = Class{__includes = BaseState}

function PlayerWalkState:init(playState, player)
	self.player = player
	self.playState = playState

	self.speed = 200

	self.scale = player.scale
	self.height = player.height
	self.width = player.width

	self.image = player.images['walk']
	self.frame = player.frames['walk']

	self.animation = AnimationState(player.animation()['walk'])
end

function PlayerWalkState:open(param)
	self.x = param.x
	self.y = param.y
	self.direction = param.direction
	self.animation:change(param.direction)
end

function PlayerWalkState:update(dt)
	if (not love.keyboard.isDown('left')) and (not love.keyboard.isDown('up')) and (not love.keyboard.isDown('right')) and (not love.keyboard.isDown('down')) then
		self.player:change('idle', {x = self.x, y = self.y, direction = self.direction})
	end

	if love.keyboard.isDown('up') then
		self.y = self.y - self.speed*dt
		self.direction = 'up'
		self.animation:change('up')
	end
	if love.keyboard.isDown('right') then
		self.x = self.x + self.speed*dt
		self.direction = 'right'
		self.animation:change('right')
	end
	if love.keyboard.isDown('down') then
		self.y = self.y + self.speed*dt
		self.direction = 'down'
		self.animation:change('down')
	end
	if love.keyboard.isDown('left') then
		self.x = self.x - self.speed*dt
		self.direction = 'left'
		self.animation:change('left')
	end

	if love.keyboard.wasPressed('space') then
		self.player:change('swingSword', {x = self.x, y = self.y, direction = self.direction})
	end

	self.animation:update(dt)
end

function PlayerWalkState:draw()
	love.graphics.draw(images[self.image], frames[self.frame][self.animation:getCurrentFrame()], self.x, self.y, 0, self.scale, self.scale)
end
