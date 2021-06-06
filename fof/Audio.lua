local Audio = {}

local sounds = {
	music='../music.ogg',
	checkpoint='audio/checkpoint.ogg',
	goal='audio/goal.ogg',
	jump1='audio/jump1.ogg',
	jump2='audio/jump2.ogg',
	jump3='audio/jump3.ogg',
}

Audio.actor_root = Def.ActorFrame {}
local sound_actors = {}

for sound_name, sound_path in pairs(sounds) do
	Audio.actor_root[#Audio.actor_root+1] = LoadActor(sound_path) .. {
		InitCommand=function(self)
			sound_actors[sound_name] = self
		end,
	}
end


Audio.play = function(sound)
	local actor = sound_actors[sound]
	if actor == nil then
		SM('Unknown sound ' .. sound)
	else
		actor:play()
	end
end


Audio.stop = function(sound)
	local actor = sound_actors[sound]
	if actor == nil then
		SM('Unknown sound ' .. sound)
	else
		actor:stop()
	end
end

return Audio