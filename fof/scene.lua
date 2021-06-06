
local fofDir = GAMESTATE:GetCurrentSong():GetSongDir() .. 'fof/'

local WHITE = {1,1,1,1}

local CAM_PITCH = -0.05
local SIN_CAM_PITCH = math.sin(CAM_PITCH)
local COS_CAM_PITCH = math.cos(CAM_PITCH)

local camForwardX = 0
local camForwardY = SIN_CAM_PITCH
local camForwardZ = COS_CAM_PITCH
local camUpX = 0
local camUpY = COS_CAM_PITCH
local camUpZ = -SIN_CAM_PITCH
local camRightX = 1
local camRightY = 0
local camRightZ = 0
local camX = 0
local camY = 4
local camZ = 0
local camC = 600

local scene={}

scene.camYaw = 0
scene.setCameraYaw = function(yaw)
	scene.camYaw = yaw

	local sinYaw = math.sin(yaw)
	local cosYaw = math.cos(yaw)

	local camForwardH = COS_CAM_PITCH
	camForwardX = camForwardH * sinYaw
	camForwardZ = camForwardH * cosYaw

	camRightX = cosYaw
	camRightZ = -sinYaw

	local camUpH = -SIN_CAM_PITCH
	camUpX = camUpH * sinYaw
	camUpZ = camUpH * cosYaw
end

local function world2screen(point)
	local px = point[1] - camX
	local py = point[2] - camY
	local pz = point[3] - camZ

	local pForward = (
		  px*camForwardX
		+ py*camForwardY
		+ pz*camForwardZ
	)

	if pForward <= 0 then
		point[1] = 0/0
		point[2] = 0/0
		point[3] = 0/0
		return
	end

	local sx = px/pForward
	local sy = py/pForward
	local sz = pz/pForward

	local sRight = (
		  sx*camRightX
		+ sy*camRightY
		+ sz*camRightZ
	)
	point[1] = sRight * camC

	local sUp = (
		  sx*camUpX
		+ sy*camUpY
		+ sz*camUpZ
	)
	point[2] = -sUp * camC

	point[3] = -pForward
end

scene.models = {}
scene.root = Def.ActorFrame {
	InitCommand=function(self)
		self:xy(SCREEN_CENTER_X, SCREEN_CENTER_Y)
	end,
}

scene.makeModel=function(mesh, color)
	if color == nil then
		color = WHITE
	end

	local model = {
		position={0,0,0},
		verts=mesh.verts,
		vertDests={},
		actorVerts={},
		actorPositions={},
	}

	for i=1,#model.verts do
		model.vertDests[i] = {}
	end

	for destIndex, srcIndex in ipairs(mesh.indices) do
		local dests = model.vertDests[srcIndex]
		dests[#dests+1] = destIndex
	end

	for i=1,#mesh.indices do
		model.actorVerts[i] = {nil, color, mesh.uv[i]}
	end

	for i=1,#model.verts do
		local pos = {0,0,0}
		model.actorPositions[i] = pos
		for j=1,#model.vertDests[i] do
			model.actorVerts[model.vertDests[i][j]][1] = pos
		end
	end

	local def = Def.ActorMultiVertex {
		InitCommand=function(self)
			model.actor = self
			self:LoadTexture(fofDir .. 'img/box.png')
			self:SetDrawState({Mode='DrawMode_Quads'})
			self:SetNumVertices(#mesh.indices)
			self:ztest(true)
			self:zwrite(true)
		end,
	}

	scene.models[#scene.models+1] = model
	scene.root[#scene.root+1] = def

	return model
end

scene.render=function()
	local models = scene.models
	-- local setVertex = ActorMultiVertex.SetVertex

	for modelIndex=1,#models do
		model = models[modelIndex]
		local modelPos = model.position
		local modelVerts = model.verts
		local modelDests = model.vertDests
		local modelUv = model.uv
		local modelActorPositions = model.actorPositions

		for i=1,#model.verts do
			local modelVert = modelVerts[i]
			local pos = modelActorPositions[i]
			pos[1] = modelPos[1] + modelVert[1]
			pos[2] = modelPos[2] + modelVert[2]
			pos[3] = modelPos[3] + modelVert[3]
			world2screen(pos)
		end
		model.actor:SetVertices(model.actorVerts)
	end
end

return scene