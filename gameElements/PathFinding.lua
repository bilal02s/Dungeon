Node = Class{}
local sqrt = math.sqrt

function Node:init(v)
	self.x = v[1]
	self.y = v[2]
	self.vertex = v
	self.parent = false
	self.g = 0
	self.h = 0
	self.f = -1/0
end

function Node:isEqual(dest)
	return self.x == dest[1] and self.y == dest[2]
end

function heuristic(x, y, dest)
	return sqrt((x - dest[1])*(x - dest[1]) + (y - dest[2])*(y - dest[2]))
end

function getDistance(p1, p2)
	return sqrt((p1[1] - p2[1])*(p1[1] - p2[1]) + (p1[2] - p2[2])*(p1[2] - p2[2]))
end

function tracePath(node)
	local inversePath = {node.vertex}
	local path = {}

	while node ~= node.parent do
		node = node.parent
		table.insert(inversePath, node.vertex)
	end

	for i = #inversePath, 1, -1 do
		table.insert(path, inversePath[i])
	end

	return path
end

function findPath(grid, src, dest)
	local open = BinaryHeap('field')
	local closed = {}
	local nodes = {}

	local src = Node(src)
	src.g = 0
	src.h = heuristic(src.x, src.y, dest)
	src.f = src.g + src.h
	src.parent = src
	nodes[src.vertex] = src

	open:insert(src, 'f')

	while open:isNotEmpty() do
		current = open:extractMin('f')
		closed[current.vertex] = true

		if current:isEqual(dest) then
			return tracePath(current)
		end

		for k, vertex in pairs(grid[current.vertex]) do
			if not closed[vertex] then
				local g = current.g + getDistance(current.vertex, vertex)
				local h = heuristic(vertex[1], vertex[2], dest)
				local f = g + h

				if not nodes[vertex] or nodes[vertex].f > f then
					local node = Node(vertex)
					node.parent = current
					node.g = g
					node.h = h
					node.f = f
					nodes[vertex] = node
					open:insert(node, 'f')
				end
			end
		end
	end

	return {}
end
