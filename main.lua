Width = 800
Height = 560
tileLength = 40

require 'gameElements/Resources'

function love.load()
	love.window.setMode(Width, Height, {fullscreen = false, resizable = true, vsync = true})
	love.window.setTitle('Dungeon')
	--love.graphics.setDefaultFilter('nearest', 'nearest')

	math.randomseed(os.time())

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

function love.keyreleased(key)
	--love.keyboard.keyPressed[key] = nil
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
