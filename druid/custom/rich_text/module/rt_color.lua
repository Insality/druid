-- Source: https://github.com/britzl/defold-richtext version 5.19.0
-- Author: Britzl
-- Modified by: Insality

local M = {}

function M.parse_hex(hex)
	local r,g,b,a = hex:match("#?(%x%x)(%x%x)(%x%x)(%x?%x?)")
	if a == "" then a = "ff" end
	if r and g and b and a then
		return vmath.vector4(
			tonumber(r, 16) / 255,
			tonumber(g, 16) / 255,
			tonumber(b, 16) / 255,
			tonumber(a, 16) / 255)
	end
	return nil
end


function M.parse_decimal(dec)
	local r,g,b,a = dec:match("(%d*%.?%d*),(%d*%.?%d*),(%d*%.?%d*),(%d*%.?%d*)")
	if r and g and b and a then
		return vmath.vector4(tonumber(r), tonumber(g), tonumber(b), tonumber(a))
	end
	return nil
end


function M.add(name, color)
	if type(color) == "string" then
		color = M.parse_hex(color) or M.parse_decimal(color)
	end
	assert(type(color) == "userdata" and color.x and color.y and color.z and color.w, "Unable to add color")
	M.COLORS[name] = color
end


M.COLORS = {}


function M.parse(c)
	return M.COLORS[c] or M.parse_hex(c) or M.parse_decimal(c)
end


return M
