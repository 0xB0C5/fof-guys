local meshes = {}

local uv00 = {0,0}
local uv01 = {0,1}
local uv10 = {1,0}
local uv11 = {1,1}

meshes.box = {
	draw_mode='DrawMode_Quads',
	verts={
		{-1,-1,-1}, -- 1
		{-1,-1, 1}, -- 2
		{-1, 1,-1}, -- 3
		{-1, 1, 1}, -- 4
		{ 1,-1,-1}, -- 5
		{ 1,-1, 1}, -- 6
		{ 1, 1,-1}, -- 7
		{ 1, 1, 1}, -- 8
	},
	indices={
		1, 2, 4, 3,
		5, 6, 8, 7,

		1, 2, 6, 5,
		3, 4, 8, 7,

		1, 3, 7, 5,
		2, 4, 8, 6,
	},
	uv={
		uv00, uv01, uv11, uv10,
		uv00, uv01, uv11, uv10,
		uv00, uv01, uv11, uv10,
		uv00, uv01, uv11, uv10,
		uv00, uv01, uv11, uv10,
		uv00, uv01, uv11, uv10,
	},
}

meshes.create_box = function(width, height, depth)
	local dx = 0.5*width
	local dy = 0.5*height
	local dz = 0.5*depth
	return {
		draw_mode='DrawMode_Quads',
		verts={
			{-dx,-dy,-dz}, -- 1
			{-dx,-dy, dz}, -- 2
			{-dx, dy,-dz}, -- 3
			{-dx, dy, dz}, -- 4
			{ dx,-dy,-dz}, -- 5
			{ dx,-dy, dz}, -- 6
			{ dx, dy,-dz}, -- 7
			{ dx, dy, dz}, -- 8
		},
		indices={
			1, 2, 4, 3,
			5, 6, 8, 7,

			1, 2, 6, 5,
			3, 4, 8, 7,

			1, 3, 7, 5,
			2, 4, 8, 6,
		},
		uv={
			uv00, uv01, uv11, uv10,
			uv00, uv01, uv11, uv10,
			uv00, uv01, uv11, uv10,
			uv00, uv01, uv11, uv10,
			uv00, uv01, uv11, uv10,
			uv00, uv01, uv11, uv10,
		},
	}
end


meshes.floor = {
	draw_mode='DrawMode_Quads',
	verts = {
		{-10,0.1,-10}, -- 1
		{-10,0.1, 10}, -- 2
		{ 10,0.1,-10}, -- 3
		{ 10,0.1, 10}, -- 4
	},
	indices = {
		1, 2, 4, 3,
	},
	uv = {
		uv00, uv01, uv11, uv10,
	}
}

meshes.create_plane = function(width, depth, y, grid_width, grid_depth)
	local verts = {}
	local indices = {}
	local uv = {}

	local x0 = -0.5*width
	local z0 = -0.5*depth
	local dx = width / grid_width
	local dz = depth / grid_depth

	for grid_x=0,grid_width do
		local x = x0 + grid_x * dx
		for grid_z=0,grid_depth do
			local z = z0 + grid_z * dz
			verts[#verts+1] = {x, y, z}
		end
	end

	for grid_x=0,grid_width-1 do
		for grid_z=0,grid_depth-1 do
			indices[#indices+1] = grid_x + 1 + grid_z*(grid_width+1)
			indices[#indices+1] = grid_x + 2 + grid_z*(grid_width+1)
			indices[#indices+1] = grid_x + 2 + (grid_z+1)*(grid_width+1)
			indices[#indices+1] = grid_x + 1 + (grid_z+1)*(grid_width+1)

			uv[#uv+1] = {grid_z/grid_depth,1-grid_x/grid_width}
			uv[#uv+1] = {grid_z/grid_depth,1-(grid_x+1)/grid_width}
			uv[#uv+1] = {(grid_z+1)/grid_depth,1-(grid_x+1)/grid_width}
			uv[#uv+1] = {(grid_z+1)/grid_depth,1-grid_x/grid_width}
		end
	end

	return {
		draw_mode='DrawMode_Quads',
		verts=verts,
		indices=indices,
		uv=uv,
	}
end

return meshes