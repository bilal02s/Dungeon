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
	self.hurtBox = player.hurtBoxes['walk']
	self.onCollide = {
		['right'] = function(entity, block) entity.x = block.x - entity.width end,
		['left'] = function(entity, block) entity.x = block.x + block.width end,
		['up'] = function(entity, block) entity.y = block.y + block.height end,
		['down'] = function(entity, block) entity.y = block.y - entity.height end,
	}
end

function PlayerWalkState:open(param)
	self.x = param.x
	self.y = param.y
	self.direction = param.direction
	self.animation:change(param.direction)
	self.currentRoom = param.currentRoom
end

function PlayerWalkState:update(dt)
	if (not love.keyboard.isDown('left')) and (not love.keyboard.isDown('up')) and (not love.keyboard.isDown('right')) and (not love.keyboard.isDown('down')) then
		self.player:change('idle', {x = self.x, y = self.y, direction = self.direction, currentRoom = self.currentRoom})
	end

	self.collisionV, self.collisionH = checkCollision(self:hurtBox(), self.currentRoom.structure, self.currentRoom.initialX, self.currentRoom.initialY, self.onCollide)

	if love.keyboard.isDown('up') and self.collisionV ~= 'up' then
		self.y = self.y - self.speed*dt
		self.direction = 'up'
		self.animation:change('up')
	end
	if love.keyboard.isDown('right') and self.collisionH ~= 'right' then
		self.x = self.x + self.speed*dt
		self.direction = 'right'
		self.animation:change('right')
	end
	if love.keyboard.isDown('down') and self.collisionV ~= 'down' then
		self.y = self.y + self.speed*dt
		self.direction = 'down'
		self.animation:change('down')
	end
	if love.keyboard.isDown('left') and self.collisionH ~= 'left' then
		self.x = self.x - self.speed*dt
		self.direction = 'left'
		self.animation:change('left')
	end

	if love.keyboard.wasPressed('space') then
		self.player:change('swingSword', {x = self.x, y = self.y, direction = self.direction, currentRoom = self.currentRoom})
	end

	if self.x > self.currentRoom.offsetX + 7*Width/8 then
		self.playState:change('shift', {nextX = 1, nextY = 0, direction = 'right'})
	elseif self.x < self.currentRoom.offsetX + 1*Width/8 then
		self.playState:change('shift', {nextX = -1, nextY = 0, direction = 'left'})
	end

	self.animation:update(dt)
end

function detectCollidedBlock(objects, i, j)
	for m = j, 1, -1 do
		for n = i, 1, -1 do
			if objects[j][i] then
				return objects[j][i]
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

function checkCollision(entity, objects, offsetX, offsetY, onCollide)
	local floor = math.floor
	local x1 = floor((entity.x - (offsetX or 0))/tileLength) + 1
	local y1 = floor((entity.y - (offsetY or 0))/tileLength) + 1
	local x2 = floor((entity.x + entity.width - (offsetX or 0))/tileLength) + 1
	local y2 = floor((entity.y + entity.height - (offsetY or 0))/tileLength) + 1

	local blocks = {
		detectCollidedBlock(objects, x1, y1),
		detectCollidedBlock(objects, x1, y2),
		detectCollidedBlock(objects, x2, y2),
		detectCollidedBlock(objects, x2, y1),
	}

	local resultH
	local resultV
	for k, block in pairs(blocks) do
		if block.collidable and AABB(entity, block) then
			local result = collision(entity, block, onCollide)

			if result == 'down' or result == 'up' then
				resultV = result
			elseif result == 'right' or result == 'left' then
				resultH = result
			end
		end
	end

	return resultV, resultH
end

function collision(entity1, entity2, onCollide)
	local w = (entity1.width + entity2.width) * 0.5
	local h = (entity1.height + entity2.height) * 0.5
	local deltaX = (entity2.x + entity2.width/2) - (entity1.x + entity1.width/2)
	local deltaY = (entity2.y + entity2.height/2) - (entity1.y + entity1.height/2)
	local dx = w - deltaX
	local dy = h - deltaY

	if dx > dy then
		if deltaY > 0 then
			onCollide['down'](entity1, entity2)
			return 'down'
		else
			onCollide['up'](entity1, entity2)
			return 'up'
		end
	else
		if deltaX > 0 then
			onCollide['right'](entity1, entity2)
			return 'right'
		else
			onCollide['left'](entity1, entity2)
			return 'left'
		end
	end
end

function PlayerWalkState:draw()
	love.graphics.draw(images[self.image], frames[self.frame][self.animation:getCurrentFrame()], self.x, self.y - 20, 0, self.scale, self.scale)
	love.graphics.print(tostring(self.collisionH)..tostring(self.collisionV), 100, 100)
	love.graphics.rectangle('line', self.x, self.y, self.width, self.height)
end
