Width = 1000
Height = 680

require 'gameElements/Resources'

function love.load()
	love.window.setMode(Width, Height, {fullscreen = false, resizable = true, vsync = true})

	stateMachine = StateMachine({
		['start'] = function() return StartState() end,
		['play'] = function() return PlayState() end,
	})

	stateMachine:change('start')
end

love.keyboard.keyPressed = {}

function love.keypressed(key)
	love.keyboard.keyPressed[key] = true

	if key == 'escape' then
		love.event.quit()
	end
end

function love.keyboard.wasPressed(key)
	if love.keyboard.keyPressed[key] then
		love.keyboard.keyPressed[key] = false
		return true
	end

	return false
end

function love.update(dt)
	stateMachine:update(dt)

	love.keyboard.keyPressed = {}
end

function love.draw()
	stateMachine:draw()
end
