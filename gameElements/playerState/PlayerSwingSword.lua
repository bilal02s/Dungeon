PlayerSwingSword = Class{__includes = BaseState}

function PlayerSwingSword:init(player)
	self.player = player

	self.speed = 300

	self.scale = player.scale
	self.height = player.height
	self.width = player.width

	self.image = player.images['walk']
	self.frame = player.frames['walk']

	self.animation = AnimationState(player.animation()['walk'])
	self.oldFrame = 1
end

function PlayerSwingSword:open(param)
	self.x = param.x
	self.y = param.y
	self.direction = param.direction
	self.animation:change(param.direction)
	self.animation:refresh()
end

function PlayerSwingSword:update(dt)
	if self.oldFrame ~= self.animation.current.currentFrame then
		self.oldFrame = self.animation.current.currentFrame

		if self.oldFrame == 1 then
			self.player:change('walk', {x = self.x, y = self.y, direction = self.direction})
		end
	end

	self.animation:update(dt)
end

function PlayerSwingSword:draw()
	love.graphics.draw(images[self.image], frames[self.frame][self.animation:getCurrentFrame()], self.x, self.y, 0, self.scale, self.scale)
end
