Player = Class{__includes = BaseState}

function Player:init()
	self.scale = 2.5
	self.width = 16*self.scale
	self.height = 16*self.scale

	self.images = {
		['walk'] = 'walk',
		['idle'] = 'walk',
		['swingSword'] = 'swingSword',
	}

	self.frames = {
		['walk'] = 'walk',
		['idle'] = 'walk',
		['swingSword'] = 'swingSword',
	}

	self.animation = function()
		return {
			['walk'] = {
				['right'] = {frames = {5, 6, 7, 8}, interval = 0.2, currentFrame = 1},
				['left'] = {frames = {9, 10, 11, 12}, interval = 0.2, currentFrame = 1},
				['up'] = {frames = {13, 14, 15, 16}, interval = 0.2, currentFrame = 1},
				['down'] = {frames = {1, 2, 3, 4}, interval = 0.2, currentFrame = 1},
			},
			['idle'] = {
				['right'] = {frames = {5}, interval = 10, currentFrame = 1},
				['left'] = {frames = {13}, interval = 10, currentFrame = 1},
				['up'] = {frames = {9}, interval = 10, currentFrame = 1},
				['down'] = {frames = {1}, interval = 10, currentFrame = 1},
			},
			['swingSword'] = {
				['right'] = {frames = {9, 10, 11, 12}, interval = 0.2, currentFrame = 1},
				['left'] = {frames = {13, 14, 15, 16}, interval = 0.2, currentFrame = 1},
				['up'] = {frames = {5, 6, 7, 8}, interval = 0.2, currentFrame = 1},
				['down'] = {frames = {1, 2, 3, 4}, interval = 0.2, currentFrame = 1},
			},
		}
	end

	self.playerState = PlayerState({
		['walk'] = function() return PlayerWalkState(self) end,
		['idle'] = function() return PlayerIdleState(self) end,
		['swingSword'] = function() return PlayerSwingSword(self) end,
	})

	self.playerState:change('idle')
end

function Player:change(state, param)
	self.playerState:change(state, param)
end

function Player:update(dt)
	self.playerState:update(dt)
end

function Player:draw()
	self.playerState:draw()
end
