PlayerWalkState = Class{__includes = BaseState}

function PlayerWalkState:init(player, playState)
	self.player = player
	self.playState = playState

	self.speed = 200

	self.scale = player.scale
	self.height = player.height
	self.width = player.width
	self.health = player.health

	self.image = player.images['walk']
	self.frame = player.frames['walk']

	self.headAnimation = AnimationState(player.headAnimation()['walk'])
	self.bodyAnimation = AnimationState(player.bodyAnimation()['walk'])
	self.hurtBox = player.hurtBoxes['walk']
	self.hurt = player.hurt

	self.onCollide = {
		['right'] = function(block) self.x = block.x - self.width end,
		['left'] = function(block) self.x = block.x + block.width end,
		['up'] = function(block) self.y = block.y + block.height end,
		['down'] = function(block) self.y = block.y - self.height end,
	}
end

function PlayerWalkState:open(param)
	self.x = param.x
	self.y = param.y
	self.health = param.health or self.health
	self.direction = param.direction
	self.headAnimation:change(param.direction)
	self.bodyAnimation:change(param.direction)
	self.currentRoom = param.currentRoom
	local currentRoom = self.currentRoom
	self.offsetX = currentRoom.initialX + currentRoom.offsetX
	self.offsetY = currentRoom.initialY + currentRoom.offsetY
	self.quadTree = currentRoom.quadTree
	self.entities = currentRoom.entities
end

function PlayerWalkState:update(dt)
	if not (love.keyboard.isDown('left') or love.keyboard.isDown('up') or love.keyboard.isDown('right') or love.keyboard.isDown('down')) then
		self.player:change('idle', {x = self.x, y = self.y, direction = self.direction, movement = self.movement, currentRoom = self.currentRoom, health = self.health})
		return nil
	end

	if love.keyboard.isDown('up') and not self.up then
		self.y = self.y - self.speed*dt
		self.movement = 'up'
		self.direction = 'up'
		self.headAnimation:change('up')
		self.bodyAnimation:change('up')
	end
	if love.keyboard.isDown('right') and not self.right then
		self.x = self.x + self.speed*dt
		self.movement = 'right'
		self.direction = 'right'
		self.headAnimation:change('right')
		self.bodyAnimation:change('right')
	end
	if love.keyboard.isDown('down') and not self.down then
		self.y = self.y + self.speed*dt
		self.movement = 'down'
		self.direction = 'down'
		self.headAnimation:change('down')
		self.bodyAnimation:change('down')
	end
	if love.keyboard.isDown('left') and not self.left then
		self.x = self.x - self.speed*dt
		self.movement = 'left'
		self.direction = 'left'
		self.headAnimation:change('left')
		self.bodyAnimation:change('left')
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

	self.up, self.down, self.left, self.right = checkPlayerCollision(self, self.quadTree:query(self:hurtBox()), self.entities, self.onCollide)

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
	self.bodyAnimation:update(dt)
end

function PlayerWalkState:shift(direction)
	if direction == 'right' then
		self.playState:change('shift', {nextX = 1, nextY = 0, direction = 'right'})
	elseif direction == 'left' then
		self.playState:change('shift', {nextX = -1, nextY = 0, direction = 'left'})
	elseif direction == 'up' then
		self.playState:change('shift', {nextX = 0, nextY = -1, direction = 'up'})
	elseif direction == 'down' then
		self.playState:change('shift', {nextX = 0, nextY = 1, direction = 'down'})
	end
end

function detectCollidedBlock(objects, i, j)
	for m = j, 1, -1 do
		for n = i, 1, -1 do
			if objects[m][n] then
				return objects[m][n]
			end
		end
	end
end

function AABB(entity1, entity2)
	if entity1.x + entity1.width < entity2.x or entity1.x > entity2.x + entity2.width or
		entity1.y + entity1.height < entity2.y or entity1.y > entity2.y + entity2.height then
		return false
	end

	return true
end

function checkPlayerCollision(player, objects, otherEntities, onCollide)
	local box = player:hurtBox()
	local down
	local up
	local left
	local right

	for k, block in pairs(objects) do
		if AABB(box, block.box) then
			local result = collision(box, block.box)
			block:onCollide(player)

			if result == 'down' then
				onCollide['down'](block.box)
				down = true
			elseif result == 'right' then
				onCollide['right'](block.box)
				right = true
			elseif result == 'left' then
				onCollide['left'](block.box)
				left = true
			elseif result == 'up' then
				onCollide['up'](block.box)
				up = true
			end
		end
	end

	for k, other in pairs(otherEntities) do
		local current = other.current
		if AABB(box, current:box()) then
			player:hurt(current.damage)
			local result = collision(box, current:box())

			if result == 'down' then
				current.onCollide['up'](box)
				down = true
			elseif result == 'right' then
				current.onCollide['left'](box)
				right = true
			elseif result == 'left' then
				current.onCollide['right'](box)
				left = true
			elseif result == 'up' then
				current.onCollide['down'](box)
				up = true
			end
		end
	end

	return up, down, left, right
end

function collision(entity1, entity2)
	local w = (entity1.width + entity2.width) * 0.5
	local h = (entity1.height + entity2.height) * 0.5
	local deltaX = (entity2.x + entity2.width/2) - (entity1.x + entity1.width/2)
	local deltaY = (entity2.y + entity2.height/2) - (entity1.y + entity1.height/2)
	local dx = w - math.abs(deltaX)
	local dy = h - math.abs(deltaY)

	if dx > dy then
		if deltaY > 0 then
			return 'down'
		else
			return 'up'
		end
	elseif dx < dy then
		if deltaX > 0 then
			return 'right'
		else
			return 'left'
		end
	end
end

function PlayerWalkState:draw()
	love.graphics.draw(images[self.image], frames[self.frame][self.bodyAnimation:getCurrentFrame()], self.x, self.y, 0, self.scale, self.scale)
	love.graphics.draw(images[self.image], frames[self.frame][self.headAnimation:getCurrentFrame()], self.x - 4.5, self.y - 32, 0, self.scale, self.scale)
	love.graphics.rectangle('line', self.x, self.y, self.width, self.height)
end
