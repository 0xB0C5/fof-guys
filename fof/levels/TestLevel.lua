local modules = ...


local TestLevel = {
	{
		transform={position={0,4,20},rotation={0,0}},
		ball={radius=0.5,bounce_height=4},
		physics={velocity={0,0,0},gravity=true},
		input={},
	},
	{
		transform={position={0,5,0},rotation={0.1,0}},
		camera={},
		follow={entity_id=1,offset={0,6,-30}},
	},
	{
		transform={position={0,2,20},rotation={0.1,math.pi/2}},
		mesh=modules.meshes.box,
		material={texture='sal.png'},
		box={half_size={1,1,1}},
		spin={0,0.01},
	},
	{
		transform={position={2.5,2,20},rotation={-0.1,math.pi/2}},
		mesh=modules.meshes.box,
		material={texture='sal.png'},
		physics={velocity={0,0,0}},
		box={half_size={1,1,1}},
		move={
			index=1,
			progress=0,
			stops={
				{velocity={ 0.1,0,0 },duration=60},
				{velocity={ 0.0,0,0 },duration=60},
				{velocity={-0.1,0,0 },duration=60},
				{velocity={ 0.0,0,0 },duration=60},
			},
		},
	},
	{
		transform={position={0,0,20}},
		mesh=modules.meshes.create_plane(20, 20, 0.1, 4, 4),
		material={texture='sal.png'},
		box={half_size={10,0.1,10}},
	},
}

return TestLevel