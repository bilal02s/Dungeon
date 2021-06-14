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
	self.damage = originalEntity.damage
	self.stateDecision = originalEntity.stateDecision['follow']
	self.animation = AnimationState(originalEntity.animation()['follow'])
	self.currentRoom = originalEntity.currentRoom
	self.quadTree = self.currentRoom.quadTree
	self.player = originalEntity.player
	self.id = originalEntity.id

	self.duration = math.random(2, 4)
	self.timer = 0

	self.onCollide = {
		['right'] = function(block) self.x = block.x - 3*self.width/4 end,
		['left'] = function(block) self.x = block.x + block.width - self.width/4 end,
		['up'] = function(block) self.y = block.y + block.height - self.height/2 end,
		['down'] = function(block) self.y = block.y - self.height end,
	}

	self.path = {}
end

function EntityFollowState:open(param)
	self.x = param.x
	self.y = param.y
	self.animation:change(param.direction)

	if self.currentRoom.visibilityGraph[self.id] then
		self.visibilityGraph = self.currentRoom.visibilityGraph[self.id]
	else
		local box = self:box()
		self.visibilityGraph = VisibilityGraph()
		self.visibilityGraph:setEntityDimentions(box.width, box.height)

		for k, object in pairs(self.currentRoom.objects) do
			self.visibilityGraph:insertObject(object)
		end

		self.visibilityGraph:createGraph()
		self.currentRoom.visibilityGraph[self.id] = self.visibilityGraph
	end
end

function EntityFollowState:update(dt)
if love.keyboard.isDown('p') then goto iAmBored end
	local src = {self.x + self.width/4, self.y + self.width/2}
	local dest = {self.player.current.x, self.player.current.y}
	local adjacencyList = self.visibilityGraph:getGraph(src, dest); self.graph = adjacencyList
	self.path = findPath(adjacencyList, src, dest)

	if #self.path <= 1 then
		return nil
	end

	local node1 = self.path[1]
	local node2 = self.path[2]
	local angle = getVectAngle({node2[1] - node1[1], node2[2] - node1[2]})
	self.vx = self.speed * cos(angle)
	self.vy = self.speed * sin(angle)

	self.x = self.x + self.vx*dt
	self.y = self.y + self.vy*dt

	if abs(self.vx) > abs(self.vy) then
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

	self.up, self.down, self.left, self.right = checkEntityCollision(self, self.quadTree:query(self:box()), self.currentRoom.entities, self.onCollide)

	self.animation:update(dt)

	::iAmBored::
end

function printTable(t, i, j)
	local x = i
	local y = j

	for k1, stuff1 in pairs(t) do
		if type(stuff1) == 'table' then
			x = i
			y = y + 20
			love.graphics.print(tostring(tuple(k1))..':', x, y)
			x = x + 80
			printTable(stuff1, x, y)
			if type(stuff1[1]) == 'table' then
				y = y + 20*#stuff1
			end
		else
			love.graphics.print(tostring(k1)..':'..tostring(stuff1), x, y)
			x = x + 200
		end
	end
end

function tuple(vect)
	if type(vect) ~= 'table' then return vect end
	return tostring(vect[1])..', '..tostring(vect[2])
end

function EntityFollowState:draw()
	love.graphics.draw(images[self.image], frames[self.quad][self.animation:getCurrentFrame()], self.x, self.y, 0, self.scale, self.scale)

	--[[if self.graph then for vertex, nodes in pairs(self.graph) do
		love.graphics.setFont(fonts['zeldaS'])
		--printTable(self.graph, self.currentRoom.totalOffsetX, self.currentRoom.totalOffsetY - 80)
		for k, node in pairs(nodes) do
			love.graphics.line(vertex[1], vertex[2], node[1], node[2])
		end
	end end]]

	local box = self:box()
	love.graphics.rectangle('line', box.x, box.y, box.width, box.height)
end
