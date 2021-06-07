local modules = ...

local function build_floor_mesh()
	local verts = {}
	local indices = {}
	local uv = {}

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

	local x = 0
	local y = 0
	local z = -10

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

	for i=0,2 do
		for j=0,1 do
			add_quad(
				{
					{-30, 0, 0},
					{-10, 0, 0},
					{-10, 0, 10},
					{-30, 0, 10},
				},
				(i%2==0) and uv_default or uv_highlight
			)
			add_quad(
				{
					{-10, 0, 0},
					{ 10, 0, 0},
					{ 10, 0, 10},
					{-10, 0, 10},
				},
				(i%2==0) and uv_highlight or uv_default
			)
			add_quad(
				{
					{10, 0, 0},
					{30, 0, 0},
					{30, 0, 10},
					{10, 0, 10},
				},
				(i%2==0) and uv_default or uv_highlight
			)
			z = z + 10
		end
		add_quad(
			{
				{-30, 0, 0},
				{-20, 0, 0},
				{-20, 0, 10},
				{-30, 0, 10},
			},
			uv_gate
		)
		add_quad(
			{
				{-20, 0, 0},
				{-10, 0, 0},
				{-10, 0, 10},
				{-20, 0, 10},
			},
			uv_gate
		)
		add_quad(
			{
				{-10, 0, 0},
				{  0, 0, 0},
				{  0, 0, 10},
				{-10, 0, 10},
			},
			uv_gate
		)
		add_quad(
			{
				{ 0, 0, 0},
				{10, 0, 0},
				{10, 0, 10},
				{ 0, 0, 10},
			},
			uv_gate
		)
		add_quad(
			{
				{10, 0, 0},
				{20, 0, 0},
				{20, 0, 10},
				{10, 0, 10},
			},
			uv_gate
		)
		add_quad(
			{
				{20, 0, 0},
				{30, 0, 0},
				{30, 0, 10},
				{20, 0, 10},
			},
			uv_gate
		)
		z = z + 10
	end

	add_quad(
		{
			{-30, 0, 0},
			{0, 0, 0},
			{0, 0, 12},
			{-30, 0, 12},
		},
		uv_default
	)

	add_quad(
		{
			{0, 0, 0},
			{30, 0, 0},
			{30, 0, 12},
			{0, 0, 12},
		},
		uv_highlight
	)
	
	z = z + 12

	add_quad(
		{
			{-30, 0, 0},
			{0, 0, 0},
			{-6, 0, 12},
			{-36, 0, 12},
		},
		uv_default
	)

	add_quad(
		{
			{0, 0, 0},
			{30, 0, 0},
			{36, 0, 12},
			{6, 0, 12},
		},
		uv_highlight
	)
	z = z + 12
	add_quad(
		{
			{-36, 0, 0},
			{-6, 0, 0},
			{-12, 0, 12},
			{-42, 0, 12},
		},
		uv_default
	)

	add_quad(
		{
			{6, 0, 0},
			{36, 0, 0},
			{42, 0, 12},
			{12, 0, 12},
		},
		uv_highlight
	)
	z = z + 12

	add_quad(
		{
			{-42, 0, 0},
			{-32, 0, 0},
			{-32, 0, 10},
			{-42, 0, 10},
		},
		uv_gate
	)
	add_quad(
		{
			{-32, 0, 0},
			{-22, 0, 0},
			{-22, 0, 10},
			{-32, 0, 10},
		},
		uv_gate
	)
	add_quad(
		{
			{-22, 0, 0},
			{-12, 0, 0},
			{-12, 0, 10},
			{-22, 0, 10},
		},
		uv_gate
	)
	add_quad(
		{
			{12, 0, 0},
			{22, 0, 0},
			{22, 0, 10},
			{12, 0, 10},
		},
		uv_gate
	)
	add_quad(
		{
			{22, 0, 0},
			{32, 0, 0},
			{32, 0, 10},
			{22, 0, 10},
		},
		uv_gate
	)
	add_quad(
		{
			{32, 0, 0},
			{42, 0, 0},
			{42, 0, 10},
			{32, 0, 10},
		},
		uv_gate
	)
	z = z + 10


	add_quad(
		{
			{-42, 0, 0},
			{-12, 0, 0},
			{-6, 0, 12},
			{-36, 0, 12},
		},
		uv_default
	)

	add_quad(
		{
			{12, 0, 0},
			{42, 0, 0},
			{36, 0, 12},
			{6, 0, 12},
		},
		uv_highlight
	)
	z = z + 12


	add_quad(
		{
			{-36, 0, 0},
			{-6, 0, 0},
			{0, 0, 12},
			{-30, 0, 12},
		},
		uv_default
	)

	add_quad(
		{
			{6, 0, 0},
			{36, 0, 0},
			{30, 0, 12},
			{0, 0, 12},
		},
		uv_highlight
	)
	z = z + 12


	add_quad(
		{
			{-30, 0, 0},
			{-20, 0, 0},
			{-20, 0, 10},
			{-30, 0, 10},
		},
		uv_gate
	)
	add_quad(
		{
			{-20, 0, 0},
			{-10, 0, 0},
			{-10, 0, 10},
			{-20, 0, 10},
		},
		uv_gate
	)
	add_quad(
		{
			{-10, 0, 0},
			{  0, 0, 0},
			{  0, 0, 10},
			{-10, 0, 10},
		},
		uv_gate
	)
	add_quad(
		{
			{ 0, 0, 0},
			{10, 0, 0},
			{10, 0, 10},
			{ 0, 0, 10},
		},
		uv_gate
	)
	add_quad(
		{
			{10, 0, 0},
			{20, 0, 0},
			{20, 0, 10},
			{10, 0, 10},
		},
		uv_gate
	)
	add_quad(
		{
			{20, 0, 0},
			{30, 0, 0},
			{30, 0, 10},
			{20, 0, 10},
		},
		uv_gate
	)
	z = z + 10
	
	
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
	
	for i=1,8 do
		add_quad(
			{
				{-30, 0, 0},
				{-20, 0, 0},
				{-20, -1.5, 12},
				{-30, -1.5, 12},
			},
			uv_slime
		)
		add_quad(
			{
				{-20, 0, 0},
				{-10, 0, 0},
				{-10, -1.5, 12},
				{-20, -1.5, 12},
			},
			uv_slime
		)
		add_quad(
			{
				{-10, 0, 0},
				{0, 0, 0},
				{0, -1.5, 12},
				{-10, -1.5, 12},
			},
			uv_slime
		)
		add_quad(
			{
				{0, 0, 0},
				{10, 0, 0},
				{10, -1.5, 12},
				{0, -1.5, 12},
			},
			uv_slime
		)
		add_quad(
			{
				{10, 0, 0},
				{20, 0, 0},
				{20, -1.5, 12},
				{10, -1.5, 12},
			},
			uv_slime
		)
		add_quad(
			{
				{20, 0, 0},
				{30, 0, 0},
				{30, -1.5, 12},
				{20, -1.5, 12},
			},
			uv_slime
		)
		z = z + 12
		y = y - 1.5
	end

	z = z + 15
	y = y - 8

	add_quad(
		{
			{-30, 0, 0},
			{-20, 0, 0},
			{-20, 0, 10},
			{-30, 0, 10},
		},
		uv_gate
	)
	add_quad(
		{
			{-20, 0, 0},
			{-10, 0, 0},
			{-10, 0, 10},
			{-20, 0, 10},
		},
		uv_gate
	)
	add_quad(
		{
			{-10, 0, 0},
			{  0, 0, 0},
			{  0, 0, 10},
			{-10, 0, 10},
		},
		uv_gate
	)
	add_quad(
		{
			{ 0, 0, 0},
			{10, 0, 0},
			{10, 0, 10},
			{ 0, 0, 10},
		},
		uv_gate
	)
	add_quad(
		{
			{10, 0, 0},
			{20, 0, 0},
			{20, 0, 10},
			{10, 0, 10},
		},
		uv_gate
	)
	add_quad(
		{
			{20, 0, 0},
			{30, 0, 0},
			{30, 0, 10},
			{20, 0, 10},
		},
		uv_gate
	)
	z = z + 10


	for i=1,2 do
		add_quad(
			{
				{-30, 0, 0},
				{30, 0, 0},
				{30, 3, 12},
				{-30, 3, 12},
			},
			uv_default
		)
		z = z + 12
		y = y + 3
	end

	add_quad(
		{
			{-30, 0, 0},
			{-20, 0, 0},
			{-20, 0, 10},
			{-30, 0, 10},
		},
		uv_finish
	)
	add_quad(
		{
			{-20, 0, 0},
			{-10, 0, 0},
			{-10, 0, 10},
			{-20, 0, 10},
		},
		uv_finish
	)
	add_quad(
		{
			{-10, 0, 0},
			{  0, 0, 0},
			{  0, 0, 10},
			{-10, 0, 10},
		},
		uv_finish
	)
	add_quad(
		{
			{ 0, 0, 0},
			{10, 0, 0},
			{10, 0, 10},
			{ 0, 0, 10},
		},
		uv_finish
	)
	add_quad(
		{
			{10, 0, 0},
			{20, 0, 0},
			{20, 0, 10},
			{10, 0, 10},
		},
		uv_finish
	)
	add_quad(
		{
			{20, 0, 0},
			{30, 0, 0},
			{30, 0, 10},
			{20, 0, 10},
		},
		uv_finish
	)
	z = z + 10

	for i=1,4 do
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

	local mesh = {
		draw_mode='DrawMode_Quads',
		verts=verts,
		indices=indices,
		uv=uv,
	}
	return mesh
end

local GateCrashLevel = {
	-- FLOOR GRAPHICS
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
	{
		transform={position={-21,-0.1,148},rotation={0,-0.463648}},
		box={half_size={13.4164,0.1,20.1246}},
	},
	{
		transform={position={21,-0.1,148},rotation={0,0.463648}},
		box={half_size={13.4164,0.1,20.1246}},
	},
	
	{
		transform={position={27,-0.1,165}},
		box={half_size={15,0.1,5}},
	},
	
	{
		transform={position={-27,-0.1,165}},
		box={half_size={15,0.1,5}},
	},


	{
		transform={position={-21,-0.1,182},rotation={0,0.463648}},
		box={half_size={13.4164,0.1,20.1246}},
	},
	{
		transform={position={21,-0.1,182},rotation={0,-0.463648}},
		box={half_size={13.4164,0.1,20.1246}},
	},

	{
		transform={position={0,-0.1,203}},
		box={half_size={30,0.1,9}},
	},
	{
		transform={position={0,-6.1,260},rotation={0.124355,0}},
		box={half_size={30,0.1,48.3735},slippy=true},
	},
	
	{
		transform={position={0,-19.1,328}},
		box={half_size={30,0.1,5}},
	},

	{
		transform={position={0,-16.1,346},rotation={-0.24498,0}},
		box={half_size={30,0.1,12.3693}},
	},
	{
		transform={position={0,-13.1,386}},
		box={half_size={30,0.1,29}},
	},
	
	-- Checkpoint
	{
		transform={position={0,4,206}},
		checkpoint={half_size={30,8,5}},
	},

	-- Goal
	{
		transform={position={0,-5,386}},
		goal={half_size={30,8,27}},
	},

	-- GATE 1 PILLARS
	{
		transform={position={-10,2,58}},
		mesh=modules.meshes.create_box(4, 4, 4),
		material={texture='box.png'},
		box={half_size={2,2,2}},
	},
	{
		transform={position={10,2,58}},
		mesh=modules.meshes.create_box(4, 4, 4),
		material={texture='box.png'},
		box={half_size={2,2,2}},
	},
	{
		transform={position={-30,2,58}},
		mesh=modules.meshes.create_box(4, 4, 4),
		material={texture='box.png'},
		box={half_size={2,2,2}},
	},
	{
		transform={position={30,2,58}},
		mesh=modules.meshes.create_box(4, 4, 4),
		material={texture='box.png'},
		box={half_size={2,2,2}},
	},
	-- GATE 1 GATES
	{
		transform={position={0,2,58}},
		mesh=modules.meshes.create_box(16, 4, 2),
		material={texture='wall_sal.png',translate={0.005,0}},
		physics={velocity={0,0,0}},
		box={half_size={8,2,1}},
		move={
			index=1,
			progress=0,
			stops={
				{velocity={0,-0.05,0,0 },duration=80},
				{velocity={0, 0.05,0,0 },duration=80},
				{velocity={0, 0.00,0,0 },duration=80},
			},
		},
	},
	{
		transform={position={-20,-2,58}},
		mesh=modules.meshes.create_box(16, 4, 2),
		material={texture='wall_sal.png',translate={0.005,0}},
		physics={velocity={0,0,0}},
		box={half_size={8,2,1}},
		move={
			index=2,
			progress=0,
			stops={
				{velocity={0,-0.05,0,0 },duration=80},
				{velocity={0, 0.05,0,0 },duration=80},
				{velocity={0, 0.00,0,0 },duration=80},
			},
		},
	},
	{
		transform={position={20,2,58}},
		mesh=modules.meshes.create_box(16, 4, 2),
		material={texture='wall_sal.png',translate={0.005,0}},
		physics={velocity={0,0,0}},
		box={half_size={8,2,1}},
		move={
			index=3,
			progress=0,
			stops={
				{velocity={0,-0.05,0,0 },duration=80},
				{velocity={0, 0.05,0,0 },duration=80},
				{velocity={0, 0.00,0,0 },duration=80},
			},
		},
	},
	
	-- GATE 2 PILLARS
	{
		transform={position={-10,2,88}},
		mesh=modules.meshes.create_box(4, 4, 4),
		material={texture='box.png'},
		box={half_size={2,2,2}},
	},
	{
		transform={position={10,2,88}},
		mesh=modules.meshes.create_box(4, 4, 4),
		material={texture='box.png'},
		box={half_size={2,2,2}},
	},
	{
		transform={position={-30,2,88}},
		mesh=modules.meshes.create_box(4, 4, 4),
		material={texture='box.png'},
		box={half_size={2,2,2}},
	},
	{
		transform={position={30,2,88}},
		mesh=modules.meshes.create_box(4, 4, 4),
		material={texture='box.png'},
		box={half_size={2,2,2}},
	},

	-- GATE 2 GATES
	{
		transform={position={0,2,88}},
		mesh=modules.meshes.create_box(16, 4, 2),
		material={texture='wall_loam.png',translate={-0.005,0}},
		physics={velocity={0,0,0}},
		box={half_size={8,2,1}},
		move={
			index=1,
			progress=0,
			stops={
				{velocity={0,-0.05,0,0 },duration=80},
				{velocity={0, 0.05,0,0 },duration=80},
				{velocity={0, 0.00,0,0 },duration=80},
			},
		},
	},
	{
		transform={position={-20,-2,88}},
		mesh=modules.meshes.create_box(16, 4, 2),
		material={texture='wall_loam.png',translate={-0.005,0}},
		physics={velocity={0,0,0}},
		box={half_size={8,2,1}},
		move={
			index=2,
			progress=0,
			stops={
				{velocity={0,-0.05,0,0 },duration=80},
				{velocity={0, 0.05,0,0 },duration=80},
				{velocity={0, 0.00,0,0 },duration=80},
			},
		},
	},
	{
		transform={position={20,2,88}},
		mesh=modules.meshes.create_box(16, 4, 2),
		material={texture='wall_loam.png',translate={-0.005,0}},
		physics={velocity={0,0,0}},
		box={half_size={8,2,1}},
		move={
			index=3,
			progress=0,
			stops={
				{velocity={0,-0.05,0,0 },duration=80},
				{velocity={0, 0.05,0,0 },duration=80},
				{velocity={0, 0.00,0,0 },duration=80},
			},
		},
	},

	-- GATE 3 PILLARS
	{
		transform={position={-10,2,118}},
		mesh=modules.meshes.create_box(4, 4, 4),
		material={texture='box.png'},
		box={half_size={2,2,2}},
	},
	{
		transform={position={10,2,118}},
		mesh=modules.meshes.create_box(4, 4, 4),
		material={texture='box.png'},
		box={half_size={2,2,2}},
	},
	{
		transform={position={-30,2,118}},
		mesh=modules.meshes.create_box(4, 4, 4),
		material={texture='box.png'},
		box={half_size={2,2,2}},
	},
	{
		transform={position={30,2,118}},
		mesh=modules.meshes.create_box(4, 4, 4),
		material={texture='box.png'},
		box={half_size={2,2,2}},
	},
	-- GATE 3 GATES
	{
		transform={position={0,2,118}},
		mesh=modules.meshes.create_box(16, 4, 2),
		material={texture='wall_finish.png',translate={0.005,0}},
		physics={velocity={0,0,0}},
		box={half_size={8,2,1}},
		move={
			index=1,
			progress=0,
			stops={
				{velocity={0,-0.05,0,0 },duration=80},
				{velocity={0, 0.05,0,0 },duration=80},
				{velocity={0, 0.00,0,0 },duration=80},
			},
		},
	},
	{
		transform={position={-20,-2,118}},
		mesh=modules.meshes.create_box(16, 4, 2),
		material={texture='wall_finish.png',translate={0.005,0}},
		physics={velocity={0,0,0}},
		box={half_size={8,2,1}},
		move={
			index=2,
			progress=0,
			stops={
				{velocity={0,-0.05,0,0 },duration=80},
				{velocity={0, 0.05,0,0 },duration=80},
				{velocity={0, 0.00,0,0 },duration=80},
			},
		},
	},
	{
		transform={position={20,2,118}},
		mesh=modules.meshes.create_box(16, 4, 2),
		material={texture='wall_finish.png',translate={0.005,0}},
		physics={velocity={0,0,0}},
		box={half_size={8,2,1}},
		move={
			index=3,
			progress=0,
			stops={
				{velocity={0,-0.05,0,0 },duration=80},
				{velocity={0, 0.05,0,0 },duration=80},
				{velocity={0, 0.00,0,0 },duration=80},
			},
		},
	},
	
	-- GATE 4 LEFT PILLARS
	{
		transform={position={-12,2,164}},
		mesh=modules.meshes.create_box(2, 4, 4),
		material={texture='box.png'},
		box={half_size={1,2,2}},
	},
	{
		transform={position={-22,2,164}},
		mesh=modules.meshes.create_box(2, 4, 4),
		material={texture='box.png'},
		box={half_size={1,2,2}},
	},
	{
		transform={position={-32,2,164}},
		mesh=modules.meshes.create_box(2, 4, 4),
		material={texture='box.png'},
		box={half_size={1,2,2}},
	},
	{
		transform={position={-42,2,164}},
		mesh=modules.meshes.create_box(2, 4, 4),
		material={texture='box.png'},
		box={half_size={1,2,2}},
	},

	-- GATE 4 LEFT GATES
	{
		transform={position={-17,2,164}},
		mesh=modules.meshes.create_box(8, 4, 2),
		material={texture='wall_dunk.png',translate={0.01,0}},
		physics={velocity={0,0,0}},
		box={half_size={4,2,1}},
		move={
			index=1,
			progress=0,
			stops={
				{velocity={0,-0.1,0,0 },duration=40},
				{velocity={0, 0.1,0,0 },duration=40},
				{velocity={0, 0.0,0,0 },duration=40},
			},
		},
	},
	{
		transform={position={-27,-2,164}},
		mesh=modules.meshes.create_box(8, 4, 2),
		material={texture='wall_dunk.png',translate={0.01,0}},
		physics={velocity={0,0,0}},
		box={half_size={4,2,1}},
		move={
			index=2,
			progress=0,
			stops={
				{velocity={0,-0.1,0,0 },duration=40},
				{velocity={0, 0.1,0,0 },duration=40},
				{velocity={0, 0.0,0,0 },duration=40},
			},
		},
	},
	{
		transform={position={-37,2,164}},
		mesh=modules.meshes.create_box(8, 4, 2),
		material={texture='wall_dunk.png',translate={0.01,0}},
		physics={velocity={0,0,0}},
		box={half_size={4,2,1}},
		move={
			index=3,
			progress=0,
			stops={
				{velocity={0,-0.1,0,0 },duration=40},
				{velocity={0, 0.1,0,0 },duration=40},
				{velocity={0, 0.0,0,0 },duration=40},
			},
		},
	},

	-- GATE 4 RIGHT PILLARS
	{
		transform={position={12,2,164}},
		mesh=modules.meshes.create_box(2, 4, 4),
		material={texture='box.png'},
		box={half_size={1,2,2}},
	},
	{
		transform={position={22,2,164}},
		mesh=modules.meshes.create_box(2, 4, 4),
		material={texture='box.png'},
		box={half_size={1,2,2}},
	},
	{
		transform={position={32,2,164}},
		mesh=modules.meshes.create_box(2, 4, 4),
		material={texture='box.png'},
		box={half_size={1,2,2}},
	},
	{
		transform={position={42,2,164}},
		mesh=modules.meshes.create_box(2, 4, 4),
		material={texture='box.png'},
		box={half_size={1,2,2}},
	},

	-- GATE 4 RIGHT GATES
	{
		transform={position={17,2,164}},
		mesh=modules.meshes.create_box(8, 4, 2),
		material={texture='wall_dunk.png',translate={-0.005,0}},
		physics={velocity={0,0,0}},
		box={half_size={4,2,1}},
		move={
			index=1,
			progress=0,
			stops={
				{velocity={0,-0.1,0,0 },duration=40},
				{velocity={0, 0.1,0,0 },duration=40},
				{velocity={0, 0.0,0,0 },duration=40},
			},
		},
	},
	{
		transform={position={27,-2,164}},
		mesh=modules.meshes.create_box(8, 4, 2),
		material={texture='wall_dunk.png',translate={-0.005,0}},
		physics={velocity={0,0,0}},
		box={half_size={4,2,1}},
		move={
			index=2,
			progress=0,
			stops={
				{velocity={0,-0.1,0,0 },duration=40},
				{velocity={0, 0.1,0,0 },duration=40},
				{velocity={0, 0.0,0,0 },duration=40},
			},
		},
	},
	{
		transform={position={37,2,164}},
		mesh=modules.meshes.create_box(8, 4, 2),
		material={texture='wall_dunk.png',translate={-0.005,0}},
		physics={velocity={0,0,0}},
		box={half_size={4,2,1}},
		move={
			index=3,
			progress=0,
			stops={
				{velocity={0,-0.1,0,0 },duration=40},
				{velocity={0, 0.1,0,0 },duration=40},
				{velocity={0, 0.0,0,0 },duration=40},
			},
		},
	},

	-- GATE 5 PILLARS
	{
		transform={position={-30,2,198}},
		mesh=modules.meshes.create_box(2, 4, 4),
		material={texture='box.png'},
		box={half_size={1,2,2}},
	},
	{
		transform={position={-20,2,198}},
		mesh=modules.meshes.create_box(2, 4, 4),
		material={texture='box.png'},
		box={half_size={1,2,2}},
	},
	{
		transform={position={-10,2,198}},
		mesh=modules.meshes.create_box(2, 4, 4),
		material={texture='box.png'},
		box={half_size={1,2,2}},
	},
	{
		transform={position={0,2,198}},
		mesh=modules.meshes.create_box(2, 4, 4),
		material={texture='box.png'},
		box={half_size={1,2,2}},
	},
	{
		transform={position={10,2,198}},
		mesh=modules.meshes.create_box(2, 4, 4),
		material={texture='box.png'},
		box={half_size={1,2,2}},
	},
	{
		transform={position={20,2,198}},
		mesh=modules.meshes.create_box(2, 4, 4),
		material={texture='box.png'},
		box={half_size={1,2,2}},
	},
	{
		transform={position={30,2,198}},
		mesh=modules.meshes.create_box(2, 4, 4),
		material={texture='box.png'},
		box={half_size={1,2,2}},
	},

	-- GATE 5 GATES
	{
		transform={position={-25,2,198}},
		mesh=modules.meshes.create_box(8, 4, 2),
		material={texture='wall_haha.png',translate={-0.005,0}},
		physics={velocity={0,0,0}},
		box={half_size={4,2,1}},
		move={
			index=1,
			progress=0,
			stops={
				{velocity={0,-0.1,0,0 },duration=40},
				{velocity={0, 0.1,0,0 },duration=40},
				{velocity={0, 0.0,0,0 },duration=40},
			},
		},
	},
	{
		transform={position={-15,-2,198}},
		mesh=modules.meshes.create_box(8, 4, 2),
		material={texture='wall_haha.png',translate={-0.005,0}},
		physics={velocity={0,0,0}},
		box={half_size={4,2,1}},
		move={
			index=2,
			progress=0,
			stops={
				{velocity={0,-0.1,0,0 },duration=40},
				{velocity={0, 0.1,0,0 },duration=40},
				{velocity={0, 0.0,0,0 },duration=40},
			},
		},
	},
	{
		transform={position={-5,2,198}},
		mesh=modules.meshes.create_box(8, 4, 2),
		material={texture='wall_haha.png',translate={-0.005,0}},
		physics={velocity={0,0,0}},
		box={half_size={4,2,1}},
		move={
			index=3,
			progress=0,
			stops={
				{velocity={0,-0.1,0,0 },duration=40},
				{velocity={0, 0.1,0,0 },duration=40},
				{velocity={0, 0.0,0,0 },duration=40},
			},
		},
	},

	{
		transform={position={5,2,198}},
		mesh=modules.meshes.create_box(8, 4, 2),
		material={texture='wall_haha.png',translate={0.005,0}},
		physics={velocity={0,0,0}},
		box={half_size={4,2,1}},
		move={
			index=1,
			progress=0,
			stops={
				{velocity={0,-0.1,0,0 },duration=40},
				{velocity={0, 0.1,0,0 },duration=40},
				{velocity={0, 0.0,0,0 },duration=40},
			},
		},
	},
	{
		transform={position={15,-2,198}},
		mesh=modules.meshes.create_box(8, 4, 2),
		material={texture='wall_haha.png',translate={0.005,0}},
		physics={velocity={0,0,0}},
		box={half_size={4,2,1}},
		move={
			index=2,
			progress=0,
			stops={
				{velocity={0,-0.1,0,0 },duration=40},
				{velocity={0, 0.1,0,0 },duration=40},
				{velocity={0, 0.0,0,0 },duration=40},
			},
		},
	},
	{
		transform={position={25,2,198}},
		mesh=modules.meshes.create_box(8, 4, 2),
		material={texture='wall_haha.png',translate={0.005,0}},
		physics={velocity={0,0,0}},
		box={half_size={4,2,1}},
		move={
			index=3,
			progress=0,
			stops={
				{velocity={0,-0.1,0,0 },duration=40},
				{velocity={0, 0.1,0,0 },duration=40},
				{velocity={0, 0.0,0,0 },duration=40},
			},
		},
	},

	-- GATE 6 PILLARS
	{
		transform={position={-30,-15,328}},
		mesh=modules.meshes.create_box(2, 8, 10),
		material={texture='box.png'},
		box={half_size={1,4,5}},
	},
	{
		transform={position={-10,-15,328}},
		mesh=modules.meshes.create_box(2, 8, 10),
		material={texture='box.png'},
		box={half_size={1,4,5}},
	},
	{
		transform={position={10,-15,328}},
		mesh=modules.meshes.create_box(2, 8, 10),
		material={texture='box.png'},
		box={half_size={1,4,5}},
	},
	{
		transform={position={30,-15,328}},
		mesh=modules.meshes.create_box(2, 8, 10),
		material={texture='box.png'},
		box={half_size={1,4,5}},
	},

	-- GATE 6 GATES
	{
		transform={position={-20,-15,328}},
		mesh=modules.meshes.create_box(18, 8, 10),
		material={texture='wall_fof.png',translate={0.005,0}},
		physics={velocity={0,0,0}},
		box={half_size={9,4,5}},
		move={
			index=1,
			progress=0,
			stops={
				{velocity={0,-0.1,0,0 },duration=80},
				{velocity={0, 0.1,0,0 },duration=80},
				{velocity={0, 0.0,0,0 },duration=80},
			},
		},
	},
	{
		transform={position={0,-22.9,328}},
		mesh=modules.meshes.create_box(18, 8, 10),
		material={texture='wall_fof.png',translate={0.005,0}},
		physics={velocity={0,0,0}},
		box={half_size={9,4,5}},
		move={
			index=2,
			progress=0,
			stops={
				{velocity={0,-0.1,0,0 },duration=80},
				{velocity={0, 0.1,0,0 },duration=80},
				{velocity={0, 0.0,0,0 },duration=80},
			},
		},
	},
	{
		transform={position={20,-15,328}},
		mesh=modules.meshes.create_box(18, 8, 10),
		material={texture='wall_fof.png',translate={0.005,0}},
		physics={velocity={0,0,0}},
		box={half_size={9,4,5}},
		move={
			index=3,
			progress=0,
			stops={
				{velocity={0,-0.1,0,0 },duration=80},
				{velocity={0, 0.1,0,0 },duration=80},
				{velocity={0, 0.0,0,0 },duration=80},
			},
		},
	},
	
	-- BUMPERS 1
	{
		transform={position={2,2,80}},
		mesh=modules.meshes.create_box(2, 4, 2),
		material={texture='box.png'},
		physics={velocity={0,0,0}},
		box={half_size={1,2,1}},
		move={
			index=1,
			progress=0,
			stops={
				{velocity={0.25, 0,0,0 },duration=110},
				{velocity={-0.25,0,0,0 },duration=110},
			},
		},
	},
	{
		transform={position={-2,2,80}},
		mesh=modules.meshes.create_box(2, 4, 2),
		material={texture='box.png'},
		physics={velocity={0,0,0}},
		box={half_size={1,2,1}},
		move={
			index=2,
			progress=0,
			stops={
				{velocity={0.25, 0,0,0 },duration=110},
				{velocity={-0.25,0,0,0 },duration=110},
			},
		},
	},
	
	-- BUMPERS 2
	{
		transform={position={2,2,110}},
		mesh=modules.meshes.create_box(2, 4, 2),
		material={texture='box.png'},
		physics={velocity={0,0,0}},
		box={half_size={1,2,1}},
		move={
			index=1,
			progress=0,
			stops={
				{velocity={0.25, 0,0,0 },duration=110},
				{velocity={-0.25,0,0,0 },duration=110},
			},
		},
	},
	{
		transform={position={-2,2,110}},
		mesh=modules.meshes.create_box(2, 4, 2),
		material={texture='box.png'},
		physics={velocity={0,0,0}},
		box={half_size={1,2,1}},
		move={
			index=2,
			progress=0,
			stops={
				{velocity={0.25, 0,0,0 },duration=110},
				{velocity={-0.25,0,0,0 },duration=110},
			},
		},
	},
	-- BUMPERS 3
	{
		transform={position={14,2,158}},
		mesh=modules.meshes.create_box(2, 4, 2),
		material={texture='box.png'},
		physics={velocity={0,0,0}},
		box={half_size={1,2,1}},
		move={
			index=1,
			progress=0,
			stops={
				{velocity={0.25, 0,0,0 },duration=110},
				{velocity={-0.25,0,0,0 },duration=110},
			},
		},
	},
	{
		transform={position={-14,2,158}},
		mesh=modules.meshes.create_box(2, 4, 2),
		material={texture='box.png'},
		physics={velocity={0,0,0}},
		box={half_size={1,2,1}},
		move={
			index=2,
			progress=0,
			stops={
				{velocity={0.25, 0,0,0 },duration=110},
				{velocity={-0.25,0,0,0 },duration=110},
			},
		},
	},
	-- BUMPERS 4
	{
		transform={position={2,2,190}},
		mesh=modules.meshes.create_box(2, 4, 2),
		material={texture='box.png'},
		physics={velocity={0,0,0}},
		box={half_size={1,2,1}},
		move={
			index=1,
			progress=0,
			stops={
				{velocity={0.25, 0,0,0 },duration=110},
				{velocity={-0.25,0,0,0 },duration=110},
			},
		},
	},
	{
		transform={position={-2,2,190}},
		mesh=modules.meshes.create_box(2, 4, 2),
		material={texture='box.png'},
		physics={velocity={0,0,0}},
		box={half_size={1,2,1}},
		move={
			index=2,
			progress=0,
			stops={
				{velocity={0.25, 0,0,0 },duration=110},
				{velocity={-0.25,0,0,0 },duration=110},
			},
		},
	},
}

local p1_enabled = FOF_GUYS_GLOBAL_STATE.is_player_joined[1]
local p2_enabled = FOF_GUYS_GLOBAL_STATE.is_player_joined[2]

if p1_enabled then
	GateCrashLevel[#GateCrashLevel+1] = {
		transform={position={p2_enabled and -2 or 0,2,0},rotation={0,0}},
		ball={radius=0.65,bounce_height=4,spawn_position={0,2,0}},
		physics={velocity={0,0,0},gravity=true},
		input={player=1},
	}
	local p1_entity_id = #GateCrashLevel
	GateCrashLevel[#GateCrashLevel+1] = {
		transform={position={0,5,-20},rotation={0.195,0}},
		camera={player_index=1},
		follow={target_id=p1_entity_id,offset={0,15,-50}},
	}
end

if p2_enabled then
	GateCrashLevel[#GateCrashLevel+1] = {
		transform={position={p1_enabled and 2 or 0,2,0},rotation={0,0}},
		ball={radius=0.65,bounce_height=4,spawn_position={0,2,0}},
		physics={velocity={0,0,0},gravity=true},
		input={player=2},
	}
	local p2_entity_id = #GateCrashLevel
	GateCrashLevel[#GateCrashLevel+1] = {
		transform={position={0,5,-20},rotation={0.195,0}},
		camera={player_index=2},
		follow={target_id=p2_entity_id,offset={0,15,-50}},
	}
end

return GateCrashLevel