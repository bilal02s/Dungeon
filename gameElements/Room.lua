Room = Class{}

function Room:init(structure, objects, entities, offset)
	self.col, self.row = getRoomSize(structure)
	self.initialX = (Width - self.col*tileLength)/2
	self.initialY = (Height - self.row*tileLength)/2
	self.offsetX = offset[1]
	self.offsetY = offset[2]

	self.structure = makeRoom(structure, self.initialX + self.offsetX, self.initialY + self.offsetY)
end

function Room:update(dt)
	for k1, v1 in pairs(self.structure) do
		for k2, v2 in pairs(v1) do
			v2:update(dt)
		end
	end
end

function Room:draw()
	for k, v in pairs(self.structure) do
		for k2, v2 in pairs(v) do
			v2:draw()
		end
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
	[1] = makeWall(k),
	[2] = makeWall(k),
	[3] = makeWall(k),
	[4] = makeWall(k),
	[5] = makeWall(k),
	[6] = makeWall(k),
	[7] = makeWall(k),
	[8] = makeWall(k),
	[9] = makeWall(k),
	[10] = makeWall(k),
	[11] = makeWall(k),
	[12] = makeWall(k),
	[13] = {scale = 2.5, width = 32, height = 32, image = 'tiles', quad = 'doors', collidable = true, state = 'close', xOffset = -20, --LEFT
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
		onCollide = function() end,
	},
	[14] = {scale = 2.5, width = 32, height = 32, image = 'tiles', quad = 'doors', collidable = true, state = 'close', yOffset = -19, -- UP
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
		onCollide = function() end,
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
		onCollide = function() end,
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
		onCollide = function() end,
	},
})[k]
end

function makeRoom(structure, initX, initY)
	local n = #structure
	local m = #structure[1]
	local room = {}

	for i = 1, n do
		table.insert(room, {})

		for k, v in ipairs(structure[i]) do
			if v~=17 then table.insert(room[i], GameObject({(k-1)*40 + initX, (i-1)*40 + initY}, wall(v))) end
		end
	end

	return room
end
