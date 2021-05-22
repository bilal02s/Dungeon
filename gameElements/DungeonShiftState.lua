DungeonShiftState = Class{}

function DungeonShiftState:init(playState)
	self.playState = playState
end

function DungeonShiftState:open(param)
	self.currentRoom = param.currentRoom
	self.nextRoom = param.nextRoom
	self.player = param.player
	self.direction = param.direction

	self.nextX = self.nextRoom.offsetX
	self.nextY = self.nextRoom.offsetY

	Timer.tween(0.5, {
		[self.playState] = {cameraX = self.nextX, cameraY = self.nextY},
		[self.player.current] = {x = self.nextX + Width/2, y = self.nextY + Height/2}
	}, function()
		self.playState:change('play', {player = self.player, currentRoom = self.nextRoom})
		self.player.current.currentRoom = self.nextRoom
	end)
end

function DungeonShiftState:update(dt)
	self.player.current.direction = self.direction
	self.player.current.animation:change(self.direction)
	self.player.current.animation:update(dt)
end

function DungeonShiftState:draw()
	self.currentRoom:draw()
	self.nextRoom:draw()
	self.player:draw()
end
