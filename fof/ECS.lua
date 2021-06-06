
local ECS = {}

local empty = {}

local entity_ids_by_component_id

ECS.init = function(entities, systems)
	ECS._load_entities(entities)
	for _, system in ipairs(systems) do
		if system.init then
			system.init(ECS)
		end
	end
	ECS._systems = systems
	ECS.is_running = true
	ECS.frame_count = 0
end

ECS.update = function()
	for _, system in ipairs(ECS._systems) do
		system.update(ECS)
	end
	ECS.frame_count = ECS.frame_count + 1
end

ECS.stop = function(completion)
	ECS.is_running = false
end

ECS.get_entity_ids_with_component = function(component)
	local entity_ids = entity_ids_by_component_id[component]
	if entity_ids == nil then
		return empty
	end
	return entity_ids
end

ECS._load_entities = function(entities)
	ECS.entities = entities
	entity_ids_by_component_id = {}
	for entity_id, entity in ipairs(entities) do
		for component_id, component in pairs(entity) do
			local entity_id_list = entity_ids_by_component_id[component_id]
			if entity_id_list == nil then
				entity_id_list = {}
				entity_ids_by_component_id[component_id] = entity_id_list
			end
			entity_id_list[#entity_id_list+1] = entity_id
		end
	end
end

return ECS
