--====================================================
-- MODULE
--====================================================
local functions = {}

--====================================================
-- LOCAL ALIASES
--====================================================
local gr = love.graphics

--====================================================
-- EXPORTED API
--====================================================
function functions.draw(self)
	-- Direction
	local dir = self.direction
	
	if self.tweening then dir = self.tweensStartVals.dir end

	dir = dir + self.body.direction

	-- Draw
	gr.draw(self.texture, self.x, self.y, dir, 1, 1, self.offset.x, self.offset.y)
end

--====================================================
-- RETURN MODULE
--====================================================
return functions

