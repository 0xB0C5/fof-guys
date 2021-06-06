if FOF_GUYS_GLOBAL_STATE == nil then
	FOF_GUYS_GLOBAL_STATE = {start_time=0}
end



local is_expert = false
for _, player in ipairs(GAMESTATE:GetHumanPlayers()) do
	local steps = GAMESTATE:GetCurrentSteps(player)
	if steps:GetDifficulty() == 'Difficulty_Challenge' then
		is_expert = true
		break
	end
end

if is_expert then
	-- For whatever reason, this doesn't work if you return it without assigning it to wtf.
	local wtf = LoadActor('FofGuys.lua')
	return wtf
else
	local wtf = LoadActor('LimitChartDuration.lua')
	return wtf
end
