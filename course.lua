road={
	idx=0,
	finish=128,
	grav=0.1625
}

course={}

-- init
function build_course(idx)
	road.idx = idx
	
	-- find the map bounds
	local mx=0
	local my=idx*8
	
	-- walk til idx 120
	local breakout=false
	course = {}
	for x=mx,127 do
		local row={}
		
		for y=my,my+7 do
			-- get tile idx
			local block={blank=false}
			local tile = mget(x,y)
			if tile == 120 then
				breakout=true
				road.finish = x*16.0-16.0
				break
			elseif tile < 64 or tile > 111 then
				block.blank=true
			else
				-- create map block
				block.pos={}
				block.sz={x=16.0,y=0.0,z=16.0}
				
				-- determine xz by map pos
				block.pos.x = (y%8)*16.0-64.0
				block.pos.y = 0
				block.pos.z = x*16.0-16.0
				
				-- read sprite for y
				local sx=(tile%16)*8
				local sy=flr(tile/16)*8
				local ymask=0
				ymask=bor(ymask,
					shl(sget(sx+5,sy+5)!=0 and 1 or 0,0))
				ymask=bor(ymask,
					shl(sget(sx+5,sy+4)!=0 and 1 or 0,1))
				ymask=bor(ymask,
					shl(sget(sx+5,sy+3)!=0 and 1 or 0,2))
				ymask=bor(ymask,
					shl(sget(sx+5,sy+2)!=0 and 1 or 0,3))
				block.ymask = ymask
				
				for yl=0,3 do
					local bit = 3-yl
					if band(ymask, shl(1,bit)) > 0 then
						if block.pos.y == 0 then
							block.pos.y=(yl+1)*8.0
						end
						
						block.sz.y=block.sz.y+8.0
					end
				end
				
				-- read sprite colors
				block.lcol = sget(sx,sy)
				block.dcol = sget(sx+7,sy+7)
			end
			add(row, block)
		end
		
		if breakout then
			break
		end
		
		add(course, row)
	end
end

-- helper
function get_block_idx(pos)
	local rowi=flr((pos.z+16.0)/16.0)+1
	local blocki=min(flr((pos.x+64.0)/16.0)+1,8)
	return rowi, blocki
end

dummy_blank={blank=true}
function get_block(pos)
	local rowi,blocki=get_block_idx(pos)
	if rowi<1 or rowi>#course then
		return dummy_blank
	elseif blocki<1 or blocki>8 then
		return dummy_blank
	else
		return course[rowi][blocki]
	end
end

function pt_in_block(pt, box_pos, box_sz)
	local aabb_min=vec3(box_pos.x, box_pos.y, box_pos.z)
	local aabb_max=vec3(box_pos.x + box_sz.x,
		box_pos.y + box_sz.y,
		box_pos.z + box_sz.z)
	return (pt.x >= aabb_min.x and
		pt.x <= aabb_max.x and
		pt.y >= aabb_min.y and
		pt.y <= aabb_max.y and
		pt.z >= aabb_min.z and
		pt.z <= aabb_max.z)
end

-- draw
patt_timer = 0
patts = {
	0xffff.8, 0xfbff.8, 0xb5bf.8, 0x5e5b.8,
	0xefe5.8, 0xfffe.8
}
patt_i = 1

function draw_finish()
	if road.finish <= cam.z + drawdist then
		local z = road.finish
		local tl = vec3(-64, -32, z)
		local br = vec3(64, 32, z)
		tl = project3(tl)
		br = project3(br)
		
		fillp(patts[patt_i])
	 color(12)
	 rectfill(tl.x, tl.y, br.x, br.y)
		fillp()
		
		patt_timer = patt_timer + 1
		if patt_timer >= 4 then
			patt_i = patt_i + 1
			if patt_i > #patts then
				patt_i = 1
			end
			
			patt_timer = patt_timer - 4
		end
	end
end

dorder={1,8,2,7,3,6,4,5}
function draw_fg()
	draw_finish()
	
	local shipflag=false
	for rowi=#course,1,-1 do
		local row=course[rowi]
		local rowz=(rowi-1)*16.0-16.0
		
		-- cull based on z
		if rowz <= cam.z + drawdist and
			rowz + 64 >= cam.z + 1 then
			
			for blocki=1,#row do
				local block=row[dorder[blocki]]
				if not block.blank then
					draw_box(block.pos,
						block.sz,
						block.lcol, block.dcol)
				end
			end
		end
		
		if rowz <= cam.z-4 and shipflag == false then
			draw_ship()
			shipflag=true
		end
	end
end