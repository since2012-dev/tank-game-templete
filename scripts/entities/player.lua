--====================================================
-- MODULE
--====================================================
local Player = {}

--====================================================
-- DEPENDENCIES
--====================================================
local lerp = require "utils.lerp"
local lume = require "libs.lume"
local flux = require "libs.flux"
local globals = require "utils.globals"
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
local ACCEL = 1400
local ROTATION_SPEED = 7
local DIRECTIONS = {
	ATK_BACK = -0.3 * pi,
	ATK_MAX = 0.3 * pi,
}
local SPEEDS_FAC = {
	ATK = 0.5,
	HURT = 0.5,
}

--====================================================
-- MODULE STATE
--====================================================
local mx, my = 0, 0

--====================================================
-- HELPERS
--====================================================

--====================================================
-- CLASS
--====================================================
Player.__index = Player

------------------------------------------------------
-- Constructor
------------------------------------------------------
function Player:new(sheet)
	local self = setmetatable({}, Player)

	-- State
	self.state = STATES.IDLE
	
	-- Movement
	self.x = 0
	self.y = 0
	self.speed = 250
	self.speedFac = 1
	self.direction = 0
	self.velocity = { x = 0, y = 0 }
	self.input = 0

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
function Player:spawn(spawnX, spawnY)
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

function Player:update(dt)
	-- Update state
	self:updateState()
	
	-- Move
	if not self.tweening then self:pointToward(mx, my, dt) end
	if self.state == STATES.WALK then self:moveAndSlide(dt) end

	-- Animate
	self:animate()
end

function Player:draw()
	gr.draw(self.texture, self.x, self.y, self.direction + self.body.direction, 1, 1, self.offset.x, self.offset.y)
end

------------------------------------------------------
-- State
------------------------------------------------------
function Player:updateState()
	-- Input
	self.input = 0
	if keyboard.isDown("w", "up") then self.input = 1 end
	if keyboard.isDown("s", "down") then self.input = self.input - 1 end
	
	-- Move / Idle
	local isValidVel = self.velocity.x ~= 0 or self.velocity.y ~= 0
	local isMoving = self.input ~= 0 or isValidVel
	if isMoving then self.state = STATES.WALK; else self.state = STATES.IDLE end

	------ Check for special states ------
	-- Stop if tweening
	if self.tweening then return; else self.speedFac = 1 end

	-- Attack
	if keyboard.isDown("lshift") then
		self.speedFac = SPEEDS_FAC.ATK
		self:playAnim(STATES.ATTACK)
	end
end

------------------------------------------------------
-- Movement
------------------------------------------------------
function Player:mousemoved(x, y, dx, dy, istouch)
	mx, my = x, y
end

function Player:pointToward(targetX, targetY, dt)
	local targetDir = lume.angle(self.x, self.y, targetX, targetY)
	self.direction = lerp.smoothAngle(self.direction, targetDir, ROTATION_SPEED, dt)
end

function Player:moveAndSlide(dt)
	-- Forward
	local forwardX = cos(self.direction)
	local forwardY = sin(self.direction)
	
	-- Input
	local dx, dy = forwardX * self.input, forwardY * self.input

	-- Target velocity
	local targetVX = dx * self.speed * self.speedFac
	local targetVY = dy * self.speed * self.speedFac
	
	-- Velocity
	self.velocity.x, self.velocity.y = lerp.moveToward2D(self.velocity.x, self.velocity.y, targetVX, targetVY, ACCEL * dt)

	-- Apply velocity
	self.x = self.x + self.velocity.x * dt
	self.y = self.y + self.velocity.y * dt
end

------------------------------------------------------
-- Combat
------------------------------------------------------
function Player:attack(Target)
	--[[
	Target is an enemy tbl, i will change it later, and i will add a code to it
	main script take the nearest enemy tbl from enemy-manager script, and it gives this val to the player
	]]
	Target:hurt(self.damage + rn(-5, 5)) -- Todo: set the dmg to: height for near targets, low for far ones
end

function Player:hurt(amount)
	-- Todo: add hurt animation
	self.hp = self.hp - amount
end

------------------------------------------------------
-- Animation
------------------------------------------------------
function Player:animate()
end

function Player:playAnim(animState)	
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
return Player
