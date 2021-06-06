
local modules = ...

local MoveSystem = {}

MoveSystem.update = function(ECS)
	for _, entity_id in ipairs(ECS.get_entity_ids_with_component('move')) do
		local entity = ECS.entities[entity_id]
		local entity_velocity = entity.physics.velocity
		local move = entity.move

		move.progress = move.progress + 1
		if move.progress >= move.stops[move.index].duration then
			move.progress = 0
			move.index = (move.index % #move.stops) + 1
		end

		local cur_stop = move.stops[move.index]

		local v = cur_stop.velocity
		
		entity_velocity[1] = v[1]
		entity_velocity[2] = v[2]
		entity_velocity[3] = v[3]
	end
end

return MoveSystem
