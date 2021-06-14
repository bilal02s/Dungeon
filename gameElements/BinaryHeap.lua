BinaryHeap = Class{}

local floor = math.floor
function parent(i) return floor(i/2) end
function left(i) return i * 2 end
function right(i) return (i * 2) + 1 end

function BinaryHeap:init(s)
	self.size = 0
	self.arr = {}

	if s == 'field' then
		self.insertElement = self.insertField
		self.heapify = self.heapifyField
	else
		self.insertElement = self.insertValue
		self.heapify = self.heapifyValue
	end
end

function BinaryHeap:insert(value, field)
	self:insertElement(value, field)
end

function BinaryHeap:isNotEmpty()
	return not (self.size == 0)
end

function BinaryHeap:clear()
	self.size = 0
end

function BinaryHeap:getMin()
	return self.arr[1]
end

function BinaryHeap:correctHeapValue(i)
	local parentI = parent(i)

	if i ~= 1 and self.arr[i] < self.arr[parentI] then
		self.arr[parentI], self.arr[i] = self.arr[i], self.arr[parentI]
		self:correctHeapValue(parentI)
	end
end

function BinaryHeap:correctHeapField(i, field)
	local parentI = parent(i)

	if i ~= 1 and self.arr[i][field] < self.arr[parentI][field] then
		self.arr[parentI], self.arr[i] = self.arr[i], self.arr[parentI]
		self:correctHeapField(parentI, field)
	end
end

function BinaryHeap:insertValue(value)
	self.size = self.size + 1
	self.arr[self.size] = value
	self:correctHeapValue(self.size)
end

function BinaryHeap:insertField(t, field)
	self.size = self.size + 1
	self.arr[self.size] = t
	self:correctHeapField(self.size, field)
end

function BinaryHeap:heapifyValue(i)
	local leftI = left(i)
	local rightI = right(i)
	local min = i

	if leftI <= self.size and self.arr[leftI] < self.arr[i] then
		min = leftI
	end
	if rightI <= self.size and self.arr[rightI] < self.arr[min] then
		min = rightI
	end

	if min ~= i then
		self.arr[i], self.arr[min] = self.arr[min], self.arr[i]
		self:heapifyValue(min)
	end
end

function BinaryHeap:heapifyField(i, field)
	local leftI = left(i)
	local rightI = right(i)
	local min = i

	if leftI <= self.size and self.arr[leftI][field] < self.arr[i][field] then
		min = leftI
	end
	if rightI <= self.size and self.arr[rightI][field] < self.arr[min][field] then
		min = rightI
	end

	if min ~= i then
		self.arr[i], self.arr[min] = self.arr[min], self.arr[i]
		self:heapifyField(min, field)
	end
end

function BinaryHeap:extractMin(field)
	if self.size == 0 then
		return false
	else
		local root = self.arr[1]
		self.arr[1] = self.arr[self.size]
		self.size = self.size - 1
		self:heapify(1, field)

		return root
	end
end

function BinaryHeap:decreaseKey(i, value)
	self.arr[i] = value
	self:correctHeapValue(i)
end

function BinaryHeap:delete(i)
	self:decreaseValue(i, -1/0)
	self:extractMin()
end
