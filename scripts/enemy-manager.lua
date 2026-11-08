--====================================================
-- MODULE
--====================================================
local EnemyManager = {
  enemies = {}
}

--====================================================
-- DEPENDENCIES
--====================================================
local globals = require "utils.globals"
local Assets = require "scripts.assets"
local EnemyMeta = require "scripts.entities.enemy"

--====================================================
-- LOCAL ALIASES
--====================================================
local gr = love.graphics
local min, rn = math.min, love.math.random
local enemies = EnemyManager.enemies

--====================================================
-- CONSTANTS
--====================================================

--====================================================
-- MODULE STATE
--====================================================
local Player = nil

--====================================================
-- HELPERS
--====================================================

--====================================================
-- EXPORTED API
--====================================================
function EnemyManager.load()
  -- Instances
  for i = 1, 1 do
    table.insert(enemies, EnemyMeta:new(Assets.arrow, globals.Player))
  end

  for i = #enemies, 1, -1 do
    local e = enemies[i]
    e:spawn(rn(100, 200), rn(100, 500))
  end
end

function EnemyManager.update(dt)
  for i = #enemies, 1, -1 do
    local e = enemies[i]
    e:update(globals.Player, dt)
  end
end

function EnemyManager.draw()
  for i = #enemies, 1, -1 do
    local e = enemies[i]
    e:draw()
  end
end

--====================================================
-- RETURN MODULE
--====================================================
return EnemyManager
