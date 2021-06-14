PlayerIdleState = Class{__includes = BaseState}

function PlayerIdleState:init(player)
	self.player = player

	self.speed = 300

	self.scale = player.scale or 2.5
	self.height = player.height or 40
	self.width = player.width or 40
	self.health = player.health

	self.image = player.images['idle']
	self.frame = player.frames['idle']

	self.headAnimation = AnimationState(player.headAnimation()['idle'])
	self.bodyAnimation = AnimationState(player.bodyAnimation()['idle'])
	self.hurtBox = player.hurtBoxes['idle']
	self.hurt = player.hurt

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
	self.health = param.health or self.health
	self.direction = param.direction
	self.currentRoom = param.currentRoom

	self.bodyAnimation:change('down')
	self.headAnimation:change(self.direction)
end

function PlayerIdleState:update(dt)
	self:checkCollision()
	self.direction = 'down'
	self.headAnimation:change('down')

	if love.keyboard.wasPressed('up') then
		self.player:change('walk', {x = self.x, y = self.y, direction = 'up', currentRoom = self.currentRoom, health = self.health})
	elseif love.keyboard.wasPressed('right') then
		self.player:change('walk', {x = self.x, y = self.y, direction = 'right', currentRoom = self.currentRoom, health = self.health})
	elseif love.keyboard.wasPressed('down') then
		self.player:change('walk', {x = self.x, y = self.y, direction = 'down', currentRoom = self.currentRoom, health = self.health})
	elseif love.keyboard.wasPressed('left') then
		self.player:change('walk', {x = self.x, y = self.y, direction = 'left', currentRoom = self.currentRoom, health = self.health})
	end

	if love.keyboard.isDown('w') then
		self.direction = 'up'
		self.headAnimation:change('up')
	end
	if love.keyboard.isDown('a') then
		self.direction = 'left'
		self.headAnimation:change('left')
	end
	if love.keyboard.isDown('s') then
		self.direction = 'down'
		self.headAnimation:change('down')
	end
	if love.keyboard.isDown('d') then
		self.direction = 'right'
		self.headAnimation:change('right')
	end

	if love.keyboard.wasPressed('space') then
		local angle
		local x
		local y
		if self.direction == 'right' then
			angle = 0
			x = self.x + self.width
			y = self.y + self.height/2
		elseif self.direction == 'down' then
			angle = math.pi/2
			x = self.x + self.width/2
			y = self.y + self.height
		elseif self.direction == 'left' then
			angle = math.pi
			x = self.x - self.width
			y = self.y + self.height/2
		elseif self.direction == 'up' then
			angle = 3*math.pi/2
			x = self.x + self.width/2
			y = self.y - self.height
		end
		table.insert(self.currentRoom.balls, Ball(x, y, angle, self.currentRoom))
	end

	self.headAnimation:update(dt)
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
	love.graphics.draw(images[self.image], frames[self.frame][self.bodyAnimation:getCurrentFrame()], self.x, self.y, 0, self.scale, self.scale)
	love.graphics.draw(images[self.image], frames[self.frame][self.headAnimation:getCurrentFrame()], self.x - 4.5, self.y - 31, 0, self.scale, self.scale)
	love.graphics.rectangle('line', self.x, self.y, self.width, self.height)
end
