StartState = Class{__includes = BaseState}

function StartState:init()

end

function StartState:update(dt)
	if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then

	end
end

function StartState:draw()
	local image = images['background']
	love.graphics.draw(image, 0, 0, 0, Width/image:getWidth(), Height/image:getHeight())
	love.graphics.setFont(fonts['zeldaL'])
	love.graphics.printf('Legend of ZELDA', 0, Height/2 - 100, Width, 'center')
	love.graphics.setFont(fonts['zeldaM'])
	love.graphics.printf('Press ENTER to play', 0 , Height*2/3, Width, 'center')

	for i = 1, 247 do
		love.graphics.draw(images['tiles'], frames['tiles'][i], 10 + i * 16, 50, 0, 1, 1)
	end
end
