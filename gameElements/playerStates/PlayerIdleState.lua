PlayerIdleState = Class{__includes = BaseState}

function PlayerIdleState:init(player)
	self.player = player

	self.speed = 300

	self.scale = player.scale or 2.5
	self.height = player.height or 40
	self.width = player.width or 40

	self.image = player.images['idle']
	self.frame = player.frames['idle']

	self.animation = AnimationState(player.animation()['idle'])
	self.hurtBox = player.hurtBoxes['idle']

	self.onCollide = {
		['right'] = function(block) self.x = block.x - self.width end,
		['left'] = function(block) self.x = block.x + block.width end,
		['up'] = function(block) self.y = block.y + block.height - 20 end,
		['down'] = function(block) self.y = block.y - self.height - 5 end,
	}
end

function PlayerIdleState:open(param)
	self.x = param.x
	self.y = param.y
	self.direction = param.direction
	self.currentRoom = param.currentRoom

	self.animation:change(self.direction)
end

function PlayerIdleState:update(dt)
	self:checkCollision()

	if love.keyboard.wasPressed('up') then
		self.player:change('walk', {x = self.x, y = self.y, direction = 'up', currentRoom = self.currentRoom})
	elseif love.keyboard.wasPressed('right') then
		self.player:change('walk', {x = self.x, y = self.y, direction = 'right', currentRoom = self.currentRoom})
	elseif love.keyboard.wasPressed('down') then
		self.player:change('walk', {x = self.x, y = self.y, direction = 'down', currentRoom = self.currentRoom})
	elseif love.keyboard.wasPressed('left') then
		self.player:change('walk', {x = self.x, y = self.y, direction = 'left', currentRoom = self.currentRoom})
	end

	if love.keyboard.wasPressed('space') then
		self.player:change('swingSword', {x = self.x, y = self.y, direction = self.direction, currentRoom = self.currentRoom})
	end
end

function PlayerIdleState:checkCollision()
	for k, other in pairs(self.currentRoom.entities) do
		local current = other.current
		local box = self:hurtBox()
		if AABB(box, current:box()) then
			local result = collision(box, current:box())

			if result == 'down' then
				current.onCollide['up'](box)
			elseif result == 'right' then
				current.onCollide['left'](box)
			elseif result == 'left' then
				current.onCollide['right'](box)
			elseif result == 'up' then
				current.onCollide['down'](box)
			end
		end
	end
end

function PlayerIdleState:draw()
	love.graphics.draw(images[self.image], frames[self.frame][self.animation:getCurrentFrame()], self.x, self.y - 20, 0, self.scale, self.scale)
	love.graphics.rectangle('line', self.x, self.y + 20, self.width, self.height - 10)
end
