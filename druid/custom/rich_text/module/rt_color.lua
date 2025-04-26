-- Source: https://github.com/britzl/defold-richtext version 5.19.0
-- Author: Britzl
-- Modified by: Insality

local M = {}
local cache = {}

function M.parse_hex(hex)
	if cache[hex] then
		return cache[hex]
	end

	local r,g,b,a = hex:match("#?(%x%x)(%x%x)(%x%x)(%x?%x?)")
	if a == "" then a = "ff" end
	if r and g and b and a then
		local color = vmath.vector4(
			tonumber(r, 16) / 255,
			tonumber(g, 16) / 255,
			tonumber(b, 16) / 255,
			tonumber(a, 16) / 255
		)

		cache[hex] = color
		return color
	end
	return nil
end


function M.parse_decimal(dec)
	if cache[dec] then
		return cache[dec]
	end

	local r,g,b,a = dec:match("(%d*%.?%d*),(%d*%.?%d*),(%d*%.?%d*),(%d*%.?%d*)")
	if r and g and b and a then
		local color = vmath.vector4(tonumber(r) or 0, tonumber(g) or 0, tonumber(b) or 0, tonumber(a) or 1)
		cache[dec] = color
		return color
	end
	return nil
end


function M.parse(c)
	return M.parse_hex(c) or M.parse_decimal(c)
end


return M
