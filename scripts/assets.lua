--====================================================
-- MODULE
--====================================================
local Assets = {}

--====================================================
-- LOCAL ALIASES
--====================================================
local newImg = love.graphics.newImage

--====================================================
-- EXPORTED API
--====================================================
function Assets.load()
  Assets.player = newImg("assets/player/player.png")
  Assets.runner = newImg("assets/enemies/runner.png")
  Assets.archer = newImg("assets/enemies/archer.png")
  Assets.tank = newImg("assets/enemies/tank.png")
end

--====================================================
-- RETURN MODULE
--====================================================
return Assets
