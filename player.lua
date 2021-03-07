ship={
	x=0,
	y=32,
	z=0,
	vx=0,
	vy=0,
	vz=0,
	floor=32,
	onground=true,
	ftimer=0,
	jhtimer=0,
	
	sensor_f=0,
	sensor_l=0,
	sensor_r=0,
	sensor_b=0,
	
	aabb_min={x=-7,y=-5,z=-4},
	aabb_max={x=7,y=0,z=4}
}

function detect_sensors()
	-- find block in course
	local p=vec3(ship.x,ship.y,ship.z)
	local srowi, sblocki = get_block_idx(p)
	local rowi, blocki
	local block
	local nearest,highest
	
	-- bottom
	nearest=256
	highest=256
	ship.sensor_b = 0
	p.y = ship.y + ship.aabb_max.y + 0.125
	
	-- bottom, front left
	p.x = ship.x + ship.aabb_min.x
	p.z = ship.z + ship.aabb_max.z
	block=get_block(p)
	if not block.blank then
		nearest=min(block.pos.y-p.y,nearest)
		highest=min(block.pos.y,highest)
		ship.sensor_b = bor(ship.sensor_b,
			shl(pt_in_block(p,block.pos,block.sz) and 1 or 0,
				0))
	end
	
	-- bottom, front right
	p.x = ship.x + ship.aabb_max.x
	p.z = ship.z + ship.aabb_max.z
	block=get_block(p)
	if not block.blank then
		nearest=min(block.pos.y-p.y,nearest)
		highest=min(block.pos.y,highest)
		ship.sensor_b = bor(ship.sensor_b,
			shl(pt_in_block(p,block.pos,block.sz) and 1 or 0,
				1))
	end
	
	-- bottom, back right
	p.x = ship.x + ship.aabb_max.x
	p.z = ship.z + ship.aabb_min.z
	block=get_block(p)
	if not block.blank then
		nearest=min(block.pos.y-p.y,nearest)
		highest=min(block.pos.y,highest)
		ship.sensor_b = bor(ship.sensor_b,
			shl(pt_in_block(p,block.pos,block.sz) and 1 or 0,
				2))
	end
	
	-- bottom, back left
	p.x = ship.x + ship.aabb_min.x
	p.z = ship.z + ship.aabb_min.z
	block=get_block(p)
	if not block.blank then
		nearest=min(block.pos.y-p.y,nearest)
		highest=min(block.pos.y,highest)
		ship.sensor_b = bor(ship.sensor_b,
			shl(pt_in_block(p,block.pos,block.sz) and 1 or 0,
				3))
	end
	
	-- detect ground
	ship.floor=highest
	if ship.sensor_b > 0 and
			ship.vy > 0 then
		if ship.y > highest then
			ship.y = highest
		end
	end
	
	-- left
	nearest=-256
	ship.sensor_l = 0
	p.x = ship.x + ship.aabb_min.x

	-- left, top front
	p.y = ship.y + ship.aabb_min.y
	p.z = ship.z + ship.aabb_max.z - 1
	block=get_block(p)
	if not block.blank then
		nearest=max((block.pos.x+block.sz.x)-p.x,nearest)
		ship.sensor_l = bor(ship.sensor_l,
			shl(pt_in_block(p,block.pos,block.sz) and 1 or 0,
				0))
	end
			
	-- left, bot fromt
	p.y = ship.y + ship.aabb_max.y - 1
	p.z = ship.z + ship.aabb_max.z - 1
	block=get_block(p)
	if not block.blank then
		nearest=max((block.pos.x+block.sz.x)-p.x,nearest)
		ship.sensor_l = bor(ship.sensor_l,
			shl(pt_in_block(p,block.pos,block.sz) and 1 or 0,
				1))
	end
	
	-- left, bot back
	p.y = ship.y + ship.aabb_max.y - 1
	p.z = ship.z + ship.aabb_min.z
	block=get_block(p)
	if not block.blank then
		nearest=max((block.pos.x+block.sz.x)-p.x,nearest)
		ship.sensor_l = bor(ship.sensor_l,
			shl(pt_in_block(p,block.pos,block.sz) and 1 or 0,
				2))
	end
			
	-- left, top back
	p.y = ship.y + ship.aabb_min.y
	p.z = ship.z + ship.aabb_min.z
	block=get_block(p)
	if not block.blank then
		nearest=max((block.pos.x+block.sz.x)-p.x,nearest)
		ship.sensor_l = bor(ship.sensor_l,
			shl(pt_in_block(p,block.pos,block.sz) and 1 or 0,
				3))
	end
	
	if ship.sensor_l > 0 and
			ship.vx < 0 then
		ship.x = ship.x + max(nearest,0)
	end
	
	-- right
	nearest=256
	ship.sensor_r = 0
	p.x = ship.x + ship.aabb_max.x

	-- right, top front
	p.y = ship.y + ship.aabb_min.y
	p.z = ship.z + ship.aabb_max.z - 1
	block=get_block(p)
	if not block.blank then
		nearest=min(block.pos.x-p.x,nearest)
		ship.sensor_r = bor(ship.sensor_r,
			shl(pt_in_block(p,block.pos,block.sz) and 1 or 0,
				0))
	end
			
	-- right, bot fromt
	p.y = ship.y + ship.aabb_max.y - 1
	p.z = ship.z + ship.aabb_max.z - 1
	block=get_block(p)
	if not block.blank then
		nearest=min(block.pos.x-p.x,nearest)
		ship.sensor_r = bor(ship.sensor_r,
			shl(pt_in_block(p,block.pos,block.sz) and 1 or 0,
				1))
	end
	
	-- right, bot back
	p.y = ship.y + ship.aabb_max.y - 1
	p.z = ship.z + ship.aabb_min.z
	block=get_block(p)
	if not block.blank then
		nearest=min(block.pos.x-p.x,nearest)
		ship.sensor_r = bor(ship.sensor_r,
			shl(pt_in_block(p,block.pos,block.sz) and 1 or 0,
				2))
	end
			
	-- right, top back
	p.y = ship.y + ship.aabb_min.y
	p.z = ship.z + ship.aabb_min.z
	block=get_block(p)
	if not block.blank then
		nearest=min(block.pos.x-p.x,nearest)
		ship.sensor_rl = bor(ship.sensor_r,
			shl(pt_in_block(p,block.pos,block.sz) and 1 or 0,
				3))
	end
	
	if ship.sensor_r > 0 and
			ship.vx > 0 then
		ship.x = ship.x + max(nearest,0)
	end
	
	-- front
	nearest=256
	ship.sensor_f = 0
	p.z = ship.z + ship.aabb_max.z

	-- front, top left
	p.x = ship.x + ship.aabb_min.x
	p.y = ship.y + ship.aabb_min.y
	block=get_block(p)
	if not block.blank then
		nearest=min(block.pos.z-p.z,nearest)
		ship.sensor_f = bor(ship.sensor_f,
			shl(pt_in_block(p,block.pos,block.sz) and 1 or 0,
				0))
	end
			
	-- front, top right
	p.x = ship.x + ship.aabb_max.x
	p.y = ship.y + ship.aabb_min.y
	block=get_block(p)
	if not block.blank then
		nearest=min(block.pos.z-p.z,nearest)
		ship.sensor_f = bor(ship.sensor_f,
			shl(pt_in_block(p,block.pos,block.sz) and 1 or 0,
				1))
	end
	
	-- front, bot right
	p.x = ship.x + ship.aabb_max.x
	p.y = ship.y + ship.aabb_max.y - 1
	block=get_block(p)
	if not block.blank then
		nearest=min(block.pos.z-p.z,nearest)
		ship.sensor_f = bor(ship.sensor_f,
			shl(pt_in_block(p,block.pos,block.sz) and 1 or 0,
				2))
	end
			
	-- front, bot left
	p.x = ship.x + ship.aabb_min.x
	p.y = ship.y + ship.aabb_max.y - 1
	block=get_block(p)
	if not block.blank then
		nearest=min(block.pos.z-p.z,nearest)
		ship.sensor_f = bor(ship.sensor_f,
			shl(pt_in_block(p,block.pos,block.sz) and 1 or 0,
				3))
	end
	
	if ship.sensor_f > 0 and
			ship.vz > 0 then
		ship.z = ship.z + min(nearest,0)
	end
end

function update_ship()
	-- handle x motion
	if ship.onground then
		if btn(0) then
			ship.vx = -0.5
		elseif btn(1) then
			ship.vx = 0.5
		else
			ship.vx = 0.0
		end
	end
	
	if ship.sensor_l > 0 and ship.vx < 0 then
		ship.vx = 0
	elseif ship.sensor_r > 0 and ship.vx > 0 then
		ship.vx = 0
	end
	
	-- handle z motion
	if btn(3) then
		ship.vz = step(ship.vz, -2.0, 2.0/256.0)
	elseif btn(2) then
		ship.vz = step(ship.vz, 2.0, 4.0/256.0)
	end
	
 -- handle jump
 if ship.onground == false then
	 if ship.jhtimer > 0 then
	 	if btn(4) then
	 		ship.jhtimer = ship.jhtimer - 1
	 	else
	 		ship.jhtimer = 0
	 	end
	 else
	 	ship.vy = ship.vy + road.grav
	 end
	else
		if btnp(4) then
			ship.jhtimer = 8
			ship.onground = false
	 	ship.vy = -2.0
	 	sfx(0)
	 end
	end
 
	-- update fire palette
	if ship.ftimer < 12 then
		ship.ftimer = ship.ftimer + 1
	else
		ship.ftimer = 0
	end
	
	-- update position
	ship.x = ship.x + ship.vx
	ship.y = ship.y + ship.vy
	ship.z = ship.z + ship.vz
	ship.x = max(-64, min(ship.x, 64))
	
	-- update cam
	cam.z = ship.z - 0.0
	
	-- handle collision
	detect_sensors()
	if ship.sensor_f > 0 and
			ship.vz > 0 then
		
		if ship.vz > 0.5 then
			sfx(1)
		end
		
		ship.vz = 0
		-- todo: explode
	end
	
	-- handle hitting ground	
	if ship.sensor_b > 0 then
		if ship.vy > 0 then
			ship.onground = true
			sfx(1)
			-- bounce if fast fall
			if ship.vy >= 1.0 then
				ship.vy = -1.0
				ship.vx = ship.vx * 0.25
				ship.onground = false
			else
				ship.vy = 0.0
			end
		end
	else
		ship.onground = false
	end
end

function draw_ship()
	palt(0, false)
	palt(14, true)
	
	-- project world pos
	local wpos = vec3(ship.x,
		ship.y, ship.z)
	local shwpos = vec3(ship.x,
		ship.floor, ship.z)
	local spos = project3(wpos)
	local shspos = project3(shwpos)
	
	-- draw shadow
	if spos.y < shspos.y then
		local ssz = abs(ship.y - ship.floor)
		ssz = min(flr(ssz / 16), 2)
		ssz = ssz * 2
		spr(ssz,
			shspos.x - 8,
			shspos.y - 8 - 1,
			2, 2)
	end
	
	-- draw ship
	local fcolor = ship.ftimer / 4
	fcolor = fcolor + 8
	local spitch = 0
	if ship.vy < -0.75 then
		spitch = 2
	elseif ship.vy > 0.75 then
		spitch = 4
	end 
	pal(8, fcolor)
	spr(8 + spitch,
		spos.x - 8,
		spos.y - 8 - 1,
		2, 2)
		
	-- cleanup
	pal(8, 8)
	palt(0, true)
	palt(14, false)
end

function draw_player()
end