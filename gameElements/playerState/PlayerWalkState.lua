PlayerWalkState = Class{__includes = BaseState}

function PlayerWalkState:init(player, playState)
	self.player = player
	self.playState = playState

	self.speed = 200

	self.scale = player.scale
	self.height = player.height
	self.width = player.width

	self.image = player.images['walk']
	self.frame = player.frames['walk']

	self.animation = AnimationState(player.animation()['walk'])
	self.hurtBox = player.hurtBoxes['walk']
	self.onCollide = {
		['right'] = function(block) self.x = block.x - self.width end,
		['left'] = function(block) self.x = block.x + block.width end,
		['up'] = function(block) self.y = block.y + block.height - 20 end,
		['down'] = function(block) self.y = block.y - self.height - 10 end,
	}
end

function PlayerWalkState:open(param)
	self.x = param.x
	self.y = param.y
	self.direction = param.direction
	self.animation:change(param.direction)
	self.currentRoom = param.currentRoom
	local currentRoom = self.currentRoom
	self.offsetX = currentRoom.initialX + currentRoom.offsetX
	self.offsetY = currentRoom.initialY + currentRoom.offsetY
	self.quadTree = currentRoom.quadTree
end

function PlayerWalkState:update(dt)
	if not (love.keyboard.isDown('left') or love.keyboard.isDown('up') or love.keyboard.isDown('right') or love.keyboard.isDown('down')) then
		self.player:change('idle', {x = self.x, y = self.y, direction = self.direction, currentRoom = self.currentRoom})
		return nil
	end

	self.up, self.down, self.left, self.right = checkCollision(self:hurtBox(), self.quadTree:query(self:hurtBox()), self.onCollide, self)

	if love.keyboard.isDown('up') and not self.up then
		self.y = self.y - self.speed*dt
		self.direction = 'up'
		self.animation:change('up')
	end
	if love.keyboard.isDown('right') and not self.right then
		self.x = self.x + self.speed*dt
		self.direction = 'right'
		self.animation:change('right')
	end
	if love.keyboard.isDown('down') and not self.down then
		self.y = self.y + self.speed*dt
		self.direction = 'down'
		self.animation:change('down')
	end
	if love.keyboard.isDown('left') and not self.left then
		self.x = self.x - self.speed*dt
		self.direction = 'left'
		self.animation:change('left')
	end

	if love.keyboard.wasPressed('space') then
		self.player:change('swingSword', {x = self.x, y = self.y, direction = self.direction, currentRoom = self.currentRoom})
	end

	self.animation:update(dt)
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

function AABB(entity1, entity2, p) -- p : precision
	if entity1.x + entity1.width - p < entity2.x or entity1.x + p > entity2.x + entity2.width or
		entity1.y + entity1.height - p < entity2.y or entity1.y + p > entity2.y + entity2.height then
		return false
	end

	return true
end

function checkCollision(entity, objects, onCollide, self)
	local down
	local up
	local left
	local right

	for k, block in pairs(objects) do
		if AABB(entity, block.box, 0) then
			local result = collision(entity, block.box, onCollide)
			block:onCollide(self)

			if result == 'down' then
				down = true
			elseif result == 'right' then
				right = true
			elseif result == 'left' then
				left = true
			elseif result == 'up' then
				up = true
			end
		end
	end

	return up, down, left, right
end

function collision(entity1, entity2, onCollide)
	local w = (entity1.width + entity2.width) * 0.5
	local h = (entity1.height + entity2.height) * 0.5
	local deltaX = (entity2.x + entity2.width/2) - (entity1.x + entity1.width/2)
	local deltaY = (entity2.y + entity2.height/2) - (entity1.y + entity1.height/2)
	local dx = w - math.abs(deltaX)
	local dy = h - math.abs(deltaY)

	if dx > dy then
		if deltaY > 0 then
			onCollide['down'](entity2)
			return 'down'
		else
			onCollide['up'](entity2)
			return 'up'
		end
	elseif dx < dy then
		if deltaX > 0 then
			onCollide['right'](entity2)
			return 'right'
		else
			onCollide['left'](entity2)
			return 'left'
		end
	end
end

function PlayerWalkState:draw()
	love.graphics.draw(images[self.image], frames[self.frame][self.animation:getCurrentFrame()], self.x, self.y - 20, 0, self.scale, self.scale)
	love.graphics.rectangle('line', self.x, self.y + 20, self.width, self.height - 10)
end
