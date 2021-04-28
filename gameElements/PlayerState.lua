PlayerState = Class{}

function PlayerState:init(states)
	self.empty = {
		update = function() end,
		draw = function() end,
	}
	self.states = states
	self.current = self.empty
end

function PlayerState:change(state, param)
	assert(self.states[state])
	self.current = self.states[state]()
	self.current:open(param)
end

function PlayerState:update(dt)
	self.current:update(dt)
end

function PlayerState:draw()
	self.current:draw()
end
