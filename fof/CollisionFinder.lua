
-- TODO : if this is too slow, use like an octree or something.
-- TODO : actually this isn't used??????!?!?!?!
local function CollisionFinder()
	local static_colliders
	local collision_handler
	
	local function set_collision_handler(handler)
		collision_handler = handler
	end
	
	local function set_static_colliders(colliders)
		static_colliders = colliders
	end

	local function check_collision(a, b)
		
	end

	local function find_collisions(dynamic_colliders)
		for _, static_collider in ipairs(static_colliders) do
			for _, dynamic_collider in ipairs(dynamic_colliders) do
				check_collision(static_collider, dynamic_collider)
			end
		end

		for i=1,#dynamic_colliders-1 do
			for j=i+1,#dynamic_colliders do
				check_collision(dynamic_colliders[i], dynamic_colliders[j])
			end
		end
	end
end
