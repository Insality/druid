-- Source: https://github.com/britzl/defold-richtext version 5.19.0
-- Author: Britzl
-- Modified by: Insality

local color = require("druid.custom.rich_text.rich_text.color")

local M = {}

local tags = {}


function M.apply(tag, params, settings)
	local fn = tags[tag]
	if not fn then
		return false
	end

	fn(params, settings)
	return true
end


function M.register(tag, fn)
	assert(tag, "You must provide a tag")
	assert(fn, "You must provide a tag function")
	tags[tag] = fn
end


M.register("color", function(params, settings)
	settings.color = color.parse(params)
end)


M.register("shadow", function(params, settings)
	settings.shadow = color.parse(params)
end)


M.register("outline", function(params, settings)
	settings.outline = color.parse(params)
end)


M.register("font", function(params, settings)
	settings.font = params
end)


M.register("size", function(params, settings)
	settings.size = tonumber(params)
end)


M.register("b", function(params, settings)
	settings.bold = true
end)


M.register("i", function(params, settings)
	settings.italic = true
end)


M.register("a", function(params, settings)
	settings.anchor = true
end)


M.register("br", function(params, settings)
	settings.linebreak = true
end)


M.register("nobr", function(params, settings)
	settings.nobr = true
end)


-- Split string at first occurrence of token
-- If the token doesn't exist the whole string is returned
-- @param s The string to split
-- @param token The token to split string on
-- @return before The string before the token or the whole string if token doesn't exist
-- @return after The string after the token or nul
local function split(s, token)
	if not s then return nil, nil end
	local before, after = s:match("(.-)" .. token .. "(.*)")
	before = before or s
	return before, after
end


M.register("img", function(params, settings)
	local texture_and_anim, params = split(params, ",")
	local width, height
	width, params = split(params, ",")
	height = split(params, ",")
	local texture, anim = split(texture_and_anim, ":")

	width = width and tonumber(width)
	height = height and tonumber(height) or width

	settings.image = {
		texture = texture,
		anim = anim,
		width = width,
		height = height
	}
end)


M.register("spine", function(params, settings)
	local scene, anim = params:match("(.-):(.*)")
	settings.spine = {
		scene = scene,
		anim = anim
	}
end)


M.register("p", function(params, settings)
	settings.paragraph = tonumber(params) or true
end)


return M
