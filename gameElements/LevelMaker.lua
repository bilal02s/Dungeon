function createMap(k)
	local levels = {
		[1] = { row = 5, col = 5,
			layout = {
				{false, true, false, true, true,},
				{true, true, true, true, false},
				{false, true, false, true, true},
				{false, true, false, true, false},
				{true, true, true, true, true},
			}
		}
	}

	return createLevel(levels(k))
end

function createLevel(param)

end
