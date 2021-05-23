Entity = Class{__includes = PlayerState}

function Entity:init(param, pos, player, currentRoom)
	PlayerState.init(self, param.states(self))
	self.scale = param.scale
	self.width = param.width * self.scale
	self.height = param.height * self.scale
	self.image = param.image
	self.quad = param.quad
	self.speed = param.speed
	self.health = param.health
	self.animation = param.animation
	self.box = param.box
	self.hurt = param.hurt
	self.stateDecision = param.stateDecision
	self.player = player
	self.currentRoom = currentRoom

	self:change('walk', {
		x = currentRoom.totalOffsetX + pos[1] * tileLength,
		y = currentRoom.totalOffsetY + pos[2] * tileLength,
		direction = 'down',
	})
end


