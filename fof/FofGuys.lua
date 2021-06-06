
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

return Def.ActorFrame {
	OnCommand=function(self)
		modules.Audio.play('music')

		SCREENMAN:GetTopScreen():AddInputCallback(InputSystem.handle_input)

		self:sleep(9999)
	end,
	LoadActor('img/bg.png') .. {
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
			local sTable = GAMESTATE:GetCurrentSong():GetStepsByStepsType('StepsType_Dance_Single')
			for _, player in ipairs(GAMESTATE:GetHumanPlayers()) do
				for _,steps in ipairs(sTable) do
					if steps:GetDifficulty() == 'Difficulty_Hard' then
						GAMESTATE:SetCurrentSteps(player, steps)
						break
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
