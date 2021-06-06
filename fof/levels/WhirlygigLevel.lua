local modules = ...


local function build_floor_mesh()

	local verts = {}
	local indices = {}
	local uv = {}

	local x = 0
	local y = 0
	local z = -10

	local uv_default = {
		{0.00,0.99},
		{0.00,0.99},
		{0.00,0.99},
		{0.00,0.99},
	}

	local uv_arrow = {
		{ 1/128,127/128},
		{65/128,127/128},
		{65/128, 65/128},
		{ 1/128, 65/128},
	}
	local uv_highlight = {
		{0.99,0.00},
		{0.99,0.00},
		{0.99,0.00},
		{0.99,0.00},
	}

	local uv_gate = {
		{ 1/128, 1/128},
		{65/128, 1/128},
		{65/128,63/128},
		{ 1/128,63/128},
	}

	local uv_finish = {
		{67/128, 1/128},
		{99/128, 1/128},
		{99/128,33/128},
		{67/127,33/128},
	}

	local uv_slime = {
		{67/128,35/128},
		{99/128,35/128},
		{99/128,67/128},
		{67/128,67/128},
	}


	local uv_slime_mirrored = {
		{99/128,35/128},
		{67/128,35/128},
		{67/128,67/128},
		{99/128,67/128},
	}
	local function add_quad(quad_verts, quad_uv)
		for i=1,4 do
			verts[#verts+1] = {
				x+quad_verts[i][1],
				y+quad_verts[i][2],
				z+quad_verts[i][3],
			}
			indices[#indices+1] = #verts
			uv[#uv+1] = quad_uv[i]
		end
	end

	for i=1,3 do
		add_quad(
			{
				{-30, 0, 0},
				{30, 0, 0},
				{30, 0, 12},
				{-30, 0, 12},
			},
			uv_default
		)
		z = z + 12
	end


	local arrow_size = 8
	add_quad(
		{
			{-30, 0, 0},
			{-20-0.5*arrow_size, 0, 0},
			{-20-0.5*arrow_size, 0, arrow_size},
			{-30, 0, arrow_size},
		},
		uv_default
	)
	add_quad(
		{
			{-20-0.5*arrow_size, 0, 0},
			{-20+0.5*arrow_size, 0, 0},
			{-20+0.5*arrow_size, 0, arrow_size},
			{-20-0.5*arrow_size, 0, arrow_size},
		},
		uv_arrow
	)
	add_quad(
		{
			{-20+0.5*arrow_size, 0, 0},
			{0-0.5*arrow_size, 0, 0},
			{0-0.5*arrow_size, 0, arrow_size},
			{-20+0.5*arrow_size, 0, arrow_size},
		},
		uv_default
	)
	add_quad(
		{
			{0-0.5*arrow_size, 0, 0},
			{0+0.5*arrow_size, 0, 0},
			{0+0.5*arrow_size, 0, arrow_size},
			{0-0.5*arrow_size, 0, arrow_size},
		},
		uv_arrow
	)
	add_quad(
		{
			{0+0.5*arrow_size, 0, 0},
			{20-0.5*arrow_size, 0, 0},
			{20-0.5*arrow_size, 0, arrow_size},
			{0+0.5*arrow_size, 0, arrow_size},
		},
		uv_default
	)
	add_quad(
		{
			{20-0.5*arrow_size, 0, 0},
			{20+0.5*arrow_size, 0, 0},
			{20+0.5*arrow_size, 0, arrow_size},
			{20-0.5*arrow_size, 0, arrow_size},
		},
		uv_arrow
	)
	add_quad(
		{
			{20+0.5*arrow_size, 0, 0},
			{30, 0, 0},
			{30, 0, arrow_size},
			{20+0.5*arrow_size, 0, arrow_size},
		},
		uv_default
	)

	z = z + arrow_size

	local half_width = 30
	for i=1,8 do
		add_quad(
			{
				{-half_width, 0, 0},
				{half_width, 0, 0},
				{half_width-2, -2, 12},
				{2-half_width, -2, 12},
			},
			uv_default
		)
		z = z + 12
		y = y - 2
		half_width = half_width - 2
	end
	

	return {
		draw_mode='DrawMode_Quads',
		verts=verts,
		indices=indices,
		uv=uv,
	}
end


local WhirlygigLevel = {
	{
		transform={position={0,2,0},rotation={0,0}},
		ball={radius=0.65,bounce_height=4,spawn_position={0,2,0}},
		physics={velocity={0,0,0},gravity=true},
		input={},
	},
	{
		transform={position={0,5,-20},rotation={0.195,0}},
		camera={},
		follow={entity_id=1,offset={0,15,-50}},
	},
	{
		transform={position={0,0,0}},
		mesh=build_floor_mesh(),
		material={texture='floor.png'},
	},

	-- FLOOR COLLISION
	{
		transform={position={0,-0.1,63}},
		box={half_size={30,0.1,73}},
	},
}

return WhirlygigLevel
