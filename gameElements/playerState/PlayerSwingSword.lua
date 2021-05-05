PlayerSwingSword = Class{__includes = BaseState}

function PlayerSwingSword:init(player)
	self.player = player

	self.speed = 300

	self.scale = player.scale
	self.height = player.height
	self.width = player.width

	self.image = player.images['swingSword']
	self.frame = player.frames['swingSword']

	self.animation = AnimationState(player.animation()['swingSword'])
	self.hurtBox = player.hurtBoxes['swingSword']
	self.prevFrame = 1
end

function PlayerSwingSword:open(param)
	self.x = param.x
	self.y = param.y
	self.direction = param.direction
	self.animation:change(param.direction)
	self.animation:refresh()
	self.currentRoom = param.currentRoom
end

function PlayerSwingSword:update(dt)
	if self.prevFrame ~= self.animation.current.currentFrame then
		self.prevFrame = self.animation.current.currentFrame

		if self.prevFrame == 1 then
			self.player:change('walk', {x = self.x, y = self.y, direction = self.direction, currentRoom = self.currentRoom})
		end
	end

	self.animation:update(dt)
end

function PlayerSwingSword:draw()
	love.graphics.draw(images[self.image], frames[self.frame][self.animation:getCurrentFrame()], self.x - 20, self.y - 20, 0, self.scale, self.scale)
	love.graphics.rectangle('line', self.x, self.y, self.width, self.height)
end
