star_c=64
star_f=2
star_t=0
stars={}
cur_bg = 1

-- bg 1: stars
function build_stars()
	for i=1,star_c do
		stars[i] = {
			x=0, y=0, t=0, d=1
		}
	end
end

star_col={1,12,7,10}
function draw_stars()
	for i,v in ipairs(stars) do
		if v.t > 0 then
			local c = min(3, flr(4 * v.t / v.d)) + 1
			c = star_col[c]
			pset(v.x, v.y, c)
		end
	end
end

function update_stars()
	-- update live stars
	for i,v in ipairs(stars) do
		v.t = step(v.t, 0, 1)
	end
	
	-- spawn new stars
	if star_t < star_f then
		star_t = star_t + star_f
	else
		star_t = 0
		
		for i,v in ipairs(stars) do
			if v.t == 0 then
				v.d = rnd(29) + 31
				v.t = v.d
				v.x = rnd(128)
				v.y = rnd(128)
				break
			end
		end
	end
end

-- bg hooks
function build_bg()
    build_stars()
end

function update_bg()
    if cur_bg == 1 then
        update_stars()
    end
end

function draw_bg()
    if cur_bg == 1 then
        draw_stars()
    end
end
