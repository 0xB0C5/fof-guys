local modules = ...

local Audio = modules.Audio

local min = math.min

local BounceAudioSystem = {}

local jumps = {
	'jump1',
	'jump2',
	'jump3',
}

BounceAudioSystem.update = function(ECS)
	local had_collision = false
	for _, entity_id in ipairs(ECS.get_entity_ids_with_component('physics')) do
		local physics = ECS.entities[entity_id].physics
		if physics.had_collision then
			had_collision = true
			break
		end
	end
	if had_collision then
		local jump = jumps[1 + math.floor(#jumps * math.random())] or jumps[1]
		Audio.play(jump)
	end
end

return BounceAudioSystem
