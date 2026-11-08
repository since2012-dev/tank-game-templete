local collision = {}

--==================================================
-- AABB
--==================================================
function collision.checkCollision(a, b)
	return a.x < b.x + b.w and a.x + a.w > b.x and a.y < b.y + b.h and a.y + a.h > b.y
end

return collision
