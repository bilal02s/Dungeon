VisibilityGraph = Class{}
local atan = math.atan
local pi = math.pi

function getVectAngle(vect)
	local angle = vect[2]/vect[1]
	if vect[1] >= 0 then
		angle = angle < 0 and angle + 2*pi or angle
		return angle
	else
		return angle + pi
	end
end

function copy(t)
	local new = {}
	for k, v in pairs(t) do
		new[k] = v
	end
	return new
end

function merge(t1, t2)
	local new = {}
	for k, v in pairs(t1) do
		new[k] = v
	end
	for k, v in pairs(t2) do
		new[k] = v
	end
	return new
end

function VisibilityGraph:init()
	self.connectedVertices = {}
	self.simpleVertices = {}
	self.graph = {}
	self.w = 0
	self.h = 0
end

function VisibilityGraph:setEntityDimentions(w, h)
	self.w = w
	self.h = h
end

function VisibilityGraph:insertObject(object)
	local node1 = {object.x - self.w, object.y - self.h}
	local node2 = {object.x + object.width, object.y - self.h}
	local node3 = {object.x + object.width, object.y + object.height}
	local node4 = {object.x - self.w, object.y + object.height}

	self.connectedVertices[node1] = {node2, node4}
	self.connectedVertices[node2] = {node3, node1}
	self.connectedVertices[node3] = {node4, node2}
	self.connectedVertices[node4] = {node1, node3}
end

function VisibilityGraph:insertPoint(point)
	table.insert(self.simpleVertices, point)
end

function VisibilityGraph:horizontalIntersection(segment, x, y)
	if (segment[1][2] >= y and segment[1][2] >= y) or (segment[1][2] < y and segment[2][2] < y) or (segment[1][1] <= x and segment[2][1] <= x) then
		return false
	elseif segment[1][1] > x and segment[2][1] > x then
		return true
	end

	local t = (segment[2][1] - segment[1][1])/(segment[2][2] - segment[1][2])
	local xi = t*y + (segment[1][1]*segment[2][2] - segment[2][1]*segment[1][2])/(segment[2][2] - segment[1][2])
	local result = (x < xi) and (segment[1][1] < xi and segment[2][1] > xi) or (segment[1][1] > xi and segment[2][1] < xi)

	return result
end

function VisibilityGraph:getIntersection(segment1, segment2)
	local a = segment1[2][2] - segment1[1][2]
	local b = segment1[1][1] - segment1[2][1]
	local c = segment1[2][1]*segment1[1][2] - segment1[1][1]*segment1[2][2]
	local j = segment2[2][2] - segment2[1][2]
	local k = segment2[1][1] - segment2[2][1]
	local l = segment2[2][1]*segment2[1][2] - segment2[1][1]*segment2[2][2]

	local x = (c*k - b*l)/(b*j - a*k)
	local y = (a*l - c*j)/(b*j - a*k)

	if ((x == segment1[1][1] and y == segment1[1][2]) or (x == segment1[2][1] and y == segment1[2][2])) and
		((x == segment2[1][1] and y == segment2[1][2]) or (x == segment2[2][1] and y == segment2[2][2])) then
		return false
	end

	local result1 = ((x >= segment1[1][1] and x <= segment1[2][1]) or (x <= segment1[1][1] and x >= segment1[2][1])) and
		((y >= segment1[1][2] and y <= segment1[2][2]) or (y <= segment1[1][2] and y >= segment1[2][2]))

	local result2 = ((x >= segment2[1][1] and x <= segment2[2][1]) or (x <= segment2[1][1] and x >= segment2[2][1])) and
		((y >= segment2[1][2] and y <= segment2[2][2]) or (y <= segment2[1][2] and y >= segment2[2][2]))

	return result1 and result2
end

function VisibilityGraph:connectObjectVertices(vertices)
	local angles = BinaryHeap()
	local graph = {}

	for vertex, connections in pairs(vertices) do
		local sortedVertices = {}
		local obstacles = {}
		local previous = nil
		local index = 1
		angles:clear()
		graph[vertex] = {}

		local firstAngle = getVectAngle({connections[1][1] - vertex[1], connections[1][2] - vertex[2]})
		local lastAngle = getVectAngle({connections [2][1] - vertex[1], connections[2][2] - vertex[2]})

		for other, otherConnections in pairs(self.connectedVertices) do
			if vertex ~= other then
				local angle = getVectAngle({other[1] - vertex[1], other[2] - vertex[2]})
				angles:insert(angle)

				if sortedVertices[angle] then
					table.insert(sortedVertices[angle], other)
				else
					sortedVertices[angle] = {other}
				end
			end
		end

		for k, other in pairs(self.simpleVertices) do
			local angle = getVectAngle({other[1] - vertex[1], other[2] - vertex[2]})
			angles:insert(angle)

			if sortedVertices[angle] then
				table.insert(sortedVertices[angle], other)
			else
				sortedVertices[angle] = {other}
			end
		end

		for other, otherConnections in pairs(self.connectedVertices) do
			if self:horizontalIntersection({other, otherConnections[1]}, vertex[1], vertex[2]) then
				obstacles[other] = otherConnections[1]
			end
		end

		while angles:isNotEmpty() do
			local currentAngle = angles:extractMin()
			local other
			local visible = true

			if previous == currentAngle then
				index = index + 1
				other = sortedVertices[currentAngle][index]
			else
				previous = currentAngle
				other = sortedVertices[currentAngle][1]
				index = 1
			end

			if firstAngle < lastAngle and currentAngle > firstAngle and currentAngle < lastAngle then
				goto continue
			elseif firstAngle > lastAngle and (currentAngle > firstAngle or currentAngle < lastAngle) then
				goto continue
			end

			for node1, node2 in pairs(obstacles) do
				if self:lineIntersection({vertex, other}, {node1, node2}) then
					visible = false
					break
				end
			end

			if visible then
				table.insert(graph[vertex], other)
			end

			::continue::

			if self.connectedVertices[other] then
				connection1 = self.connectedVertices[other][1]
				connection2 = self.connectedVertices[other][2]

				if obstacles[other] then
					obstacles[other] = nil
				else
					obstacles[other] = connection1
				end

				if obstacles[connection2] then
					obstacles[connection2] = nil
				else
					obstacles[connection2] = other
				end
			end
		end
	end

	return graph
end

function VisibilityGraph:connectSimpleVertices(vertices, allSimpleVertices)
	local angles = BinaryHeap()
	local graph = {}

	for k, vertex in pairs(vertices) do
		local sortedVertices = {}
		local obstacles = {}
		local previous = nil
		local index = 1
		angles:clear()
		graph[vertex] = {}

		for other, otherConnections in pairs(self.connectedVertices) do
			local angle = getVectAngle({other[1] - vertex[1], other[2] - vertex[2]})
			angles:insert(angle)

			if sortedVertices[angle] then
				table.insert(sortedVertices[angle], other)
			else
				sortedVertices[angle] = {other}
			end
		end

		for k, other in pairs(allSimpleVertices) do
			if vertex ~= other then
				local angle = getVectAngle({other[1] - vertex[1], other[2] - vertex[2]})
				angles:insert(angle)

				if sortedVertices[angle] then
					table.insert(sortedVertices[angle], other)
				else
					sortedVertices[angle] = {other}
				end
			end
		end

		for other, otherConnections in pairs(self.connectedVertices) do
			if self:horizontalIntersection({other, otherConnections[1]}, vertex[1], vertex[2]) then
				obstacles[other] = otherConnections[1]
			end
		end

		while angles:isNotEmpty() do
			local currentAngle = angles:extractMin()
			local other
			local visible = true

			if previous == currentAngle then
				index = index + 1
				other = sortedVertices[currentAngle][index]
			else
				previous = currentAngle
				other = sortedVertices[currentAngle][1]
				index = 1
			end

			for node1, node2 in pairs(obstacles) do
				if self:lineIntersection({vertex, other}, {node1, node2}) then
					visible = false
					break
				end
			end

			if visible then
				table.insert(graph[vertex], other)
			end

			if self.connectedVertices[other] then
				connection1 = self.connectedVertices[other][1]
				connection2 = self.connectedVertices[other][2]

				if obstacles[other] then
					obstacles[other] = nil
				else
					obstacles[other] = connection1
				end

				if obstacles[connection2] then
					obstacles[connection2] = nil
				else
					obstacles[connection2] = other
				end
			end
		end
	end

	return graph
end

function VisibilityGraph:createGraph()
	local graph1 = self:connectObjectVertices(self.connectedVertices)
	local graph2 = self:connectSimpleVertices(self.simpleVertices, self.simpleVertices)

	self.graph = merge(graph1, graph2)
end

function VisibilityGraph:getGraph(point1, point2)
	local allVertices = copy(self.simpleVertices)
	table.insert(allVertices, point1)
	table.insert(allVertices, point2)
	local newGraph = self:connectSimpleVertices({point1, point2}, allVertices)
	local graph = {}

	for vertex, nodes in pairs(self.graph) do
		graph[vertex] = copy(nodes)
	end

	for vertex, nodes in pairs(newGraph) do
		graph[vertex] = copy(nodes)
	end

	for vertex, nodes in pairs(newGraph) do
		for k, node in pairs(nodes) do
			table.insert(graph[node], vertex)
		end
	end

	return graph
end

function VisibilityGraph:draw(graph)
	for vertex, connection in pairs(self.connectedVertices) do
		love.graphics.circle('fill', vertex[1], vertex[2], 2.5)
		love.graphics.line(vertex[1], vertex[2], connection[1][1], connection[1][2])
	end

	for k, vertex in pairs(self.simpleVertices) do
		love.graphics.circle('fill', vertex[1], vertex[2], 2.5)
	end

	for vertex, nodes in pairs(graph) do
		for k, node in pairs(nodes) do
			love.graphics.line(vertex[1], vertex[2], node[1], node[2])
		end
	end
end
