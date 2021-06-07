EntityFollowState = Class{}

visibilityGraph = {}
local cos = math.cos
local sin = math.sin
local abs = math.abs

function EntityFollowState:init(originalEntity)
	self.originalEntity = originalEntity
	self.width = originalEntity.width
	self.height = originalEntity.height
	self.scale = originalEntity.scale
	self.image = originalEntity.image
	self.quad = originalEntity.quad
	self.box = originalEntity.box
	self.hurt = originalEntity.hurt
	self.speed = originalEntity.speed
	self.stateDecision = originalEntity.stateDecision['follow']
	self.animation = AnimationState(originalEntity.animation()['follow'])
	self.currentRoom = originalEntity.currentRoom
	self.quadTree = self.currentRoom.quadTree
	self.player = originalEntity.player
	self.id = originalEntity.id

	self.duration = math.random(2, 4)
	self.timer = 0

	self.onCollide = {
		['right'] = function(block) self.x = block.x - self.width end,
		['left'] = function(block) self.x = block.x + block.width end,
		['up'] = function(block) self.y = block.y + block.height - self.height/2 end,
		['down'] = function(block) self.y = block.y - self.height end,
	}

	if visibilityGraph[self.id] then
		self.visibilityGraph = visibilityGraph[self.id]
	else
		self.visibilityGraph = VisibilityGraph()
		self.visibilityGraph:setEntityDimentions(self.width, self.height)
		for k, object in pairs(self.currentRoom.objects) do
			self.visibilityGraph:insertObject(object)
		end
		self.visibilityGraph:createGraph()
		visibilityGraph[self.id] = self.visibilityGraph
	end
	self.path = {}
end

function EntityFollowState:open(param)
	self.x = param.x
	self.y = param.y
	self.animation:change(param.direction)
end

function EntityFollowState:update(dt)
	local src = {self.x, self.y}
	local dest = {self.player.current.x, self.player.current.y}
	local adjacencyList = self.visibilityGraph:getGraph(src, dest)
	self.path = findPath(adjacencyList, src, dest); self.graph = adjacencyList

	if #self.path > 1 then
		local node1 = self.path[1]
		local node2 = self.path[2]
		local angle = getVectAngle({node2[1] - node1[1], node2[2] - node1[2]})
		self.vx = self.speed * cos(angle)
		self.vy = self.speed * sin(angle)

		self.x = self.x + self.vx*dt
		self.y = self.y + self.vy*dt

		if abs(self.vx) > 2*abs(self.vy) then
			if self.vx > 0 then
				self.direction = 'right'
				self.animation:change('right')
			else
				self.direction = 'left'
				self.animation:change('left')
			end
		else
			if self.vy > 0 then
				self.direction = 'down'
				self.animation:change('down')
			else
				self.direction = 'up'
				self.animation:change('up')
			end
		end
	end

	self.animation:update(dt)
end

function EntityFollowState:draw()
	love.graphics.draw(images[self.image], frames[self.quad][self.animation:getCurrentFrame()], self.x, self.y, 0, self.scale, self.scale)
	if self.graph then self.visibilityGraph:draw(self.graph)
	end
end
