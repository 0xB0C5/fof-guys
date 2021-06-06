local modules = ...

local min = math.min
local max = math.max

local FollowSystem = {}

FollowSystem.update = function(ECS)
	for _, entity_id in ipairs(ECS.get_entity_ids_with_component('follow')) do
		local entity = ECS.entities[entity_id]
		local follow = entity.follow
		local offset = follow.offset
		local target_id = follow.target_id
		local target = ECS.entities[target_id]
		local target_position = target.transform.position
		local bounce_height = target.ball.bounce_height

		local target_x = target_position[1]
		local target_y = min(bounce_height, target_position[2])
		local target_z = target_position[3]

		local entity_position = entity.transform.position

		local offset_y = 15
		local offset_z = -50

		local a = 0.9
		local b = 0.1

		entity_position[1] = a * entity_position[1] + b * (target_x + offset[1])
		entity_position[2] = a * entity_position[2] + b * (target_y + offset[2])
		entity_position[3] = a * entity_position[3] + b * (target_z + offset[3])
	end
end

return FollowSystem