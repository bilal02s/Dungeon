EntityIdleState = Class{}

function EntityIdleState:init(originalEntity)
	self.originalEntity = originalEntity
	self.width = originalEntity.width
	self.height = originalEntity.height
	self.scale = originalEntity.scale
	self.image = originalEntity.image
	self.quad = originalEntity.quad
	self.box = originalEntity.box
	self.hurt = originalEntity.hurt
	self.stateDecision = originalEntity.stateDecision['idle']
	self.animation = AnimationState(originalEntity.animation()['idle'])
	self.currentRoom = self.currentRoom

	self.duration = math.random(1, 3)
	self.timer = 0
end

function EntityIdleState:open(param)
	self.x = param.x
	self.y = param.y
	self.direction = param.direction

	self.animation:change(self.direction)
end

function EntityIdleState:update(dt)
	self.timer = self.timer + dt

	if self.timer > self.duration then
		local state = self.stateDecision[math.random(#self.stateDecision)]
		self.originalEntity:change(state, {x = self.x, y = self.y, direction = self.direction})
	end

	self.animation:update(dt)
end

function EntityIdleState:draw()
	love.graphics.draw(images[self.image], frames[self.quad][self.animation:getCurrentFrame()], self.x, self.y, 0, self.scale, self.scale)
end
