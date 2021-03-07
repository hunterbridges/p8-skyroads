function project3(p)
	local scr2 = {x=0, y=0}
	p.x = p.x - cam.x
	p.y = p.y - cam.y
	p.z = p.z - cam.z	
	local pers = fov / max(1.0, fov + p.z)
	scr2.x = (p.x * pers) + 64
	scr2.y = (p.y * pers) + 64
 return scr2 
end

shades={5,13,6,7}
ibuf={
	3,4,7, 7,8,4, -- bottom
	1,5,8, 8,4,1, -- left
	2,6,7, 7,3,2, -- right
	1,2,5, 5,6,2, -- top
	1,2,3, 3,4,1  -- back	
}
facec={
	1, 1, -- bottom
	2, 2, -- left
	2, 2, -- right
	4, 4, -- top
	3, 3  -- back
}
function draw_box(pos, sz, lcol, dcol)
	local ntl=vec3(
		pos.x,
		pos.y,
		pos.z)
	local ntr=vec3(
		pos.x + sz.x,
		pos.y,
		pos.z)
	local nbr=vec3(
		pos.x + sz.x,
		pos.y + sz.y,
		pos.z)
	local nbl=vec3(
		pos.x,
		pos.y + sz.y,
		pos.z)
	local ftl=vec3(
		pos.x,
		pos.y,
		pos.z + sz.z)
	local ftr=vec3(
		pos.x + sz.x,
		pos.y,
		pos.z + sz.z)
	local fbr=vec3(
		pos.x + sz.x,
		pos.y + sz.y,
		pos.z + sz.z)
	local fbl=vec3(
		pos.x,
		pos.y + sz.y,
		pos.z + sz.z)
		
	local vbuf={
		ntl, ntr, nbr, nbl,
		ftl, ftr, fbr, fbl
	}
	for i,v in ipairs(vbuf) do
		vbuf[i] = project3(v)
	end
	
	local idx=1
	for face=1,#facec do
		local p1 = vbuf[ibuf[idx]]
		local p2 = vbuf[ibuf[idx+1]]
		local p3 = vbuf[ibuf[idx+2]]
		local c = dcol
		if face == 7 or face == 8 then
			c = lcol
		end
		
		p01_trifill(p1.x, p1.y,
			p2.x, p2.y,
			p3.x, p3.y,
			c)
		idx = idx + 3
	end
end

function draw_fade(a)
    local step = flr(shr(a, 5))

    if step == 0 then
        color(0)
        rectfill(0,0,128,128)
    elseif step == 1 then
        fillp(0xA5A5)
        color(80)
        rectfill(0,0,128,128)

        fillp(0)
    elseif step == 2 then
        color(5)
        rectfill(0,0,128,128)
    elseif step == 3 then
        fillp(0xA5A5)
        color(101)
        rectfill(0,0,128,128)

        fillp(0)
    elseif step == 4 then
        color(6)
        rectfill(0,0,128,128)
    elseif step == 5 then
        fillp(0xA5A5)
        color(118)
        rectfill(0,0,128,128)

        fillp(0)
    else
        color(7)
        rectfill(0,0,128,128)
    end
end
