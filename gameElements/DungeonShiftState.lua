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
	self.player.current.animation:change(self.direction)

	self.nextOffsetX = self.nextRoom.offsetX
	self.nextOffsetY = self.nextRoom.offsetY

	Timer.tween(0.5, {
		[self.playState] = {cameraX = self.nextOffsetX, cameraY = self.nextOffsetY},
		[self.player.current] = {x = self.nextOffsetX + Width/2, y = self.nextOffsetY + Height/2}
	}, function()
		self.player:changeRoom(self.nextRoom)
		self.playState:change('play', {player = self.player, currentRoom = self.nextRoom})
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
