Room = Class{}

function Room:init(structure, objects, entities, offset, player)
	self.col, self.row = getRoomSize(structure)
	self.player = player
	self.initialX = (Width - self.col*tileLength)/2
	self.initialY = (Height - self.row*tileLength)/2
	self.offsetX = offset[1]
	self.offsetY = offset[2]
	self.totalOffsetX = self.offsetX + self.initialX
	self.totalOffsetY = self.offsetY + self.initialY

	local boundaries = {x = self.totalOffsetX, y = self.totalOffsetY, width = self.col*tileLength, height = self.row*tileLength}
	self.quadTree = QuadTree(boundaries, 4)

	self.visibilityGraph = {}
	self.objects = {}
	self.structure, self.entities = makeRoom(structure, entities, player, self)
	self.objects = objects
	--self.entities = createEntities(entities, self.totalOffsetX, self.totalOffsetY)

	for k, row in pairs(self.structure) do
		for k2, object in pairs(row) do
			if object.collidable then
				self.quadTree:insert(object)
			end
		end
	end

	for k, entity in pairs(self.entities) do
		--self.quadTree:insert(entity)
	end
end

function Room:update(dt)
	for k1, v1 in pairs(self.structure) do
		for k2, v2 in pairs(v1) do
			v2:update(dt)
		end
	end

	for k, entity in pairs(self.entities) do
		entity:update(dt)
	end
end

function Room:draw()
	for k, v in pairs(self.structure) do
		for k2, v2 in pairs(v) do
			v2:draw()
		end
	end

	for k, entity in pairs(self.entities) do
		entity:draw()
	end
end

function getRoomSize(structure)
	return #structure[1], #structure
end

function isPair(n)
	return n%2 == 0
end

function getRandom(frames)
	return frames[math.random(1, #frames)]
end

local wallFrames = {
	[1] = {22, 77, 96, 115},  --LEFT WALL
	[2] = {40, 58, 59, 60},  --UPPER WALL
	[3] = {20, 78, 97, 116}, --RIGHT WALL
	[4] = {2, 79, 80, 81}, -- DOWN WALL
	[5] = {4}, --UPPER LEFT CORNER (INSIDE)
	[6] = {5}, --UPPER RIGHT CORNER (INSIDE)
	[7] = {24}, --DOWN RIGHT CORNER (INSIDE)
	[8] = {23}, --DOWN LEFT CORNER (INSIDE)
	[9] = {1},  --UPPER LEFT CORNER (OUTSIDE)
	[10] = {3}, --UPPER RIGHT CORNER (OUTSIDE)
	[11] = {41}, --DOWN RIGHT CORNER (OUTSIDE)
	[12] = {39}, --DOWN LEFT CORNER (OUTSIDE)
}

local groundFrames = {7, 8, 9, 10, 11, 12, 13, 26, 27, 28, 29, 30, 31, 32, 45, 46, 47, 48, 49, 50, 51, 64, 65, 66, 67, 68, 69, 70, 88, 89, 107, 108}

function makeWall(k) -- 1/2 = corners; 3 = UL; 4 = DR
	return{scale = 1, width = 40, height = 40, image = 'tiles', quad = 'tiles', collidable = true, state = 'static',
		animation = function()
			return {
				['static'] = {frames = {getRandom(wallFrames[k])}, interval = 10, currentFrame = 1},
			}
		end,
		box = function(self)
			return Box(self.x, self.y, self.width, self.height)
		end,
		initialise = function(self) end,
		onCollide = function() end,
	}
end

function wall(k)
	if k > 0 and k < 13 then
		return makeWall(k)
	end

	return ({
	[0] = {scale = 1, width = 40, height = 40, image = 'tiles', quad = 'tiles', collidable = false, state = 'static',
		animation = function()
			return {
				['static'] = {frames = {getRandom(groundFrames)}, interval = 10, currentFrame = 1},
			}
		end,
		box = function(self)
			return Box(self.x, self.y, self.width, self.height)
		end,
		initialise = function(self) end,
		onCollide = function() end,
	},
	[13] = {scale = 2.5, width = 24, height = 32, image = 'tiles', quad = 'doors', collidable = true, state = 'close', xOffset = -20, --LEFT
		animation = function()
			return {
				['close'] = {frames = {5}, interval = 10, currentFrame = 1},
				['open'] = {frames = {4}, interval = 10, currentFrame = 1},
			}
		end,
		box = function(self)
			return Box(self.x, self.y, self.width, self.height)
		end,
		initialise = function(self) end,
		onCollide = function(self, player)
			if self.inPlay and love.keyboard.isDown('left') then
				player:shift('left')
				self.inPlay = false
			end
		end,
	},
	[14] = {scale = 2.5, width = 32, height = 24, image = 'tiles', quad = 'doors', collidable = true, state = 'close', yOffset = -20, -- UP
		animation = function()
			return {
				['close'] = {frames = {2}, interval = 10, currentFrame = 1},
				['open'] = {frames = {1}, interval = 10, currentFrame = 1},
			}
		end,
		box = function(self)
			return Box(self.x, self.y, self.width, self.height)
		end,
		initialise = function(self) end,
		onCollide = function(self, player)
			if self.inPlay and love.keyboard.isDown('up') then
				player:shift('up')
				self.inPlay = false
			end
		end,
	},
	[15] = {scale = 2.5, width = 32, height = 32, image = 'tiles', quad = 'doors', collidable = true, state = 'close', --RIGHT
		animation = function()
			return {
				['close'] = {frames = {8}, interval = 10, currentFrame = 1},
				['open'] = {frames = {7}, interval = 10, currentFrame = 1},
			}
		end,
		box = function(self)
			return Box(self.x, self.y, self.width, self.height)
		end,
		initialise = function(self) end,
		onCollide = function(self, player)
			if  self.inPlay and love.keyboard.isDown('right') then
				player:shift('right')
				self.inPlay = false
			end
		end,
	},
	[16] = {scale = 2.5, width = 32, height = 32, image = 'tiles', quad = 'doors', collidable = true, state = 'close', --DOWN
		animation = function()
			return {
				['close'] = {frames = {11}, interval = 10, currentFrame = 1},
				['open'] = {frames = {10}, interval = 10, currentFrame = 1},
			}
		end,
		box = function(self)
			return Box(self.x, self.y, self.width, self.height)
		end,
		initialise = function(self) end,
		onCollide = function(self, player)
			if self.inPlay and love.keyboard.isDown('down') then
				player:shift('down')
				self.inPlay = false
			end
		end,
	},
})[k]
end

local entitiesData = {
	[1] = {
		width = 16, height = 16, scale = 2.5, health = 5, speed = 100, image = 'entities', quad = 'entities', id = 1,
		states = function(self)
			return {
				['idle'] = function() return EntityIdleState(self) end,
				['walk'] = function() return EntityWalkState(self) end,
				['follow'] = function() return EntityFollowState(self) end,
			}
		end,
		animation = function()
			return {
				['idle'] = {
					['up'] = {frames = {38}, interval = 10, currentFrame = 1},
					['right'] = {frames = {26}, interval = 10, currentFrame = 1},
					['down'] = {frames = {2}, interval = 10, currentFrame = 1},
					['left'] = {frames = {14}, interval = 10, currentFrame = 1},
				},
				['walk'] = {
					['up'] = {frames = {37, 38, 39}, interval = 0.15, currentFrame = 1},
					['right'] = {frames = {25, 26, 27}, interval = 0.15, currentFrame = 1},
					['down'] = {frames = {1, 2, 3}, interval = 0.15, currentFrame = 1},
					['left'] = {frames = {13, 14, 15}, interval = 0.15, currentFrame = 1},
				},
				['follow'] = {
					['up'] = {frames = {37, 38, 39}, interval = 0.15, currentFrame = 1},
					['right'] = {frames = {25, 26, 27}, interval = 0.15, currentFrame = 1},
					['down'] = {frames = {1, 2, 3}, interval = 0.15, currentFrame = 1},
					['left'] = {frames = {13, 14, 15}, interval = 0.15, currentFrame = 1},
				},
			}
		end,
		box = function(self)
			return Box(self.x, self.y + self.height/2, self.width, self.height/2)
		end,
		hurt = function(self, damage)
			self.health = self.health - damage
		end,
		stateDecision = {
			['idle'] = {'follow'},
			['walk'] = {'walk'},
			['follow'] = {'follow'},
		},
	},
}

function makeRoom(structure, entities, player, Room)
	local n = #structure
	local m = #structure[1]
	local initX = Room.totalOffsetX
	local initY = Room.totalOffsetY
	local room = {}
	local Entities = {}
	local counter = 1

	for i = 1, n do
		table.insert(room, {})
		counter = 1

		for k, v in ipairs(structure[i]) do
			if v~=17 then
				room[i][counter] = GameObject({(k-1)*40 + initX, (i-1)*40 + initY}, wall(v))
			end
			counter = counter + 1
		end
	end

	if entities then
		for key, entity in pairs(entities) do
			for k2, pos in pairs(entity) do
				table.insert(Entities, Entity(entitiesData[key], pos, player, Room))
			end
		end
	end

	return room, Entities
end
