DungeonShiftState = Class{}

function DungeonShiftState:init(playState)
	self.playState = playState
	--self.player = playState.player
end

function DungeonShiftState:open(param)
	self.currentRoom = param.currentRoom
	self.nextRoom = param.nextRoom
	self.player = param.player
	self.direction = param.direction
	self.player.current.currentRoom = param.currentRoom

	self.nextX = self.nextRoom.offsetX
	self.nextY = self.nextRoom.offsetY

	Timer.tween(0.5, {
		[self.playState] = {cameraX = self.nextX, cameraY = self.nextY}
	}, function()
		self.playState:change('play', {player = self.player, currentRoom = self.nextRoom})
		self.player.current.currentRoom = self.nextRoom
	end)
	Timer.tween(0.5, {
		[self.player.current] = {x = self.nextX + Width/2}
	})
end

function DungeonShiftState:update(dt)
	self.player.current.animation:change(self.direction)
	self.player.current.animation:update(dt)
	--self.player:update(dt)
end

function DungeonShiftState:draw()
	self.currentRoom:draw()
	self.nextRoom:draw()
	self.player:draw()
end
