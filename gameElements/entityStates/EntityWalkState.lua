EntityWalkState = Class{}

function EntityWalkState:init(originalEntity)
	self.originalEntity = originalEntity
	self.width = originalEntity.width
	self.height = originalEntity.height
	self.scale = originalEntity.scale
	self.image = originalEntity.image
	self.quad = originalEntity.quad
	self.box = originalEntity.box
	self.hurt = originalEntity.hurt
	self.speed = originalEntity.speed
	self.stateDecision = originalEntity.stateDecision['walk']
	self.animation = AnimationState(originalEntity.animation()['walk'])
	self.currentRoom = originalEntity.currentRoom
	self.quadTree = self.currentRoom.quadTree
	self.player = originalEntity.player

	self.duration = math.random(2, 4)
	self.timer = 0

	self.onCollide = {
		['right'] = function(block) self.x = block.x - self.width end,
		['left'] = function(block) self.x = block.x + block.width end,
		['up'] = function(block) self.y = block.y + block.height - self.height/2 end,
		['down'] = function(block) self.y = block.y - self.height end,
	}
end

function getDirectionAI(entity1, entity2)
	local x = entity2.x - entity1.x
	local y = entity2.y - entity2.y
	local abs = math.abs

	if abs(x) > abs(y) then
		if x > 0 then
			return 0
		else
			return 180
		end
	else
		if y > 0 then
			return -90
		else
			return 90
		end
	end
end

function EntityWalkState:open(param)
	self.x = param.x
	self.y = param.y

	local rad = math.rad
	local playerDirection = getDirectionAI(self, self.player.current)
	local angles = {0, 90, 180, -90, playerDirection, playerDirection}

	self.angle = angles[math.random(#angles)]
	self.vx = self.speed * math.cos(rad(self.angle))
	self.vy = self.speed * math.sin(rad(self.angle))

	self:resetDirection()
end

function EntityWalkState:resetDirection()
	local abs = math.abs

	if abs(self.vx) > abs(self.vy) then
		if self.vx > 0 then
			self.direction = 'right'
		else
			self.direction = 'left'
		end
	else
		if self.vy > 0 then
			self.direction = 'down'
		else
			self.direction = 'up'
		end
	end

	self.animation:change(self.direction)
end

function EntityWalkState:update(dt)
	self.timer = self.timer + dt

	if self.timer > self.duration then
		local state = self.stateDecision[math.random(#self.stateDecision)]
		self.originalEntity:change(state, {x = self.x, y = self.y, direction = self.direction})
		return nil
	end

	self.up, self.down, self.left, self.right = checkCollision(self:box(), self.quadTree:query(self:box()), self.onCollide, self)

	if self.up or self.down then
		self.vy = -self.vy
		self:resetDirection()
	end
	if self.left or self.right then
		self.vx = -self.vx
		self:resetDirection()
	end

	self.x = self.x + self.vx*dt
	self.y = self.y + self.vy*dt

	self.animation:update(dt)
end

function EntityWalkState:draw()
	love.graphics.draw(images[self.image], frames[self.quad][self.animation:getCurrentFrame()], self.x, self.y, 0, self.scale, self.scale)
end

--[[42020097:14.6
42020037:18.2
41929764:12.8]]
