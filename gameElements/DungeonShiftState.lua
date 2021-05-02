DungeonShiftState = Class{}

function DungeonShiftState:init(playState)
	self.playState = playState
	--self.player = playState.player
end

function DungeonShiftState:open(param)
	self.currentRoom = param.currentRoom
	self.nextRoom = param.nextRoom
	self.player = param. player

	self.nextX = self.nextRoom.offsetX
	self.nextY = self.nextRoom.offsetY

end

function DungeonShiftState:update(dt)

end

function DungeonShiftState:draw()
	self.currentRoom:draw()
	self.nextRoom:draw()
	self.player:draw()
end
