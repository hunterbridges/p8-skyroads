function step(from,to,d)
	d = abs(d)
	local res = from
	
	if from == to then
		res = from
	elseif from < to then
		res = min(from + d, to)
	elseif from > to then
		res = max(from - d, to)
	end
		
	return res
end

function vec3(x,y,z)
 return {x=x, y=y, z=z}
end
