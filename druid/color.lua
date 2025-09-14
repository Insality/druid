---@alias color vector4|vector3|string

local PALETTE_DATA = {}
local COLOR_WHITE = vmath.vector4(1, 1, 1, 1)
local COLOR_X = hash("color.x")
local COLOR_Y = hash("color.y")
local COLOR_Z = hash("color.z")

local M = {}


---Get color by string (hex or from palette)
---@param color_id string|vector4 Color id from palette or hex color
---@return vector4
function M.get_color(color_id)
	if type(color_id) ~= "string" then
		return color_id
	end

	if PALETTE_DATA[color_id] then
		return PALETTE_DATA[color_id]
	end

	-- Check is it hex: starts with "#" or contains only 3 or 6 hex symbols
	if type(color_id) == "string" then
		if string.sub(color_id, 1, 1) == "#" or string.match(color_id, "^[0-9a-fA-F]+$") then
			return M.hex2vector4(color_id)
		end
	end

	return COLOR_WHITE
end


---Add palette to palette data
---@param palette_data table<string, vector4>
function M.add_palette(palette_data)
	for color_id, color in pairs(palette_data) do
		if type(color) == "string" then
			PALETTE_DATA[color_id] = M.hex2vector4(color)
		else
			PALETTE_DATA[color_id] = color
		end
	end
end


function M.get_palette()
	return PALETTE_DATA
end


---Set color of gui node without changing alpha
---@param gui_node node
---@param color vector4|vector3|string Color in vector4, vector3 or color id from palette
function M.set_color(gui_node, color)
	if type(color) == "string" then
		color = M.get_color(color)
	end

	gui.set(gui_node, COLOR_X, color.x)
	gui.set(gui_node, COLOR_Y, color.y)
	gui.set(gui_node, COLOR_Z, color.z)
end


---Lerp colors via color HSB values
---@param t number Lerp value. 0 - color1, 1 - color2
---@param color1 vector4 Color 1
---@param color2 vector4 Color 2
---@return vector4 result Color between color1 and color2
function M.lerp(t, color1, color2)
	local h1, s1, v1 = M.rgb2hsb(color1.x, color1.y, color1.z)
	local h2, s2, v2 = M.rgb2hsb(color2.x, color2.y, color2.z)

	local h = h1 + (h2 - h1) * t
	local s = s1 + (s2 - s1) * t
	local v = v1 + (v2 - v1) * t

	local r, g, b, a = M.hsb2rgb(h, s, v)
	a = a or 1
	return vmath.vector4(r, g, b, a)
end



---Convert hex color to rgb values.
---@param hex string Hex color. #00BBAA or 00BBAA or #0BA or 0BA
---@return number, number, number
function M.hex2rgb(hex)
	if not hex or #hex < 3 then
		return 0, 0, 0
	end

	hex = hex:gsub("^#", "")
	if #hex == 3 then
		hex = hex:gsub("(.)", "%1%1")
	end
	return tonumber("0x" .. hex:sub(1,2)) / 255,
		   tonumber("0x" .. hex:sub(3,4)) / 255,
		   tonumber("0x" .. hex:sub(5,6)) / 255
end


---Convert hex color to vector4.
---@param hex string Hex color. #00BBAA or 00BBAA or #0BA or 0BA
---@param alpha number|nil Alpha value. Default is 1
---@return vector4
function M.hex2vector4(hex, alpha)
	local r, g, b = M.hex2rgb(hex)
	return vmath.vector4(r, g, b, alpha or 1)
end


---Convert hsb color to rgb colo
---@param r number Red value
---@param g number Green value
---@param b number Blue value
---@param alpha number|nil Alpha value. Default is 1
function M.rgb2hsb(r, g, b, alpha)
	alpha = alpha or 1
	local min, max = math.min(r, g, b), math.max(r, g, b)
	local delta = max - min
	local h, s, v = 0, max, max

	s = max ~= 0 and delta / max or 0

	if delta ~= 0 then
		if r == max then
			h = (g - b) / delta
		elseif g == max then
			h = 2 + (b - r) / delta
		else
			h = 4 + (r - g) / delta
		end
		h = (h / 6) % 1
	end

	alpha = alpha > 1 and alpha / 100 or alpha

	return h, s, v, alpha
end


---Convert hsb color to rgb color
---@param h number Hue
---@param s number Saturation
---@param v number Value
---@param alpha number|nil Alpha value. Default is 1
function M.hsb2rgb(h, s, v, alpha)
	local r, g, b
	local i = math.floor(h * 6)
	local f = h * 6 - i
	local p = v * (1 - s)
	local q = v * (1 - f * s)
	local t = v * (1 - (1 - f) * s)

	i = i % 6

	if i == 0 then r, g, b = v, t, p
	elseif i == 1 then r, g, b = q, v, p
	elseif i == 2 then r, g, b = p, v, t
	elseif i == 3 then r, g, b = p, q, v
	elseif i == 4 then r, g, b = t, p, v
	elseif i == 5 then r, g, b = v, p, q
	end

	return r, g, b, alpha
end


---Convert rgb color to hex color
---@param red number Red value
---@param green number Green value
---@param blue number Blue value
function M.rgb2hex(red, green, blue)
	local r = string.format("%x", math.floor(red * 255))
	local g = string.format("%x", math.floor(green * 255))
	local b = string.format("%x", math.floor(blue * 255))
	return string.upper((#r == 1 and "0" or "") .. r .. (#g == 1 and "0" or "") .. g .. (#b == 1 and "0" or "") .. b)
end


local DEFAULT_PALETTE_PATH = sys.get_config_string("druid.palette_path")
if DEFAULT_PALETTE_PATH then
	local loaded_palette = sys.load_resource(DEFAULT_PALETTE_PATH)
	local data = loaded_palette and json.decode(loaded_palette)
	if not data then
		return
	end

	M.add_palette(data)
end


return M
