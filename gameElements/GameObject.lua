GameObject = Class{}

function GameObject:init(pos, def)
	self.scale = def.scale
	self.height = def.height * self.scale
	self.width = def.width * self.scale
	self.x = pos[1] + (def.xOffset or 0)
	self.y = pos[2] + (def.yOffset or 0)

	self.image = def.image
	self.quad = def.quad
	self.animation = AnimationState(def.animation())
	self.state = def.state
	self.animation:change(self.state)
	self.box = def.box(self)
	self.collidable = def.collidable
	self.onCollide = def.onCollide
end

function Box(x, y, width, height)
	return {
		x = x,
		y = y,
		width = width,
		height = height,
	}
end

function GameObject:update(dt)
	self.animation:update(dt)
end

function GameObject:draw()
	love.graphics.draw(images[self.image], frames[self.quad][self.animation:getCurrentFrame()], self.x, self.y, 0, self.scale, self.scale)
end
