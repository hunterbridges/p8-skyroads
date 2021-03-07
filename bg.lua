star_c=64
star_f=2
star_t=0
stars={}
cur_bg = 2

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

-- bg 2: warp

warp_r = 0
warp_dur = 240
warp_off = 0

function update_warp()
    warp_r = warp_r + 0.5
    warp_r = warp_r % warp_dur
    warp_off = (warp_off + 1 / 32) % 1
end

function draw_warp()
    local x=64
    local y=64
    local i

    local step = 4
    local i = 0
    while i < 96 do
        local step_r = (warp_r + i) % warp_dur
        local rad = flr(i + warp_off * step)

        x = x + cos(step_r / warp_dur)
        y = y + sin(step_r / warp_dur)

        local circrad = 0

        circ(x,y,rad,1)
        
        if rad > 0 then
            for j=0,1,0.75/rad do
                local radj = (j + i / 32) % 1
                circfill(x+cos(radj)*rad,y+sin(radj)*rad,circrad,13)
            end
        end

        i = i + step
        step = step + 0.5
    end
end

-- bg hooks
function build_bg()
    build_stars()
end

function update_bg()
    if cur_bg == 1 then
        update_stars()
    elseif cur_bg == 2 then
        update_warp()
    end
end

function draw_bg()
    if cur_bg == 1 then
        draw_stars()
    elseif cur_bg == 2 then
        draw_warp()
    end
end
