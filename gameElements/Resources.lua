Class = require 'lib/class'

function generateCharacter(atlas, width, height)
	local col = atlas:getWidth()/width
	local row = atlas:getHeight()/height
	local x = 0
	local y = 0
	local character = {}

	for j = 0, row-1 do
		for i = 0, col-1 do
			table.insert(character, love.graphics.newQuad(x + i*width, y + j*height, width, height, atlas:getDimensions()))
		end
	end

	return character
end

function generateQuad(atlas, x, y, width, height, col, row, spaceX, spaceY)
	local t = {}

	for j = 0, row - 1 do
		for i = 0, col - 1 do
			table.insert(t, love.graphics.newQuad(x + i*(width + spaceX) + spaceX, y + j*(height + spaceY) + spaceY, width, height, atlas:getDimensions()))
		end
	end

	return t
end

function generateTiles(atlas, width, height)
	local col = atlas:getWidth()/width
	local row = atlas:getHeight()/height
	local x = 0
	local y = 0
	character = {}

	for j = 0, row-1 do
		for i = 0, col-1 do
			table.insert(character, love.graphics.newQuad(x + i*width-0.9, y + j*height-0.4, width-0.497, height-0.198, atlas:getDimensions()))
		end
	end

	return character
end

function generateDoors(atlas)
	return {
		love.graphics.newQuad(32.14, 88, 31.86, 23.8, atlas:getDimensions()), --UP
		love.graphics.newQuad(0.14, 120, 31.86, 23.8, atlas:getDimensions()),
		love.graphics.newQuad(48.14, 120, 31.86, 23.8, atlas:getDimensions()),
		love.graphics.newQuad(152.14, 144.14, 23.86, 31.86, atlas:getDimensions()), --LEFT
		love.graphics.newQuad(152.14, 176.14, 23.86, 31.86, atlas:getDimensions()),
		love.graphics.newQuad(184.14, 176.14, 23.86, 31.86, atlas:getDimensions()),
		love.graphics.newQuad(0.14, 144.14, 23.86, 31.86, atlas:getDimensions()), --RIGHT
		love.graphics.newQuad(32.14, 144.14, 23.86, 31.86, atlas:getDimensions()),
		love.graphics.newQuad(64.14, 144.14, 23.86, 31.86, atlas:getDimensions()),
		love.graphics.newQuad(111.9, 112.14, 31.86, 23.86, atlas:getDimensions()), --DOWN
		love.graphics.newQuad(96.14, 176.14, 31.86, 23.86, atlas:getDimensions()),
		love.graphics.newQuad(111.9, 144.14, 31.86, 23.86, atlas:getDimensions()),
	}
end

function slice(t, i, j, s)
	newTable = {}
	for i = i,  j, s or 1 do
		table.insert(newTable, t[i])
	end

	return newTable
end

function combine(t1, t2)
	for k, v in pairs(t2) do
		table.insert(t1, v)
	end
	return t1
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
	['tiles'] = love.graphics.newImage('graphics/tilesheet2.png'),
	['tiles2'] = love.graphics.newImage('graphics/tilesheet.png'),
	['isaac'] = love.graphics.newImage('graphics/isaac.png'),
	['horf'] = love.graphics.newImage('graphics/horf.png'),
	['boomfly'] = love.graphics.newImage('graphics/boomfly.png'),
	['slide'] = love.graphics.newImage('graphics/slide.png'),
	['charger'] = love.graphics.newImage('graphics/charger.jpg'),
}

isaac = {
	['isaacUP'] = generateQuad(images['isaac'], 0, 80, 18.9, 15, 10, 1, 13.3, 0),
	['isaacR'] = generateQuad(images['isaac'], 0, 122, 18.9, 15, 10, 1, 13.3, 0),
	['isaacL'] = generateQuad(images['isaac'], -1, 423, 18.9, 15, 10, 1, 13.3, 0),
	['isaacHead'] = generateQuad(images['isaac'], -2, 25, 27.8, 24.2, 8, 1, 12.2, 0)
}

frames = {
	['swingSword'] = generateCharacter(images['swingSword'], 32, 32),
	['walk'] = generateCharacter(images['walk'], 16, 32),
	['entities'] = generateCharacter(images['entities'], 16, 16),
	['switch'] = generateCharacter(images['switch'], 16, 18),
	['heart'] = generateCharacter(images['heart'], 16, 16),
	['tiles'] = generateTiles(images['tiles'], 40, 40),
	['doors'] = generateDoors(images['tiles2']),
	['isaac'] = combine(combine(combine(isaac['isaacUP'], isaac['isaacR']), isaac['isaacL']), isaac['isaacHead']),
	['horf'] = combine(combine(combine(isaac['isaacUP'], isaac['isaacR']), isaac['isaacL']), generateCharacter(images['horf'], 32, 32)),
	['slide'] = generateCharacter(images['slide'], 48, 48),
	['charger'] = generateCharacter(images['charger'], 32, 32),
	['boomfly'] = generateCharacter(images['boomfly'], 32, 32),
}

fonts = {
	['zeldaS'] = love.graphics.newFont('fonts/zelda.otf', 24),
	['zeldaM'] = love.graphics.newFont('fonts/zelda.otf', 48),
	['zeldaL'] = love.graphics.newFont('fonts/zelda.otf', 120),
}

require 'stateMachine/StateMachine'
require 'stateMachine/BaseState'
require 'stateMachine/StartState'
require 'stateMachine/PlayState'

require 'gameElements/PlayerState'
require 'gameElements/Player'
require 'gameElements/AnimationState'
require 'gameElements/LevelMaker'
require 'gameElements/DungeonPlayState'
require 'gameElements/DungeonShiftState'
require 'gameElements/Room'
require 'gameElements/GameObject'
require 'gameElements/Timer'
require 'gameElements/QuadTree'
require 'gameElements/Entity'
require 'gameElements/BinaryHeap'
require 'gameElements/VisibilityGraph'
require 'gameElements/PathFinding'
require 'gameElements/Ball'

require 'gameElements/playerStates/PlayerWalkState'
require 'gameElements/playerStates/PlayerIdleState'
require 'gameElements/playerStates/PlayerSwingSword'

require 'gameElements/entityStates/EntityIdleState'
require 'gameElements/entityStates/EntityWalkState'
require 'gameElements/entityStates/EntityFollowState'

