QuadTree = Class{}

function QuadTree:init(boundaries, n)
	self.boundaries = boundaries
	self.capacity = n
	self.divided = false
	self.objects = {}
end

function QuadTree:contains(object)
	return (object.x >= self.boundaries.x and object.x + object.width <= self.boundaries.x + self.boundaries.width and
		object.y >= self.boundaries.y and object.y + object.height <= self.boundaries.y + self.boundaries.height)
end

keys = {}
function QuadTree:divide()
	local range = self.boundaries
	local tl = {x = range.x, y = range.y, width = range.width/2, height = range.height/2}
	local tr = {x = range.x + range.width/2, y = range.y, width = range.width/2, height = range.height/2}
	local dr = {x = range.x + range.width/2, y = range.y + range.height/2, width = range.width/2, height = range.height/2}
	local dl = {x = range.x, y = range.y + range.height/2, width = range.width/2, height = range.height/2}
	self.topLeft = QuadTree(tl, self.capacity)
	self.topRight = QuadTree(tr, self.capacity)
	self.downRight = QuadTree(dr, self.capacity)
	self.downLeft = QuadTree(dl, self.capacity)
	self.divided = true

	local toRemove = {}
	for k, v in pairs(self.objects) do
		if self.topLeft:contains(v) then
			self.topLeft:insert(v)
			self.objects[k] = nil
		elseif self.topRight:contains(v) then
			self.topRight:insert(v)
			self.objects[k] = nil
		elseif self.downRight:contains(v) then
			self.downRight:insert(v)
			self.objects[k] = nil
		elseif self.downLeft:contains(v) then
			self.downLeft:insert(v)
			self.objects[k] = nil
		end
	end
end

function QuadTree:insert(object)
	if not self.divided then
		table.insert(self.objects, object)
		if #self.objects > self.capacity then
			self:divide()
		end
	else
		if self.topLeft:contains(object) then
			self.topLeft:insert(object)
		elseif self.topRight:contains(object) then
			self.topRight:insert(object)
		elseif self.downRight:contains(object) then
			self.downRight:insert(object)
		elseif self.downLeft:contains(object) then
			self.downLeft:insert(object)
		else
			table.insert(self.objects, object)
		end
	end
end

function QuadTree:intersect(range)
	return (range.x + range.width >= self.boundaries.x and range.x <= self.boundaries.x + self.boundaries.width and
		range.y + range.height >= self.boundaries.y and range.y <= self.boundaries.y + self.boundaries.height)
end

function QuadTree:query(range, points)
	local points = points
	if not points then
		points = {}
	end

	if self:intersect(range) then
		for k, v in pairs(self.objects) do
			table.insert(points, v)
		end
	else
		return {}
	end

	if self.divided then
		self.topLeft:query(range, points)
		self.topRight:query(range, points)
		self.downRight:query(range, points)
		self.downLeft:query(range, points)
	end

	return points
end

function QuadTree:draw()
	love.graphics.rectangle('line', self.boundaries.x, self.boundaries.y, self.boundaries.width, self.boundaries.height)

	if self.divided then
		self.topLeft:draw()
		self.topRight:draw()
		self.downRight:draw()
		self.downLeft:draw()
	end
end
