--====================================================
-- MODULE
--====================================================
local EnemyManager = {
  enemies = { runners = {}, archers = {}, tanks = {} }
}

--====================================================
-- DEPENDENCIES
--====================================================
local globals = require "utils.globals"
local Assets = require "scripts.assets"
-- Enemies metatables
local RunnerMeta = require "scripts.entities.enemies.runner"
local ArcherMeta = require "scripts.entities.enemies.archer"
local TankMeta = require "scripts.entities.enemies.tank"

--====================================================
-- LOCAL ALIASES
--====================================================
local gr = love.graphics
local min, rn = math.min, love.math.random
local runners = EnemyManager.enemies.runners
local archers = EnemyManager.enemies.archers
local tanks = EnemyManager.enemies.tanks

--====================================================
-- CONSTANTS
--====================================================

--====================================================
-- MODULE STATE
--====================================================
local Player = nil
local maxRunners = 6
local maxArchers = 3
local maxTanks =  2

--====================================================
-- HELPERS
--====================================================

--====================================================
-- EXPORTED API
--====================================================
function EnemyManager.load()
  -- Instances
  for i = 1, maxRunners do
    table.insert(runners, RunnerMeta:new(Assets.arrow, globals.Player))
  end

  for i = 1, maxArchers do
    table.insert(archers, ArcherMeta:new(Assets.arrow, globals.Player))
  end

  for i = 1, maxTanks do
    table.insert(tanks, TankMeta:new(Assets.arrow, globals.Player))
  end

  -- Spawn
  for i = #runners, 1, -1 do
    local e = runners[i]
    e:spawn(rn(100, 200), rn(100, 500))
  end

  for i = #archers, 1, -1 do
    local e = archers[i]
    e:spawn(rn(100, 200), rn(100, 500))
  end

  for i = #tanks, 1, -1 do
    local e = tanks[i]
    e:spawn(rn(100, 200), rn(100, 500))
  end
end

function EnemyManager.update(dt)
  for i = #runners, 1, -1 do
    local e = runners[i]
    e:update(globals.Player, dt)
  end
  
  for i = #archers, 1, -1 do
    local e = archers[i]
    e:update(globals.Player, dt)
  end
  
  for i = #tanks, 1, -1 do
    local e = tanks[i]
    e:update(globals.Player, dt)
  end
end

function EnemyManager.draw()
  for i = #runners, 1, -1 do
    local e = runners[i]
    e:draw()
  end
  
  for i = #archers, 1, -1 do
    local e = archers[i]
    e:draw()
  end
  
  for i = #tanks, 1, -1 do
    local e = tanks[i]
    e:draw()
  end
end

--====================================================
-- RETURN MODULE
--====================================================
return EnemyManager
