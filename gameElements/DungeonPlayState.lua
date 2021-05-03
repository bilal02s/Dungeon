DungeonPlayState = Class{__includes = BaseState}

function DungeonPlayState:init(playState)
	self.playState = playState
end

function DungeonPlayState:open(param)
	self.currentRoom = param.currentRoom
	self.player = param.player
end

function DungeonPlayState:update(dt)
	self.currentRoom:update(dt)
	self.player:update(dt)
end

function DungeonPlayState:draw()
	self.currentRoom:draw()
	self.player:draw()
end
