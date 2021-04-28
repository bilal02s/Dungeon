PlayerIdleState = Class{__includes = BaseState}

function PlayerIdleState:init(player)
	self.player = player

	self.speed = 300

	self.scale = player.scale
	self.height = player.height
	self.width = player.width

	self.image = player.images['idle']
	self.frame = player.frames['idle']

	self.animation = AnimationState(player.animation()['idle'])
end

function PlayerIdleState:open(param)
	self.x = param.x
	self.y = param.y
	self.direction = param.direction
end

function PlayerIdleState:update(dt)
	if love.keyboard.wasPressed('up') then
		self.player:change('walk', {x = self.x, y = self.y, direction = 'up'})
	elseif love.keyboard.wasPressed('right') then
		self.player:change('walk', {x = self.x, y = self.y, direction = 'right'})
	elseif love.keyboard.wasPressed('down') then
		self.player:change('walk', {x = self.x, y = self.y, direction = 'down'})
	elseif love.keyboard.wasPressed('left') then
		self.player:change('walk', {x = self.x, y = self.y, direction = 'left'})
	end

	if love.keyboard.wasPressed('space') then
		self.player:change('swingSword', {x = self.x, y = self.y, direction = self.direction})
	end
end

function PlayerIdleState:draw()
	love.graphics.draw(images[self.image], frames[self.frame][self.animation:getCurrentFrame()], self.x, self.y, 0, self.scale, self.scale)
end