local modules = ...

local abs = math.abs

local GoalSystem = {}

GoalSystem.update = function(ECS)
	for _, goal_id in ipairs(ECS.get_entity_ids_with_component('goal')) do
		local goal_entity = ECS.entities[goal_id]
		local goal = goal_entity.goal
		local goal_position = goal_entity.transform.position
		local goal_half_size = goal.half_size
		local half_width = goal_half_size[1]
		local half_height = goal_half_size[2]
		local half_depth = goal_half_size[3]

		for _, ball_id in ipairs(ECS.get_entity_ids_with_component('ball')) do
			local ball_entity = ECS.entities[ball_id]
			local ball_position = ball_entity.transform.position
			local dx = ball_position[1] - goal_position[1]
			local dy = ball_position[2] - goal_position[2]
			local dz = ball_position[3] - goal_position[3]

			if
				abs(dx) < half_width and abs(dy) < half_height and abs(dz) < half_depth
			then
				GoalSystem.winner = ball_entity.input.player
			
				local spawn_position = ball_entity.ball.spawn_position

				ECS.stop()
				modules.Audio.stop('music')
				modules.Audio.play('goal')
			end
		end
	end
end

return GoalSystem
