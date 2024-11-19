---@type table<string, table<string, vector4>>
local PALETTE_DATA
local CURRENT_PALETTE = "default"
local DEFAULT_COLOR = vmath.vector4(1, 1, 1, 1)
local COLOR_X = hash("color.x")
local COLOR_Y = hash("color.y")
local COLOR_Z = hash("color.z")

local M = {}


---Get color color by id
---@param color_id string
---@return vector4
function M.get(color_id)
	-- Check is it hex: starts with "#" or contains only 3 or 6 hex symbols
	if type(color_id) == "string" then
		if string.sub(color_id, 1, 1) == "#" or string.match(color_id, "^[0-9a-fA-F]+$") then
			return M.hex2vector4(color_id)
		end
	end

	return PALETTE_DATA[CURRENT_PALETTE] and PALETTE_DATA[CURRENT_PALETTE][color_id] or DEFAULT_COLOR
end


---Add palette to palette data
---@param palette_name string
---@param palette_data table<string, vector4>
function M.add_palette(palette_name, palette_data)
	PALETTE_DATA[palette_name] = PALETTE_DATA[palette_name] or {}
	local palette = PALETTE_DATA[palette_name]

	for color_id, color in pairs(palette_data) do
		if type(color) == "string" then
			palette[color_id] = M.hex2vector4(color)
		else
			palette[color_id] = color
		end
	end
end


function M.set_palette(palette_name)
	if PALETTE_DATA[palette_name] then
		CURRENT_PALETTE = palette_name
	end
end


function M.get_palette()
	return CURRENT_PALETTE
end


---Set color of gui node without changing alpha
---@param gui_node node
---@param color vector4|vector3|string Color in vector4, vector3 or color id from palette
function M.set_color(gui_node, color)
	if type(color) == "string" then
		color = M.get(color)
	end

	gui.set(gui_node, COLOR_X, color.x)
	gui.set(gui_node, COLOR_Y, color.y)
	gui.set(gui_node, COLOR_Z, color.z)
end


function M.get_random_color()
	return vmath.vector4(math.random(), math.random(), math.random(), 1)
end


---Lerp colors via color HSB values
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


---@param hex string
---@param alpha number|nil
---@return number, number, number, number
function M.hex2rgb(hex, alpha)
	alpha = alpha or 1
	if alpha > 1 then
		alpha = alpha / 100
	end

	-- Remove leading #
	if string.sub(hex, 1, 1) == "#" then
		hex = string.sub(hex, 2)
	end

	-- Expand 3-digit hex codes to 6 digits
	if #hex == 3 then
		hex = string.rep(string.sub(hex, 1, 1), 2) ..
				string.rep(string.sub(hex, 2, 2), 2) ..
				string.rep(string.sub(hex, 3, 3), 2)
	end

	local r = tonumber("0x" .. string.sub(hex, 1, 2)) / 255
	local g = tonumber("0x" .. string.sub(hex, 3, 4)) / 255
	local b = tonumber("0x" .. string.sub(hex, 5, 6)) / 255
	return r, g, b, alpha
end


---@param hex string
---@param alpha number|nil
---@return vector4
function M.hex2vector4(hex, alpha)
	local r, g, b, a = M.hex2rgb(hex, alpha)
	return vmath.vector4(r, g, b, a)
end


---Convert hsb color to rgb color
---@param r number @Red value
---@param g number @Green value
---@param b number @Blue value
---@param alpha number|nil @Alpha value. Default is 1
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
---@param h number @Hue
---@param s number @Saturation
---@param v number @Value
---@param alpha number|nil @Alpha value. Default is 1
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
---@param red number @Red value
---@param green number @Green value
---@param blue number @Blue value
function M.rgb2hex(red, green, blue)
	local r = string.format("%x", math.floor(red * 255))
	local g = string.format("%x", math.floor(green * 255))
	local b = string.format("%x", math.floor(blue * 255))
	return string.upper((#r == 1 and "0" or "") .. r .. (#g == 1 and "0" or "") .. g .. (#b == 1 and "0" or "") .. b)
end


function M.load_palette()
	local PALETTE_PATH = sys.get_config_string("fluid.palette")
	if PALETTE_PATH then
		PALETTE_DATA = M.load_json(PALETTE_PATH) --[[@as table<string, table<string, vector4>>]]
	end
	PALETTE_DATA = PALETTE_DATA or {}

	for _, palette_data in pairs(PALETTE_DATA) do
		for color_id, color in pairs(palette_data) do
			if type(color) == "string" then
				palette_data[color_id] = M.hex2vector4(color)
			end
		end
	end
end


---Load JSON file from game resources folder (by relative path to game.project)
---Return nil if file not found or error
---@param json_path string
---@return table|nil
function M.load_json(json_path)
	local resource, is_error = sys.load_resource(json_path)
	if is_error or not resource then
		return nil
	end

	return json.decode(resource)
end


M.load_palette()

return M