function createMap(k)
	local levels = {
		[1] = { --row = 5, col = 5,
			layout = --[[{
				{false, true, false, true, true,},
				{true, true, true, true, false},
				{false, true, false, true, true},
				{false, true, false, true, false},
				{true, true, true, true, true},
			}]]
			{{false, true, true,},
			 {true, true, true},
			 {false, true, false}},
			rooms = {
				[1] = {row = 12, col = 12,
					corners = {{{1, 1, id = 5}, {12, 1, id = 6}, {12, 12, id = 7}, {1, 12, id = 8}, {1, 1, id = 5}},
						{{3, 3, id = 9}, {6, 3, id = 10}, {6, 6, id = 11}, {3, 6, id = 12}, {3, 3, id = 9}}
					},
					doors = {[3] = {12, 6}, [4] = {6, 12}},
					entities = {},
				},
				[2] = {row = 12, col = 12,
					corners = {{{1, 1, id = 5}, {12, 1, id = 6}, {12, 12, id = 7}, {1, 12, id = 8}, {1, 1, id = 5}}},
					doors = {[1] = {1, 6}, [4] = {6, 12}},
					entities = {},
				},
				[3] = {row = 12, col = 15,
					corners = {{{1, 1, id = 5}, {15, 1, id = 6}, {15, 12, id = 7}, {1, 12, id = 8}, {1, 1, id = 5}}},
					doors = {[3] = {15, 6}},
					entities = {},
				},
				[4] = {row = 12, col = 12,
					corners = {{{1, 1, id = 5}, {12, 1, id = 6}, {12, 12, id = 7}, {1, 12, id = 8}, {1, 1, id = 5}}},
					doors = {[1] = {1, 6}, [2] = {6, 1}, [3] = {12, 6}, [4] = {6, 12}},
					entities = {},
				},
				[5] = {row = 12, col = 12,
					corners = {{{1, 1, id = 5}, {12, 1, id = 6}, {12, 12, id = 7}, {1, 12, id = 8}, {1, 1, id = 5}}},
					doors = {[1] = {1, 6}, [2] = {6, 1}},
					entities = {
						[1] = {{10,1}, {10,2}, {10,3}, {10,4}, {10,5}, {10,6}, {10,7}, {10,8}, {10,9}, {10, 10}},
					},
				},
				[6] = {row = 12, col = 12,
					corners = {{{1, 1, id = 5}, {12, 1, id = 6}, {12, 12, id = 7}, {1, 12, id = 8}, {1, 1, id = 5}}},
					doors = {[2] = {6, 1}},
					entities = {},
				},
			}
		}
	}

	return createLevel(levels[k])
end

local abs = math.abs
function step(a, b)
	return abs(a - b)/(a - b)
end

local function wallIdX(id)
	if id == 5 or id == 6 or id == 11 or id == 12 then return 2
	elseif id == 7 or id == 8 or id == 9 or id == 10 then return 4 end
end

local function wallIdY(id)
	if id == 5 or id == 8 or id == 10 or id == 11 then return 1
	elseif id == 6 or id == 7 or id == 9 or id == 12 then return 3 end
end

function createLevel(param)
	local layout = param.layout
	local rooms = param.rooms
	local roomCounter = 1
	local struct = {}
	local entities = {}

	for k, v in ipairs(layout) do
		table.insert(struct, {})
		table.insert(entities, {})

		for k2, v2 in ipairs(v) do
			local array = {}

			if v2 then
				local currentRoom = rooms[roomCounter]
				local wallBounderies = {}

				for i = 1, currentRoom.row do
					table.insert(array, {})
				end

				for k3, nodes in ipairs(currentRoom.corners) do
					local previousNode = nodes[1]

					for k4, node in ipairs(nodes) do
						local stepY = step(node[2], previousNode[2])
						local stepX = step(node[1], previousNode[1])
						local id = node.id
						array[node[2]][node[1]] = id

						if id == 10 or id == 11 then table.insert(wallBounderies, {node[1], node[2]}) end

						for j = previousNode[2] + stepY, node[2] - stepY, stepY do
							local idY = wallIdY(id)
							array[j][node[1]] = idY
							if idY == 1 then table.insert(wallBounderies, {node[1], j}) end
						end
						for i = previousNode[1] + stepX, node[1] - stepX, stepX do
							array[node[2]][i] = wallIdX(id)
						end

						previousNode = node
					end
				end

				for k3, v3 in pairs(wallBounderies) do
					while not array[v3[2]][v3[1]+1] do
						array[v3[2]][v3[1]+1] = 0
						v3[1] = v3[1] + 1
					end
				end

				for k3, v3 in ipairs(array) do
					--if #v3 < currentRoom.col then
						for i = 1, currentRoom.col do
							if not v3[i] then
								array[k3][i] = 17
							end
						end
					--end
				end

				for k3, v3 in pairs(currentRoom.doors) do
					array[v3[2]][v3[1]] = k3 + 12
					if k3 == 1 or k3 == 3 then array[v3[2]+1][v3[1]] = 17
					elseif k3 == 2 or k3 == 4 then array[v3[2]][v3[1]+1] = 17 end
				end

				entities[k][k2] = currentRoom.entities

				roomCounter = roomCounter + 1
			end

			table.insert(struct[k], array)
		end
	end
	--for k, v in ipairs(struct[1][1]) do for k2, v2 in pairs(v) do io.write(v2) end print() end
	return struct, entities
end
