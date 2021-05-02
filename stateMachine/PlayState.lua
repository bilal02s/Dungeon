PlayState = Class{__includes = BaseState}

function PlayState:init()
	self.stateMachine = StateMachine({
		['play'] = function() return DungeonPlayState(self) end,
		['shift'] = function() return DungeonShiftState(self) end,
	})
	self.player = PlayerState({
		['idle'] = function() return PlayerIdleState(self, self.player) end,
		['walk'] = function() return PlayerWalkState(self.player) end,
		['swingSword'] = function() return PlayerSwingSword(self.player) end,
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
				['up'] = {frames = {9, 10, 11, 12}, interval = 0.15, currentFrame = 1},
				['down'] = {frames = {1, 2, 3, 4}, interval = 0.15, currentFrame = 1},
				['left'] = {frames = {13, 14, 15, 16}, interval = 0.15, currentFrame = 1},
				['right'] = {frames = {5, 6, 7, 8}, interval = 0.15, currentFrame = 1},
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

	self.currentRoom = Room(self.struct[initY][initX], self.objects[initY][initX], self.entities[initY][initX], {(initX - 1)*Width, (initY - 1)*Height})
	self.stateMachine:change('play', {
		currentRoom = self.currentRoom,
		player = self.player
	})
	self.player:change('idle', {
		x = Width/2,
		y = Height/2,
		direction = 'down',
	})
end

function PlayState:change(state, param)
	if state == 'shift' then
		self.roomX = self.roomX + param.nextX
		self.roomY = self.roomY + param.nextY
		self.nextRoom = Room(self.struct[self.roomY][self.roomX], self.objects[self.roomY][self.roomX], self.entities[self.roomY][self.roomX], {(self.roomX - 1)*Width, (self.roomY - 1)*Height})
		self.stateMachine:change('shift', {
			currentRoom = self.currentRoom,
			nextRoom = self.nextRoom,
			player = self.player,
		})
		self.currentRoom = self.nextRoom
		self.nextRoom = nil
	elseif state == 'play' then

	end
end

function PlayState:update(dt)
	self.stateMachine:update(dt)
end

function PlayState:draw()
	self.stateMachine:draw()
end
