
-- Rotations only support pitch & yaw, simply because roll isn't needed for anything.

-- forwards
--  cy   sp*sy   cp*sy
--  0    cp      -sp
--  -sy  sp*cy   cp*cy


-- backwards
--  cy     0    -sy
--  sp*sy  cp   sp*cy
--  cp*sy  -sp  cp*cy

local Math3D = {}

-- Rotation

-- Prepare sin & cos of pitch & yaw to avoid repeating the same computation.
local sp, cp, sy, cy
local has_rot = false
Math3D.set_cur_rotation = function(rot)
	has_rot = rot ~= nil
	if has_rot then
		local pitch = rot[1]
		local yaw = rot[2]
		sp = math.sin(pitch)
		cp = math.cos(pitch)
		sy = math.sin(yaw)
		cy = math.cos(yaw)
	end
end

Math3D.rotate = function(vec)
	if has_rot then
		local x = vec[1]
		local y = vec[2]
		local z = vec[3]

		vec[1] = cy*x + sp*sy*y + cp*sy*z
		vec[2] = cp*y - sp*z
		vec[3] = -sy*x + sp*cy*y + cp*cy*z
	end
end

Math3D.unrotate = function(vec)
	if has_rot then
		local x = vec[1]
		local y = vec[2]
		local z = vec[3]

		vec[1] = cy*x - sy*z
		vec[2] = sp*sy*x + cp*y + sp*cy*z
		vec[3] = cp*sy*x - sp*y + cp*cy*z
	end
end

-- Test
local vec = {1, 10, 100}
local rot = {0.1, 0.2}
Math3D.set_cur_rotation(rot)
Math3D.rotate(vec)
Math3D.unrotate(vec)

local pass = (
	    math.abs(vec[1] -   1) < 0.0001
	and math.abs(vec[2] -  10) < 0.0001
	and math.abs(vec[3] - 100) < 0.0001
)
if not pass then
	SM('Rotation test failed!')
end

return Math3D
