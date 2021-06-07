local is_multiplayer = FOF_GUYS_GLOBAL_STATE.is_player_joined[1] and FOF_GUYS_GLOBAL_STATE.is_player_joined[2]

return Def.ActorFrame {
	InitCommand=function(self)
		if is_multiplayer then
			self:xy(SCREEN_CENTER_X, SCREEN_CENTER_Y + 0.02*SCREEN_HEIGHT)
			self:zoom(0.75)
		else
			self:xy(SCREEN_CENTER_X, 0.1*SCREEN_HEIGHT)
		end
		self:sleep(99999)
	end,
	Def.Quad {
		InitCommand=function(self)
			self:zoomtowidth(0.16*SCREEN_HEIGHT)
			self:zoomtoheight(0.11*SCREEN_HEIGHT)
			self:diffuse({ 1, 1, 1, 1 })
		end
	},
	Def.Quad {
		InitCommand=function(self)
			self:zoomtowidth(0.15*SCREEN_HEIGHT)
			self:zoomtoheight(0.1*SCREEN_HEIGHT)
			self:diffuse({ 0.1, 0.1, 0.2, 1 })
		end
	},
	Def.BitmapText {		
		Font="Common normal",
		InitCommand=function(self)
			self:zoomtoheight(0.004*SCREEN_HEIGHT)
			self:zoomx(self:GetZoomY())
		end,
		OnCommand=function(self)
			self:queuecommand('Tick')
		end,
		TickCommand=function(self)
			FOF_GUYS_GLOBAL_STATE.seconds_remaining = math.max(0, FOF_GUYS_GLOBAL_STATE.seconds_remaining - 1)
			local seconds = FOF_GUYS_GLOBAL_STATE.seconds_remaining % 60
			local minutes = (FOF_GUYS_GLOBAL_STATE.seconds_remaining - seconds) / 60
			seconds_str = tostring(seconds)
			if seconds_str:len() < 2 then
				seconds_str = '0' .. seconds_str
			end
			self:settext(minutes .. ':' .. seconds_str)
			if FOF_GUYS_GLOBAL_STATE.seconds_remaining <= 0 then
				SCREENMAN:GetTopScreen():StartTransitioningScreen('SM_DoNextScreen')
			else
				self:sleep(1):queuecommand('Tick')
			end
		end,
	},
}
