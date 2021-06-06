local modules = ...

local min = math.min
local max = math.max

local FollowSystem = {}

FollowSystem.update = function(ECS)
	for _, entity_id in ipairs(ECS.get_entity_ids_with_component('follow')) do
		local entity = ECS.entities[entity_id]
		local follow = entity.follow
		local offset = follow.offset
		local target_ids = follow.target_ids

		local max_x = -99999
		local min_x = 99999
		local max_y = -99999
		local min_y = 99999
		local max_z = -99999
		local min_z = 99999

		for _, target_id in ipairs(target_ids) do
			local target = ECS.entities[target_id]
			local target_position = target.transform.position
			local bounce_height = target.ball.bounce_height

			local target_x = target_position[1]
			local target_y = min(bounce_height, target_position[2])
			local target_z = target_position[3]

			max_x = max(max_x, target_x)
			max_y = max(max_y, target_y)
			max_z = max(max_z, target_z)
			min_x = min(min_x, target_x)
			min_y = min(min_y, target_y)
			min_z = min(min_z, target_z)
		end
		followed_x = 0.5 * (min_x + max_x)
		followed_y = 0.5 * (min_y + max_y)
		followed_z = 0.5 * (min_z + max_z)

		local entity_position = entity.transform.position

		local width = max_x - min_x
		local depth = max_z - min_z

		local d = max(1, width/40 + 0.2)
		local offset_y = 15*d
		local offset_z = -50*d

		local a = 0.9
		local b = 0.1

		entity_position[1] = a * entity_position[1] + b * followed_x
		entity_position[2] = a * entity_position[2] + b * (max_y + offset_y)
		entity_position[3] = a * entity_position[3] + b * (min_z + offset_z)
	end
end

return FollowSystem