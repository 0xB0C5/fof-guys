local modules = ...

local set_cur_rotation = modules.Math3D.set_cur_rotation
local unrotate = modules.Math3D.unrotate
local rotate = modules.Math3D.rotate

local max = math.max
local min = math.min
local sqrt = math.sqrt

local GRAVITY = 0.01
local MIN_VERTICAL_VELOCITY = -0.25
local BOUNCE_VELOCITY = 0.1
local BOUNCINESS = 0.5

local PHYSICS_UPDATE_COUNT = 2
local PHYSICS_UPDATE_DELTA = 1 / PHYSICS_UPDATE_COUNT

local PhysicsSystem = {}

local temp_vector = {0,0,0}

PhysicsSystem.update = function(ECS)
	local ball_entity_ids = ECS.get_entity_ids_with_component('ball')
	local box_entity_ids = ECS.get_entity_ids_with_component('box')
	local physics_entity_ids = ECS.get_entity_ids_with_component('physics')

	for _, entity_id in ipairs(physics_entity_ids) do
		ECS.entities[entity_id].physics.had_collision = false
	end

	for update_index=1,PHYSICS_UPDATE_COUNT do
		for _, entity_id in ipairs(physics_entity_ids) do
			local entity = ECS.entities[entity_id]
			local position = entity.transform.position
			local physics = entity.physics
			local velocity = physics.velocity

			if physics.gravity then
				velocity[2] = max(MIN_VERTICAL_VELOCITY, velocity[2] - PHYSICS_UPDATE_DELTA*GRAVITY)
			end

			position[1] = position[1] + PHYSICS_UPDATE_DELTA*velocity[1]
			position[2] = position[2] + PHYSICS_UPDATE_DELTA*velocity[2]
			position[3] = position[3] + PHYSICS_UPDATE_DELTA*velocity[3]

		end

		for box_index=1,#box_entity_ids do
			local box_entity = ECS.entities[box_entity_ids[box_index]]
			local box_transform = box_entity.transform
			local box_rotation = box_transform.rotation
			local box_position = box_transform.position
			local box = box_entity.box
			local box_half_size = box.half_size
			local box_physics = box_entity.physics
			local box_vx, box_vy, box_vz
			if box_physics then
				local box_velocity = box_entity.physics.velocity
				box_vx = box_velocity[1]
				box_vy = box_velocity[2]
				box_vz = box_velocity[3]
			else
				box_vx = 0
				box_vy = 0
				box_vz = 0
			end

			if box_rotation ~= nil then
				set_cur_rotation(box_entity.transform.rotation)
			end

			for ball_index=1,#ball_entity_ids do
				local ball_entity = ECS.entities[ball_entity_ids[ball_index]]
				local ball = ball_entity.ball
				local ball_radius = ball.radius
				local ball_position = ball_entity.transform.position
				local ball_physics = ball_entity.physics
				local ball_velocity = ball_physics.velocity

				-- find the closest point to ball_position within the box's bounds.
				temp_vector[1] = ball_position[1] - box_position[1]
				temp_vector[2] = ball_position[2] - box_position[2]
				temp_vector[3] = ball_position[3] - box_position[3]

				if box_rotation ~= nil then
					unrotate(temp_vector)
				end

				temp_vector[1] = max(-box_half_size[1], min(box_half_size[1], temp_vector[1]))
				temp_vector[2] = max(-box_half_size[2], min(box_half_size[2], temp_vector[2]))
				temp_vector[3] = max(-box_half_size[3], min(box_half_size[3], temp_vector[3]))

				if box_rotation ~= nil then
					rotate(temp_vector)
				end

				-- closest point to ball relative to ball position
				local dx = temp_vector[1] + box_position[1] - ball_position[1]
				local dy = temp_vector[2] + box_position[2] - ball_position[2]
				local dz = temp_vector[3] + box_position[3] - ball_position[3]

				local dist = sqrt(dx*dx + dy*dy + dz*dz)

				if dist > 0 and dist <= ball_radius then
					dx = dx / dist
					dy = dy / dist
					dz = dz / dist
					-- Move into contact position
					local move_amount = ball_radius - dist
					ball_position[1] = ball_position[1] - move_amount * dx
					ball_position[2] = ball_position[2] - move_amount * dy
					ball_position[3] = ball_position[3] - move_amount * dz

					-- ball velocity relative to box
					-- TODO : this should also account for box angular velocity
					local vx = ball_velocity[1] - box_vx
					local vy = ball_velocity[2] - box_vy
					local vz = ball_velocity[3] - box_vz

					local t = (
						  vx*dx
						+ vy*dy
						+ vz*dz
					)

					if t > 0 then
						ball_physics.had_collision = true
					
						t = (1+BOUNCINESS) * t + BOUNCE_VELOCITY
						
						dx = t*dx
						dy = t*dy
						dz = t*dz

						ball_velocity[1] = vx + box_vx - dx
						ball_velocity[2] = vy + box_vy - dy
						ball_velocity[3] = vz + box_vz - dz

						if dy < 0 then
							ball.bounce_height = ball_position[2]
						end

						ball.slippy = box.slippy
					end
				end
			end
		end
	end

	for ball_index=1,#ball_entity_ids do
		local ball_entity = ECS.entities[ball_entity_ids[ball_index]]
		local ball = ball_entity.ball
		local position = ball_entity.transform.position
		if position[2] < -50 then
			local spawn_position = ball.spawn_position

			position[1] = spawn_position[1]
			position[2] = spawn_position[2]
			position[3] = spawn_position[3]
			ball.bounce_height = position[2]

			local velocity = ball_entity.physics.velocity
			velocity[1] = 0
			velocity[2] = 0
			velocity[3] = 0
		end
	end
end

return PhysicsSystem