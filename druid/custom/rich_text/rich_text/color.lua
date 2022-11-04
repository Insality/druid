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


M.COLORS = {
	aqua = M.parse_hex("#00ffffff"),
	black = M.parse_hex("#000000ff"),
	blue = M.parse_hex("#0000ffff"),
	brown = M.parse_hex("#a52a2aff"),
	cyan = M.parse_hex("#00ffffff"),
	darkblue = M.parse_hex("#0000a0ff"),
	fuchsia = M.parse_hex("#ff00ffff"),
	green = M.parse_hex("#008000ff"),
	grey = M.parse_hex("#808080ff"),
	lightblue = M.parse_hex("#add8e6ff"),
	lime = M.parse_hex("#00ff00ff"),
	magenta = M.parse_hex("#ff00ffff"),
	maroon = M.parse_hex("#800000ff"),
	navy = M.parse_hex("#000080ff"),
	olive = M.parse_hex("#808000ff"),
	orange = M.parse_hex("#ffa500ff"),
	purple = M.parse_hex("#800080ff"),
	red	 = M.parse_hex("#ff0000ff"),
	silver = M.parse_hex("#c0c0c0ff"),
	teal = M.parse_hex("#008080ff"),
	white = M.parse_hex("#ffffffff"),
	yellow = M.parse_hex("#ffff00ff"),
}


function M.parse(c)
	return M.COLORS[c] or M.parse_hex(c) or M.parse_decimal(c)
end


return M
