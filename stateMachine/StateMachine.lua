StateMachine = Class{}

function StateMachine:init(states)
	empty = {
		open = function() end,
		update = function() end,
		draw = function() end,
	}
	self.states = states
	self.current = empty
end

function StateMachine:change(state, param)
	assert(self.states[state])
	self.current = self.states[state]()
	self.current:open(param)
end

function StateMachine:update(dt)
	self.current:update(dt)
end

function StateMachine:draw()
	self.current:draw()
end
