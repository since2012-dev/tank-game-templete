--====================================================
-- MODULE
--====================================================
local Enemy = {}

--====================================================
-- DEPENDICIES
--====================================================
local lerp = require "utils.lerp"
local lume = require "libs.lume"
local globals = require "utils.globals"
local flux = require "libs.flux"
local CONS = require "utils.constants"

--====================================================
-- LOCAL ALIASES
--====================================================
local gr = love.graphics
local keyboard, mouse = love.keyboard, love.mouse
local sin, cos, atan2, pi = math.sin, math.cos, math.atan2, math.pi
local rn = love.math.random
local STATES = CONS.STATES

--====================================================
-- CONSTANTS
--====================================================
local DIRECTIONS = {
	ATK_BACK = -0.3 * pi,
	ATK_MAX = 0.3 * pi,
}

--====================================================
-- MODULE STATE
--====================================================

--====================================================
-- HELPERS
--====================================================

--====================================================
-- CLASS
--====================================================
Enemy.__index = Enemy

------------------------------------------------------
-- Constructor
------------------------------------------------------
function Enemy:new(sheet)
	local self = setmetatable({}, Enemy)

	-- State
	self.state = STATES.IDLE
	
	-- Movement
	self.x = 0
	self.y = 0
	self.speed = 150
	self.direction = 0
	self.velocity = { x = 0, y = 0 }

	-- Combat
	self.hp = 100
	self.damage = 25
	
	-- Animation
	self.body = { direction = 0 }
	self.texture = sheet
	self.offset = {
		x = self.texture:getWidth() / 2,
		y = self.texture:getHeight() / 2,
	}
	self.tweens = { dir = nil }
	self.tweening = false

	return self
end

------------------------------------------------------
-- Lifecycle
------------------------------------------------------
function Enemy:spawn(spawnX, spawnY)
	-- I add this func to reset states of the player when he dies, instead of create new player
	-- Movement
	self.x = spawnX
	self.y = spawnY
	self.velocity.x = 0
	self.velocity.y = 0

	-- Combat
	self.hp = 100
	self.damage = 25
end

function Enemy:update(Target, dt)
	-- Update state
	self:updateState(Target.x, Target.y)
	
	-- Move
	if not self.tweening then self:pointToward(Target.x, Target.y); self:moveAndSlide(dt) end

	-- Animate
	self:animate()
end

function Enemy:draw()
	local s = 0.4
	gr.draw(self.texture, self.x, self.y, self.direction + self.body.direction, s, s, self.offset.x, self.offset.y)
end

------------------------------------------------------
-- State
------------------------------------------------------
function Enemy:updateState(targetX, targetY)
	-- Stop if tweening
	if self.tweening then return end

	-- Attack
	if lume.distance(self.x, self.y, targetX, targetY, true) < 900 then
		self:playAnim(STATES.ATTACK)
	end
	
	-- Check if moving
	self.state = STATES.WALK
end

------------------------------------------------------
-- Movement
------------------------------------------------------
function Enemy:pointToward(targetX, targetY)
	self.direction = lume.angle(self.x, self.y, targetX, targetY)
end

function Enemy:moveAndSlide(dt)
	-- Forward
	local forwardX = cos(self.direction)
	local forwardY = sin(self.direction)
	
	-- Input
	local dx, dy = forwardX, forwardY
	
	-- Velocity
	self.velocity.x = dx * self.speed
	self.velocity.y = dy * self.speed

	-- Apply velocity
	self.x = self.x + self.velocity.x * dt
	self.y = self.y + self.velocity.y * dt
end

------------------------------------------------------
-- Combat
------------------------------------------------------
function Enemy:attack(Target)
	--[[
	Target is an enemy tbl, i will change it later, and i will add a code to it
	main script take the nearest enemy tbl from enemy-manager script, and it gives this val to the player
	]]
	Target:hurt(self.damage + rn(-5, 5)) -- Todo: set the dmg to: height for near targets, low for far ones
end

function Enemy:hurt(amount)
	-- Todo: add hurt animation
	self.hp = self.hp - amount
end

------------------------------------------------------
-- Animation
------------------------------------------------------
function Enemy:animate()
end

function Enemy:playAnim(animState)	
	-- State
	self.state = animState

	-- Cached vals
	local preDir = self.body.direction
	
	-- Play
	if self.state == STATES.ATTACK then
		if self.tweens.dir then self.tweens.dir:stop(); self.tweens.dir = nil end -- remove the old tween if it is create
		
		self.tweening = true

		self.tweens.dir = flux.to(self.body, 0.5, { direction = preDir + DIRECTIONS.ATK_BACK }):ease("sineinout")
		:after(self.body, 0.8, { direction = preDir + DIRECTIONS.ATK_MAX }):ease("elasticout")
		:after(self.body, 0.1, { direction = preDir }):ease("sineout")
		
		:oncomplete(function() self.tweening = false end)
	end
end

--====================================================
-- RETURN MODULE
--====================================================
return Enemy
