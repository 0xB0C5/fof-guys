
FOF_GUYS_GLOBAL_STATE.is_player_joined = {false, false}

local is_loading_fof_guys = false
local function load_fof_guys()
	if is_loading_fof_guys then return end

	is_loading_fof_guys = true

	if not (FOF_GUYS_GLOBAL_STATE.is_player_joined[1] or FOF_GUYS_GLOBAL_STATE.is_player_joined[2]) then
		FOF_GUYS_GLOBAL_STATE.is_player_joined[1] = true
		FOF_GUYS_GLOBAL_STATE.is_player_joined[2] = true
	end

	local stepses = GAMESTATE:GetCurrentSong():GetStepsByStepsType('StepsType_Dance_Single')
	for player_index=1,2 do
		local player_number = 'PlayerNumber_P' .. player_index
		if GAMESTATE:IsHumanPlayer(player_number) then
			for _,steps in ipairs(stepses) do
				if steps:GetDifficulty() == 'Difficulty_Beginner' then
					GAMESTATE:SetCurrentSteps(player_number, steps)
					break
				end
			end
		end
	end

	SCREENMAN:SetNewScreen('ScreenGameplay')
end

local player_joined_actors = {}
local function handle_input(event)
	local player_index = event.PlayerNumber == 'PlayerNumber_P2' and 2 or 1

	if event.type == "InputEventType_FirstPress" or event.type == "InputEventType_Repeat" then
		if event.button == 'Up' then
			FOF_GUYS_GLOBAL_STATE.is_player_joined[player_index] = true
			player_joined_actors[player_index]:settext('Joined!')

			if FOF_GUYS_GLOBAL_STATE.is_player_joined[1] and FOF_GUYS_GLOBAL_STATE.is_player_joined[2] then
				load_fof_guys()
			end
		end
	end
end

local time_remaining = 8
return Def.ActorFrame {
	OnCommand=function(self)
		SCREENMAN:GetTopScreen():AddInputCallback(handle_input)

		self:xy(SCREEN_CENTER_X, SCREEN_CENTER_Y)
		self:sleep(9999)
	end,
	Def.Quad {
		InitCommand=function(self)
			self:zoomtowidth(SCREEN_WIDTH)
			self:zoomtoheight(SCREEN_HEIGHT)
			self:diffuse({ 0, 0, 0, 1 })
		end,
	},
	Def.BitmapText {
		Font="Common normal",
		InitCommand=function(self)
			self:zoom(2)
			self:settext('Press Up to Join!')
		end,
	},
	Def.BitmapText {
		Font="Common normal",
		InitCommand=function(self)
			self:xy(-150, 100)
			self:settext('(Not Joined)')
			player_joined_actors[1] = self
		end,
	},
	Def.BitmapText {
		Font="Common normal",
		InitCommand=function(self)
			self:xy(150, 100)
			self:settext('(Not Joined)')
			player_joined_actors[2] = self
		end,
	},
	Def.BitmapText {
		Font="Common normal",
		InitCommand=function(self)
			self:y(-100)
			self:queuecommand('Tick')
		end,
		TickCommand=function(self)
			if time_remaining < 0 then
				self:queuecommand('LoadFofGuys')
				return
			end
			self:settext(tostring(time_remaining))
			time_remaining = time_remaining - 1
			self:sleep(1):queuecommand('Tick')
		end,
		LoadFofGuysCommand=function(self)
			load_fof_guys()
		end,
	},
	LoadActor('audio/join.ogg') .. {
		OnCommand=function(self)
			self:play()
		end,
	},
}