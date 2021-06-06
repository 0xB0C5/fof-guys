local modules = ...

local abs = math.abs

local CheckpointSystem = {}

CheckpointSystem.update = function(ECS)
	for _, checkpoint_id in ipairs(ECS.get_entity_ids_with_component('checkpoint')) do
		local checkpoint_entity = ECS.entities[checkpoint_id]
		local checkpoint = checkpoint_entity.checkpoint
		local checkpoint_position = checkpoint_entity.transform.position
		local checkpoint_half_size = checkpoint.half_size
		local half_width = checkpoint_half_size[1]
		local half_height = checkpoint_half_size[2]
		local half_depth = checkpoint_half_size[3]

		for _, ball_id in ipairs(ECS.get_entity_ids_with_component('ball')) do
			local ball_entity = ECS.entities[ball_id]
			local ball_position = ball_entity.transform.position
			local dx = ball_position[1] - checkpoint_position[1]
			local dy = ball_position[2] - checkpoint_position[2]
			local dz = ball_position[3] - checkpoint_position[3]

			if
				abs(dx) < half_width and abs(dy) < half_height and abs(dz) < half_depth
			then
				local spawn_position = ball_entity.ball.spawn_position

				if
					spawn_position[1] ~= checkpoint_position[1]
					or spawn_position[2] ~= checkpoint_position[2]
					or spawn_position[3] ~= checkpoint_position[3]
				then
					spawn_position[1] = checkpoint_position[1]
					spawn_position[2] = checkpoint_position[2]
					spawn_position[3] = checkpoint_position[3]

					modules.Audio.play('checkpoint')
				end
			end
		end
	end
end

return CheckpointSystem
