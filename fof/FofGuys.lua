
FOF_GUYS_GLOBAL_STATE.seconds_remaining = 120

local modules = {}

modules.meshes = LoadActor('meshes.lua', modules)
modules.Math3D = LoadActor('Math3D.lua', modules)
modules.Audio = LoadActor('Audio.lua', modules)

local ECS = LoadActor('ECS.lua')

local RenderSystem = LoadActor('RenderSystem.lua', modules)
local SpinSystem = LoadActor('SpinSystem.lua', modules)
local MoveSystem = LoadActor('MoveSystem.lua', modules)
local PhysicsSystem = LoadActor('PhysicsSystem.lua', modules)
local InputSystem = LoadActor('InputSystem.lua', modules)
local FollowSystem = LoadActor('FollowSystem.lua', modules)
local CheckpointSystem = LoadActor('CheckpointSystem.lua', modules)
local GoalSystem = LoadActor('GoalSystem.lua', modules)
local BounceAudioSystem = LoadActor('BounceAudioSystem.lua', modules)

local level = LoadActor('levels/GateCrashLevel.lua', modules)

local systems = {
	SpinSystem,
	MoveSystem,
	InputSystem,
	PhysicsSystem,
	FollowSystem,
	CheckpointSystem,
	GoalSystem,
	BounceAudioSystem,
	RenderSystem,
}

ECS.init(level, systems)

local is_multiplayer = FOF_GUYS_GLOBAL_STATE.is_player_joined[1] and FOF_GUYS_GLOBAL_STATE.is_player_joined[2]

return Def.ActorFrame {
	OnCommand=function(self)
		modules.Audio.play('music')

		SCREENMAN:GetTopScreen():AddInputCallback(InputSystem.handle_input)

		self:sleep(9999)
	end,
	LoadActor(is_multiplayer and 'img/bg2.png' or 'img/bg.png') .. {
		InitCommand=function(self)
			self:xy(SCREEN_CENTER_X, SCREEN_CENTER_Y)
			self:zoomtowidth(SCREEN_WIDTH)
			self:zoomtoheight(SCREEN_HEIGHT)
			self:texturewrapping(true)
		end,
		OnCommand=function(self)
			self:queuecommand('Update')
		end,
		UpdateCommand=function(self)
			if ECS.is_running then
				ECS.update()
				self:sleep(1/60):queuecommand('Update')
			else
				self:sleep(3):queuecommand('EndChart')
			end
		end,
		EndChartCommand=function(self)
			local stepses = GAMESTATE:GetCurrentSong():GetStepsByStepsType('StepsType_Dance_Single')

			for player_index=1,2 do
				local player_number = 'PlayerNumber_P' .. player_index
				if GAMESTATE:IsHumanPlayer(player_number) then
					local target_difficulty
					if GoalSystem.winner == player_index then
						if is_multiplayer then
							target_difficulty = 'Difficulty_Easy'
						else
							target_difficulty = 'Difficulty_Hard'
						end
					else
						target_difficulty = 'Difficulty_Medium'
					end
					for _, steps in ipairs(stepses) do
						if steps:GetDifficulty() == target_difficulty then
							GAMESTATE:SetCurrentSteps(player_number, steps)
							break
						end
					end
				end
			end
			SCREENMAN:SetNewScreen('ScreenGameplay')
		end,
	},
	RenderSystem.actor_root,
	modules.Audio.actor_root,
	LoadActor('LimitChartDuration.lua'),
}
