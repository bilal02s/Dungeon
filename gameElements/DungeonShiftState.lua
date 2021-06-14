DungeonShiftState = Class{}

function DungeonShiftState:init(playState)
	self.playState = playState
end

function DungeonShiftState:open(param)
	self.currentRoom = param.currentRoom
	self.nextRoom = param.nextRoom
	self.player = param.player
	self.direction = param.direction
	self.player.current.direction = self.direction
	self.player.current.bodyAnimation:change(self.direction)
	self.player.current.headAnimation:change(self.direction)

	local nextOffsetX = self.nextRoom.offsetX
	local nextOffsetY = self.nextRoom.offsetY
	local nextX
	local nextY

	local k
	local precisionX = 0
	local precisionY = 0
	if self.direction == 'right' then
		k = 1
	elseif self.direction == 'up' then
		k = 4
		precisionY = -2
	elseif self.direction == 'left' then
		k = 3
		precisionX = -2
	elseif self.direction == 'down' then
		k = 2
	end

	nextX = self.nextRoom.totalOffsetX + (self.nextRoom.doors[k][1] + precisionX)*tileLength
	nextY = self.nextRoom.totalOffsetY + (self.nextRoom.doors[k][2] + precisionY)*tileLength

	Timer.tween(0.25, {
		[self.playState] = {cameraX = nextOffsetX, cameraY = nextOffsetY},
		[self.player.current] = {x = nextX , y = nextY}
	}, function()
		self.player:changeRoom(self.nextRoom)
		self.playState:change('play', {player = self.player, currentRoom = self.nextRoom})
	end)
end

function DungeonShiftState:update(dt)
	self.player.current.bodyAnimation:update(dt)
end

function DungeonShiftState:draw()
	self.currentRoom:draw()
	self.nextRoom:draw()
	self.player:draw()
end
