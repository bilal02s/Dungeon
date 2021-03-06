StartState = Class{__includes = BaseState}

function StartState:init()

end

local struct1 = {
	{5,2,14,17,2,6},
	{1,0,0,0,0,3},
	{13,0,0,0,0,15},
	{17,0,0,0,0,17},
	{1,0,0,0,0,3},
	{8,4,16,17,4,7},
}

local struct2 = {
	{5,2,14,17,2,2,2,2,2,2,2,6},
	{1,0,0,0,0,0,0,0,0,0,0,3},
	{13,0,0,0,0,0,0,0,0,0,0,15},
	{17,0,0,0,0,0,0,0,0,0,0,17},
	{1,0,0,0,0,0,0,0,0,0,0,3},
	{1,0,0,0,0,0,0,0,0,0,0,3},
	{1,0,0,0,0,0,0,0,0,0,0,3},
	{1,0,0,0,0,0,0,0,0,0,0,3},
	{1,0,0,0,0,0,0,0,0,0,0,3},
	{1,0,0,0,0,0,0,0,0,0,0,3},
	{1,0,0,0,0,0,0,0,0,0,0,3},
	{8,4,16,17,4,4,4,4,4,4,4,7},
}

function StartState:update(dt)
	if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
		local struct
		local entities
		local objects
		struct, entities, objects = createMap(1)
		stateMachine:change('play', {
			struct = struct, --{{struct1, struct2}},
			objects = objects,
			entities = entities,
			initX = 2,
			initY = 1,
		})
	end
end

function StartState:draw()
	local image = images['background']
	love.graphics.draw(image, 0, 0, 0, Width/image:getWidth(), Height/image:getHeight())
	love.graphics.setFont(fonts['zeldaL'])
	love.graphics.printf('Legend of ZELDA', 0, Height/2 - 100, Width, 'center')
	love.graphics.setFont(fonts['zeldaM'])
	love.graphics.printf('Press ENTER to play', 0 , Height*2/3, Width, 'center')
	--[[local count = 0
	for i = 1, 10 do
		love.graphics.draw(images['isaac'], frames['isaac'][i], 10 + (count * 60), 50, 0, 1.5, 1.5)
		love.graphics.rectangle('line', 10 + (count * 60), 50, 18.9*1.5, 15*1.5)
		count = count + 1
	end]]
end
