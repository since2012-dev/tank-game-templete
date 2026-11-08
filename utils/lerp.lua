local lerp = {}

--==================================================
-- EASING
--==================================================
function lerp.lerp(a, b, t)
  return a + (b - a) * t
end

--==================================================
-- CLAMP
--==================================================
function lerp.clamp(t, max, min)
  local max = max or 1
  local min = min or 0
  if t < 0 then return 0 elseif t > 1 then return 1 else return t end
end

--==================================================
-- MOVE TOWARD
--==================================================
function lerp.moveToward(current, target, maxDelta)
  -- move `current` toward `target` by at most `maxDelta` (scalar).
  -- reaches the target in finite time; never overshoots.
  local d = target - current
  if math.abs(d) <= maxDelta then return target end
  return current + (d > 0 and maxDelta or -maxDelta)
end

function lerp.moveToward2D(vx, vy, tx, ty, maxDelta)
  -- 2D moveToward (Godot-style). Clamps the *length* of the change vector,
  -- so diagonal and axial movement accelerate at the same rate.
  local dx, dy = tx - vx, ty - vy
  local distSq = dx*dx + dy*dy
  if distSq == 0 or maxDelta <= 0 then return vx, vy end
  local dist = math.sqrt(distSq)
  if dist <= maxDelta then return tx, ty end
  local k = maxDelta / dist
  return vx + dx * k, vy + dy * k
end

--==================================================
-- ANGLES
--==================================================
function lerp.lerpAngle(a, b, t)
  -- shortest-path lerp between two angles (radians), result in [0, 2pi).
  local diff = (b - a + math.pi) % (2 * math.pi) - math.pi
  return (a + diff * t) % (2 * math.pi)
end

function lerp.smoothAngle(current, target, rate, dt)
  -- frame-rate independent angular smoothing (shortest path).
  local diff = (target - current + math.pi) % (2 * math.pi) - math.pi
  return (current + diff * (1 - math.exp(-rate * dt))) % (2 * math.pi)
end

function lerp.moveTowardAngle(current, target, maxDelta)
  -- move an angle toward target by at most maxDelta radians (shortest path).
  local diff = (target - current + math.pi) % (2 * math.pi) - math.pi
  if math.abs(diff) <= maxDelta then return target % (2 * math.pi) end
  return (current + (diff > 0 and maxDelta or -maxDelta)) % (2 * math.pi)
end

--==================================================
-- COLORS
--==================================================
function lerp.lerpColor(out, a, b, t)
  out.r = a.r + (b.r - a.r) * t
  out.g = a.g + (b.g - a.g) * t
  out.b = a.b + (b.b - a.b) * t
  out.a = ((a.a or 1) + ((b.a or 1) - (a.a or 1)) * t)
  return out
end

return lerp
