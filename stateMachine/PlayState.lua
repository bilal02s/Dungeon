PlayState = Class{__includes = BaseState}

function PlayState:init()
	self.stateMachine = StateMachine({
		['play'] = function() return DungeonPlayState(self) end,
		['shift'] = function() return DungeonShiftState(self) end,
	})
	self.player = PlayerState({
		['idle'] = function() return PlayerIdleState(self.player, self) end,
		['walk'] = function() return PlayerWalkState(self.player, self) end,
		['swingSword'] = function() return PlayerSwingSword(self.player, self) end,
	})
	self.player.scale = 2.5
	self.player.height = 40
	self.player.width = 40
	self.player.images = {
		['idle'] = 'walk',
		['walk'] = 'walk',
		['swingSword'] = 'swingSword',
	}
	self.player.frames = {
		['idle'] = 'walk',
		['walk'] = 'walk',
		['swingSword'] = 'swingSword',
	}
	self.player.animation = function()
		return {
			['walk'] = {
				['up'] = {frames = {10, 11, 12, 9}, interval = 0.1, currentFrame = 1},
				['down'] = {frames = {2, 3, 4, 1}, interval = 0.1, currentFrame = 1},
				['left'] = {frames = {14, 15, 16, 13}, interval = 0.1, currentFrame = 1},
				['right'] = {frames = {6, 7, 8, 5}, interval = 0.1, currentFrame = 1},
			},
			['idle'] = {
				['up'] = {frames = {9}, interval = 10, currentFrame = 1},
				['down'] = {frames = {1}, interval = 10, currentFrame = 1},
				['left'] = {frames = {13}, interval = 10, currentFrame = 1},
				['right'] = {frames = {5}, interval = 10, currentFrame = 1},
			},
			['swingSword'] = {
				['up'] = {frames = {5, 6, 7, 8}, interval = 0.05, currentFrame = 1},
				['down'] = {frames = {1, 2, 3, 4}, interval = 0.05, currentFrame = 1},
				['left'] = {frames = {13, 14, 15, 16}, interval = 0.05, currentFrame = 1},
				['right'] = {frames = {9, 10, 11, 12}, interval = 0.05, currentFrame = 1},
			},
		}
	end
	self.player.hurtBoxes = {
		['walk'] = function(this) return {x = this.x, y = this.y + 20, width = this.width, height = this.height - 15} end,
		['idle'] = function(this) return {x = this.x, y = this.y + 20, width = this.width, height = this.height - 15} end,
		['swingSword'] = function(this) return {x = this.x, y = this.y + 20, width = this.width, height = this.height - 10} end,
	}
	self.player.hitBoxes = {
		['swingSword'] = function(this) return {x = this.x, y = this.y, width = this.width, height = this.height} end,
	}
	function self.player:changeRoom(nextRoom)
		self.current.quadTree = nextRoom.quadTree
		self.current.currentRoom = nextRoom
		self.current.offsetX = nextRoom.initialX + nextRoom.offsetX
		self.current.offsetY = nextRoom.initialY + nextRoom.offsetY
	end

	self.cameraX = 0
	self.cameraY = 0
end

function PlayState:open(param)
	self.struct = param.struct
	self.objects = param.objects
	self.entities = param.entities
	self.roomX = param.initX
	self.roomY = param.initY

	local initX = param.initX
	local initY = param.initY

	self.currentRoom = Room(self.struct[initY][initX], self.objects[initY][initX], self.entities[initY][initX], {(initX - 1)*Width, (initY - 1)*Height}, self.player)
	self.stateMachine:change('play', {
		currentRoom = self.currentRoom,
		player = self.player
	})

	self.player:change('idle', {
		x = Width/2 + (initX - 1)*Width,
		y = Height/2 + (initY - 1)*Height,
		direction = 'down',
		currentRoom = self.currentRoom
	})

	self.cameraX = (initX - 1)*Width
	self.cameraY = (initY - 1)*Height
end

function PlayState:change(state, param)
	if state == 'shift' then
		self.roomX = self.roomX + param.nextX
		self.roomY = self.roomY + param.nextY
		local Y = self.roomY
		local X = self.roomX
		self.nextRoom = Room(self.struct[Y][X], self.objects[Y][X], self.entities[Y][X], {(X - 1)*Width, (Y - 1)*Height}, self.player)
		self.stateMachine:change('shift', {
			currentRoom = self.currentRoom,
			nextRoom = self.nextRoom,
			player = self.player,
			direction = param.direction,
		})
		self.currentRoom = self.nextRoom
		self.nextRoom = nil
	elseif state == 'play' then
		self.stateMachine:change('play', param)
	end
end

function PlayState:update(dt)
	self.stateMachine:update(dt)
	Timer.update(dt)
end

function PlayState:draw()
	love.graphics.translate(-self.cameraX, -self.cameraY)
	self.stateMachine:draw()
end
