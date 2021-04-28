Class = require 'lib/class'

function generateCharacter(atlas, width, height)
	local col = atlas:getWidth()/width
	local row = atlas:getHeight()/height
	local x = 0
	local y = 0
	character = {}

	for j = 0, row-1 do
		for i = 0, col-1 do
			table.insert(character, love.graphics.newQuad(x + i*width, y + j*height, width, height, atlas:getDimensions()))
		end
	end

	return character
end

images = {
	['background'] = love.graphics.newImage('graphics/background.jpg'),
	['potLift'] = love.graphics.newImage('graphics/character_pot_lift.png'),
	['potWalk'] = love.graphics.newImage('graphics/character_pot_walk.png'),
	['swingSword'] = love.graphics.newImage('graphics/character_swing_sword.png'),
	['walk'] = love.graphics.newImage('graphics/character_walk.png'),
	['entities'] = love.graphics.newImage('graphics/entities.png'),
	['switch'] = love.graphics.newImage('graphics/switches.png'),
	['heart'] = love.graphics.newImage('graphics/hearts.png'),
	['tiles'] = love.graphics.newImage('graphics/tilesheet.png'),
}

frames = {
	['swingSword'] = generateCharacter(images['swingSword'], 32, 32),
	['walk'] = generateCharacter(images['walk'], 16, 32),
	['entities'] = generateCharacter(images['entities'], 16, 16),
	['switch'] = generateCharacter(images['switch'], 16, 18),
	['tiles'] = generateCharacter(images['tiles'], 16, 16),
}

fonts = {
	['zeldaS'] = love.graphics.newFont('fonts/zelda.otf', 24),
	['zeldaM'] = love.graphics.newFont('fonts/zelda.otf', 48),
	['zeldaL'] = love.graphics.newFont('fonts/zelda.otf', 120),
}

require 'stateMachine/StateMachine'
require 'stateMachine/BaseState'
require 'stateMachine/StartState'

require 'gameElements/PlayerState'
require 'gameElements/Player'
require 'gameElements/AnimationState'

require 'gameElements/playerState/PlayerWalkState'
require 'gameElements/playerState/PlayerIdleState'
require 'gameElements/playerState/PlayerSwingSword'

