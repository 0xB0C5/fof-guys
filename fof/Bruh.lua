return Def.ActorFrame {
	InitCommand=function(self)
		self:sleep(99999)
	end,
	Def.ActorFrame {
		InitCommand=function(self)
			self:sleep(8):queuecommand('EndChart')
		end,
		EndChartCommand=function(self)
			SCREENMAN:GetTopScreen():StartTransitioningScreen('SM_DoNextScreen')
		end,
	},
	LoadActor('audio/bruh.ogg') .. {
		OnCommand=function(self)
			self:play()
		end,
	},
}