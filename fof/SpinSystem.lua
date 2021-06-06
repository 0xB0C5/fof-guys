
local modules = ...

local SpinSystem = {}

SpinSystem.update = function(ECS)
	for _, entity_id in ipairs(ECS.get_entity_ids_with_component('spin')) do
		local entity = ECS.entities[entity_id]
		local rotation = entity.transform.rotation
		local spin = entity.spin
		rotation[1] = rotation[1] + spin[1]
		rotation[2] = rotation[2] + spin[2]
	end
end

return SpinSystem
