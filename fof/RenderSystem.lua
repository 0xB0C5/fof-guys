local modules = ...

local max = math.max
local min = math.min

local set_cur_rotation = modules.Math3D.set_cur_rotation
local rotate = modules.Math3D.rotate
local unrotate = modules.Math3D.unrotate


local RenderSystem = {}

local dynamic_meshes_by_entity_id = {}

local temp_vector = {0,0,0}

local CAM_C = 1000

RenderSystem.actor_root = Def.ActorFrame {
	InitCommand=function(self)
		self:xy(SCREEN_CENTER_X, SCREEN_CENTER_Y)
	end,
}


local scene_actors = {{},{}}

local human_player_indices = {}
for player_index=1,2 do
	if GAMESTATE:IsHumanPlayer('PlayerNumber_P' .. player_index) then
		human_player_indices[#human_player_indices + 1] = player_index
	end
end

local is_multiplayer = #human_player_indices > 1

local y_offset_by_player
local y_min_by_player
local y_max_by_player

if is_multiplayer then
	y_offset_by_player = {
		-0.25*SCREEN_HEIGHT,
		0.25*SCREEN_HEIGHT,
	}
	y_min_by_player = {
		-SCREEN_HEIGHT,
		0,
	}
	y_max_by_player = {
		0,
		SCREEN_HEIGHT,
	}
else
	y_offset_by_player = { 0, 0 }
	y_min_by_player = { -SCREEN_HEIGHT, -SCREEN_HEIGHT }
	y_max_by_player = { SCREEN_HEIGHT, SCREEN_HEIGHT }
end

RenderSystem.init = function(ECS)
	local actor_defs = {}

	for _, player_index in ipairs(human_player_indices) do

		for _, entity_id in ipairs(ECS.get_entity_ids_with_component('mesh')) do
			local entity = ECS.entities[entity_id]

			actor_defs[#actor_defs+1] = Def.ActorMultiVertex {
				InitCommand=function(self)
					scene_actors[player_index][entity_id] = self
					if entity.material ~= nil then
						local texture = entity.material.texture
						if texture ~= nil then
							self:LoadTexture(GAMESTATE:GetCurrentSong():GetSongDir() .. 'fof/img/' .. entity.material.texture)
						end
					end
					self:SetDrawState({Mode=entity.mesh.draw_mode})
					self:SetNumVertices(#entity.mesh.indices)
					self:ztest(true)
					self:zwrite(true)
					self:texturewrapping(true)
				end,
			}

			-- In order to render 3D content,
			-- we keep a copy of each mesh that we update every frame
			-- based on the entity's and camera's position.
			-- verts is a list of *distinct* vertices in the mesh
			-- actor_verts are the vertices in the form that ActorMultiVertex:SetVertices() accepts,
			--   which requires duplicate vertices to be included.
			-- The vertices within verts and actor_verts are the same instances,
			--   which allows us to update all duplicate vertices within actor_verts in a single update to a vertex in verts.
			-- e.g.
			--   In this case, there are 2 distinct vertices but each appears twice in actor_verts:
			--     verts = {{0,0,0}, {1,1,1}}
			--     actor_verts = {{verts[1], white, {0,0}}, {verts[1], white, {0,0}}, {verts[2], white, {0,0}}, {verts[2], white, {0,0}}}
			--   by updating verts[1], actor_verts[1] and actor_verts[2] are both updated:
			--     verts[1][1] = 1
			--   thus, we cut the number of vertex updates we need to do in half.
			local dynamic_mesh = {
				verts={},
				actor_verts={},
			}

			for i=1,#entity.mesh.verts do
				dynamic_mesh.verts[i] = {0,0,0}
			end

			local color = {1,1,1,1}
			for dest_index, src_index in ipairs(entity.mesh.indices) do
				dynamic_mesh.actor_verts[dest_index] = {
					dynamic_mesh.verts[src_index],
					color,
					entity.mesh.uv[dest_index],
				}
			end

			dynamic_meshes_by_entity_id[entity_id] = dynamic_mesh
		end

		for _, entity_id in ipairs(ECS.get_entity_ids_with_component('ball')) do
			local entity = ECS.entities[entity_id]
			local texture = entity.material and entity.material.texture or 'ball.png'

			actor_defs[#actor_defs+1] = LoadActor('img/' .. texture) .. {
				InitCommand=function(self)
					scene_actors[player_index][entity_id] = self
					self:ztest(true)
					self:zwrite(true)
					self:visible(false)
				end,
			}
		end
	end

	for i=1,#actor_defs do
		RenderSystem.actor_root[#RenderSystem.actor_root + 1] = actor_defs[i]
	end
end

RenderSystem.update = function(ECS)

	for _, player_index in ipairs(human_player_indices) do
		local camera
		for _, camera_id in ipairs(ECS.get_entity_ids_with_component('camera')) do
			camera = ECS.entities[camera_id]
			if camera.camera.player_index == player_index then
				break
			end
		end

		local camera_position = camera.transform.position
		local camera_x = camera_position[1]
		local camera_y = camera_position[2]
		local camera_z = camera_position[3]

		local player_actors = scene_actors[player_index]
		local player_y_offset = y_offset_by_player[player_index]
		local player_y_min = y_min_by_player[player_index]
		local player_y_max = y_max_by_player[player_index]
		for _, entity_id in ipairs(ECS.get_entity_ids_with_component('mesh')) do
			local entity = ECS.entities[entity_id]

			local mesh = entity.mesh
			local mesh_verts = mesh.verts

			local dynamic_mesh = dynamic_meshes_by_entity_id[entity_id]
			local dynamic_verts = dynamic_mesh.verts

			local transform = entity.transform
			local base_pos = transform.position
			local dx = base_pos[1] - camera_x
			local dy = base_pos[2] - camera_y
			local dz = base_pos[3] - camera_z

			local dist_squared = (
				  dx*dx
				+ dy*dy
				+ dz*dz
			)

			local actor = player_actors[entity_id]

			set_cur_rotation(transform.rotation)
			for i=1,#mesh_verts do
				local mesh_vert = mesh_verts[i]
				local dynamic_vert = dynamic_verts[i]
				dynamic_vert[1] = mesh_vert[1]
				dynamic_vert[2] = mesh_vert[2]
				dynamic_vert[3] = mesh_vert[3]
				rotate(dynamic_vert)
			end

			set_cur_rotation(camera.transform.rotation)
			for i=1,#mesh_verts do
				local mesh_vert = mesh_verts[i]
				local dynamic_vert = dynamic_verts[i]
				dynamic_vert[1] = dynamic_vert[1] + dx
				dynamic_vert[2] = dynamic_vert[2] + dy
				dynamic_vert[3] = dynamic_vert[3] + dz

				unrotate(dynamic_vert)

				local z = dynamic_vert[3]

				if z <= 0 then
					dynamic_vert[1] = 0/0
					dynamic_vert[2] = 0/0
					dynamic_vert[3] = 0/0
				else
					dynamic_vert[1] = dynamic_vert[1] * CAM_C / z
					dynamic_vert[2] = max(
						player_y_min,
						min(
							player_y_max,
							-dynamic_vert[2] * CAM_C / z + player_y_offset
						)
					)
					dynamic_vert[3] = -z
				end
			end

			actor:visible(true):SetVertices(dynamic_mesh.actor_verts)
			local material = entity.material
			if material ~= nil then
				local color = material.color
				if color ~= nil then
					actor:diffuse(color)
				end
				local translate = material.translate
				if translate ~= nil then
					actor:texturetranslate(translate[1]*ECS.frame_count, translate[2]*ECS.frame_count)
				end
			end
		end

		set_cur_rotation(camera.transform.rotation)
		for _, entity_id in ipairs(ECS.get_entity_ids_with_component('ball')) do
			local entity = ECS.entities[entity_id]
			local position = entity.transform.position
			local actor = player_actors[entity_id]

			temp_vector[1] = position[1] - camera_x
			temp_vector[2] = position[2] - camera_y
			temp_vector[3] = position[3] - camera_z
			
			unrotate(temp_vector)

			local z = temp_vector[3]
			if z <= 0 then
				actor:visible(false)
			else
				local sx = temp_vector[1] * CAM_C / z
				local sy = -temp_vector[2] * CAM_C / z + player_y_offset

				local size = entity.ball.radius * 2 * CAM_C / z

				actor
					:xy(sx,sy)
					:z(-z)
					:zoomtowidth(size)
					:zoomtoheight(size)
					:visible(player_y_min <= sy and sy <= player_y_max)
			end
		end
	end
end

return RenderSystem
