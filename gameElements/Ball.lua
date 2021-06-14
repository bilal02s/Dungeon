Ball = Class{}

local cos = math.cos
local sin = math.sin

function Ball:init(x, y, angle, room)
	self.speed = 450
	self.radius = 7
	self.damage = 5
	self.vx = self.speed*cos(angle)
	self.vy = self.speed*sin(angle)
	self.currentRoom = room
	self.x = x
	self.y = y
	self.inPlay = true
end

function Ball:boundingBox()
	return {x = self.x - 0.5, y = self.y - 0.5, width = 1, height = 1}
end

function Ball:update(dt)
	self.x = self.x + self.vx*dt
	self.y = self.y + self.vy*dt

	local box = self:boundingBox()
	for k, object in pairs(self.currentRoom.quadTree:query(box)) do
		if AABB(box, object.box) then
			self.inPlay = false
		end
	end

	for k, entity in pairs(self.currentRoom.entities) do
		if AABB(box, entity.current:box()) then
			self.inPlay = false
		end
	end

	if AABB(box, self.currentRoom.player.current:hurtBox()) then
		self.inPlay = false
	end
end

function Ball:draw()
	love.graphics.setColor(0.8, 0.8, 0.8, 1)
	love.graphics.circle('fill', self.x, self.y, self.radius)
	love.graphics.setColor(0, 0, 0, 1)
	love.graphics.circle('line', self.x, self.y, self.radius)
	love.graphics.setColor(1, 1, 1, 1)
end
