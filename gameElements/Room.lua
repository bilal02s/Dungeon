Room = Class{}

function Room:init(structure, objects, entities, door)
	self.col, self.row = getRoomSize(structure)
	self.initialX = (Width - self.col*tileLength)/2
	self.initialY = (Height - self.row*tileLength)/2
end

function getRoomSize(structure)
	return #structure[1], #structure
end
