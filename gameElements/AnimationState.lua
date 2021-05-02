AnimationState = Class{}

function AnimationState:init(states)
	self.empty = {
		frames = {},
		interval = 10,
		currentFrame = 0,
	}
	self.states = states
	self.current = self.empty
	self.timer = 0
end

function AnimationState:change(state)
	assert(self.states[state])
	self.current = self.states[state]
end

function AnimationState:refresh()
	self.timer = 0
	self.current.currentFrame = 1
end

function AnimationState:update(dt)
	if #self.current.frames > 1 then
		self.timer = self.timer + dt

		if self.timer > self.current.interval then
			self.timer = self.timer % self.current.interval
			self.current.currentFrame = math.max(1, (self.current.currentFrame + 1)%(#self.current.frames + 1))
		end
	end
end

function AnimationState:getCurrentFrame()
	return self.current.frames[self.current.currentFrame]
end
