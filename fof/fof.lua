if FOF_GUYS_GLOBAL_STATE == nil then
	FOF_GUYS_GLOBAL_STATE = {start_time=0}
end

local difficulties = {}
for _, player in ipairs(GAMESTATE:GetHumanPlayers()) do
	local steps = GAMESTATE:GetCurrentSteps(player)
	difficulties[steps:GetDifficulty()] = true
end

local fof
if difficulties['Difficulty_Challenge'] then
	-- In case someone is playing alone on 2 player,
	-- show a join screen so they don't get owned by playing in 2 player mode against someone in 1 player mode.
	if #GAMESTATE:GetHumanPlayers() > 1 then
		fof = LoadActor('JoinScreen.lua')
	else
		FOF_GUYS_GLOBAL_STATE.is_player_joined = {
			GAMESTATE:IsHumanPlayer('PlayerNumber_P1'),
			GAMESTATE:IsHumanPlayer('PlayerNumber_P2'),
		}
		fof = LoadActor('FofGuys.lua')
	end
elseif difficulties['Difficulty_Hard'] then
	fof = LoadActor('LimitChartDuration.lua')
elseif difficulties['Difficulty_Medium'] then
	fof = LoadActor('Bruh.lua')
else
	fof = LoadActor('FofGuys.lua')
end

return fof
