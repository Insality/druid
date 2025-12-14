local logger = require("druid.system.druid_logger")

---@alias color vector4|vector3|string

---Color palette and utility functions for working with colors.
---Supports palette management, hex conversion, RGB/HSB conversion, and color interpolation.
---@class druid.color
local M = {}

local PALETTE_DATA = {}
local COLOR_WHITE = vmath.vector4(1, 1, 1, 1)
local COLOR_X = hash("color.x")
local COLOR_Y = hash("color.y")
local COLOR_Z = hash("color.z")


---Get color by ID from palette, hex string, or return vector as-is.
---If color_id is not found in palette and not a hex string, returns white.
---@param color_id string|vector4|vector3 Color id from palette, hex color string, or vector
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

	logger.warn("Color not found in palette", color_id)

	return COLOR_WHITE
end


---Add colors to palette. Colors can be hex strings or vector4 values.
---@param palette_data table<string, vector4|string> Table with color IDs as keys
function M.add_palette(palette_data)
	for color_id, color in pairs(palette_data) do
		if type(color) == "string" then
			PALETTE_DATA[color_id] = M.hex2vector4(color)
		else
			PALETTE_DATA[color_id] = color
		end
	end
end


---Get all palette colors.
---@return table<string, vector4>
function M.get_palette()
	return PALETTE_DATA
end


---Set GUI node color. Does not change alpha.
---@param gui_node node
---@param color vector4|vector3|string
function M.set_color(gui_node, color)
	if type(color) == "string" then
		color = M.get_color(color)
	end

	gui.set(gui_node, COLOR_X, color.x)
	gui.set(gui_node, COLOR_Y, color.y)
	gui.set(gui_node, COLOR_Z, color.z)
end


---Interpolate between two colors using HSB space (better visual results than RGB).
---@param t number Lerp value (0 = color1, 1 = color2)
---@param color1 vector4
---@param color2 vector4
---@return vector4
function M.lerp(t, color1, color2)
	local h1, s1, v1 = M.rgb2hsb(color1.x, color1.y, color1.z)
	local h2, s2, v2 = M.rgb2hsb(color2.x, color2.y, color2.z)

	local dh = h2 - h1
	if math.abs(dh) > 0.5 then
		if dh > 0 then
			dh = dh - 1
		else
			dh = dh + 1
		end
	end
	local h = (h1 + dh * t) % 1
	local s = s1 + (s2 - s1) * t
	local v = v1 + (v2 - v1) * t

	local a1 = color1.w or 1
	local a2 = color2.w or 1
	local a = a1 + (a2 - a1) * t

	local r, g, b = M.hsb2rgb(h, s, v)

	return vmath.vector4(r, g, b, a)
end


---Convert hex string to RGB values (0-1 range). Supports #RGB and #RRGGBB formats.
---@param hex string
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


---Convert hex string to vector4.
---@param hex string
---@param alpha number|nil Default is 1
---@return vector4
function M.hex2vector4(hex, alpha)
	local r, g, b = M.hex2rgb(hex)
	return vmath.vector4(r, g, b, alpha or 1)
end


---Convert RGB to HSB.
---@param r number
---@param g number
---@param b number
---@param alpha number|nil
---@return number, number, number, number
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

	return h, s, v, alpha
end


---Convert HSB to RGB.
---@param h number
---@param s number
---@param v number
---@param alpha number|nil
---@return number, number, number, number|nil
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


---Convert RGB to hex string (uppercase, without #).
---@param red number
---@param green number
---@param blue number
---@return string hex_string Example: "FF0000", without "#" prefix
function M.rgb2hex(red, green, blue)
	local r = string.format("%x", math.floor(red * 255))
	local g = string.format("%x", math.floor(green * 255))
	local b = string.format("%x", math.floor(blue * 255))
	return string.upper((#r == 1 and "0" or "") .. r .. (#g == 1 and "0" or "") .. g .. (#b == 1 and "0" or "") .. b)
end


-- Auto-load palette from config if druid.palette_path is set in game.project
local DEFAULT_PALETTE_PATH = sys.get_config_string("druid.palette_path")
if DEFAULT_PALETTE_PATH then
	local loaded_palette = sys.load_resource(DEFAULT_PALETTE_PATH)
	local data = loaded_palette and json.decode(loaded_palette)
	if data then
		M.add_palette(data)
	end
end


return M
