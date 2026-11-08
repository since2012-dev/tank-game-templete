--====================================================
-- DEPENDENCIES
--====================================================
local flux = require "libs.flux"
local globals = require "utils.globals"
local Assets = require "scripts.assets"
local PlayerMeta = require "scripts.entities.player"
local EnemyManager = require "scripts.enemy-manager"

--====================================================
-- LOCAL ALIASES
--====================================================
local gr = love.graphics
local min = math.min

--====================================================
-- SETTINGS
--====================================================
gr.setDefaultFilter("nearest", "nearest")
gr.setLineStyle("rough")
gr.setBackgroundColor(0.0, 0, 0.1)

--====================================================
-- CONSTANTS
--====================================================

--====================================================
-- GLOBALS
--====================================================

--====================================================
-- MODULE STATE
--====================================================

--====================================================
-- HELPERS
--====================================================

--====================================================
-- LOVE
--====================================================
function love.load()
  Assets.load()
  
  -- Instances
  Player = PlayerMeta:new(Assets.arrow)
  
  -- Entities
  Player:spawn(100, 100)
  globals.Player = Player
  
  EnemyManager.load()
end

function love.update(dt)
  -- Process
  dt = min(dt, 1 / 30)
  globals.timer = globals.timer + dt

  -- Tweens
  flux.update(dt)
  
  -- Entities
  Player:update(dt)
  EnemyManager.update(dt)
end

function love.draw()
  -- Entities
  Player:draw()
  EnemyManager.draw()
end

function love.mousemoved(x, y, dx, dy, istouch)
  Player:mousemoved(x, y, dx, dy, istouch)
end
