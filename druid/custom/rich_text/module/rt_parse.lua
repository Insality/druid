-- Source: https://github.com/britzl/defold-richtext version 5.19.0
-- Author: Britzl
-- Modified by: Insality

local tags = require("druid.custom.rich_text.module.rt_tags")
local utf8_lua = require("druid.system.utf8")
local utf8 = utf8 or utf8_lua

local M = {}

-- One UTF-8 character: a lead byte with its continuation bytes
local UTF8_CHAR_PATTERN = "[^\128-\191][\128-\191]*"

local function parse_tag(tag, params, style)
	local settings = { tags = { [tag] = params }, tag = tag }
	if not tags.apply(tag, params, settings, style) then
		settings[tag] = params
	end

	return settings
end


-- Settings table -> metatable to read it from words, one per settings table
local WORD_METATABLES = setmetatable({}, { __mode = "k" })

-- add a single word to the list of words
local function add_word(text, settings, words)
	-- handle HTML entities
	if text:find("&", 1, true) then
		text = text:gsub("&lt;", "<"):gsub("&gt;", ">"):gsub("&nbsp;", " ")
	end

	-- Words read the tag settings through the metatable instead of copying them
	local word_metatable = WORD_METATABLES[settings]
	if not word_metatable then
		word_metatable = { __index = settings }
		WORD_METATABLES[settings] = word_metatable
	end
	local data = setmetatable({ text = text, source_text = text }, word_metatable)

	words[#words + 1] = data
	return data
end


-- split a line into words
local function split_line(line, settings, words)
	assert(line)
	assert(settings)
	assert(words)

	local ws_start, trimmed_text, ws_end = line:match("^(%s*)(.-)(%s*)$")
	if trimmed_text == "" then
		add_word(ws_start .. ws_end, settings, words)
	else
		local wi = #words
		-- Letters are nobr, a leading space glued to the first one would join it to the previous letters
		if settings.split_to_characters and ws_start ~= "" then
			add_word(ws_start, settings, words)
			ws_start = ""
		end
		for word in trimmed_text:gmatch("%S+") do
			if settings.split_to_characters then
				for symbol in word:gmatch(UTF8_CHAR_PATTERN) do
					local w = add_word(symbol, settings, words)
					w.nobr = true
				end
				add_word(" ", settings, words)
			else
				add_word(word .. " ", settings, words)
			end
		end
		local first = words[wi + 1]
		first.text = ws_start .. first.text
		first.source_text = first.text
		local last = words[#words]
		-- The last word always ends with the space added above
		last.text = last.text:sub(1, -2) .. ws_end
		last.source_text = last.text
	end
end


-- split text
-- split by lines first
local function split_text(text, settings, words)
	assert(text)
	assert(settings)
	assert(words)
	-- special treatment of empty text with a linebreak <br/>
	if text == "" and settings.linebreak then
		add_word(text, settings, words)
		return
	end

	-- we don't want to deal with \r\n, remove all \r
	text = text:gsub("\r", "")

	-- the Lua pattern expects the text to have a linebreak at the end
	local added_linebreak = false
	if text:sub(-1)~="\n" then
		added_linebreak = true
		text = text .. "\n"
	end

	-- split into lines
	for line in text:gmatch("(.-)\n") do
		split_line(line, settings, words)
		-- flag last word of a line as having a linebreak
		local last = words[#words]
		last.linebreak = true
	end

	-- remove the last linebreak if we manually added it above
	if added_linebreak then
		local last = words[#words]
		last.linebreak = false
	end
end


-- Merge one tag into another
local function merge_tags(dst, src)
	for k, v in pairs(src) do
		if k ~= "tags" then
			dst[k] = v
		end
	end
	for tag, params in pairs(src.tags or {}) do
		dst.tags[tag] = (params == "") and true or params
	end
end


---Parse the text into individual words
---@param text string The text to parse
---@param default_settings table<string, any> Default settings for each word
---@param style table<string, any> Style settings
---@return table<string, any> List of all words
function M.parse(text, default_settings, style)
	assert(text)
	assert(default_settings)

	text = text:gsub("&zwsp;", "<zwsp>\226\128\139</zwsp>")

	-- Replace all \n with <br/> to make it easier to split the text
	text = text:gsub("\n", "<br/>")

	local all_words = {}
	local open_tags = {}

	while true do
		-- merge list of word settings from defaults and all open tags
		local word_settings = { tags = {} }
		merge_tags(word_settings, default_settings)
		for _, open_tag in ipairs(open_tags) do
			merge_tags(word_settings, open_tag)
		end

		-- find next tag, with the text before and after the tag
		local before_tag, tag, after_tag = text:match("(.-)(</?%S->)(.*)")

		-- no more tags, split and add rest of the text
		if not before_tag or not tag or not after_tag then
			if text ~= "" then
				split_text(text, word_settings, all_words)
			end
			break
		end

		-- split and add text before the encountered tag
		if before_tag ~= "" then
			split_text(before_tag, word_settings, all_words)
		end

		-- parse the tag, split into name and optional parameters
		local endtag, name, params, empty = tag:match("<(/?)([%w_]+)=?(%S-)(/?)>")

		local is_endtag = endtag == "/"
		local is_empty = empty == "/"
		if is_empty then
			-- empty tag, ie tag without content
			-- example <br/> and <img=texture:image/>
			local empty_tag_settings = parse_tag(name, params, style)
			merge_tags(empty_tag_settings, word_settings)
			add_word("", empty_tag_settings, all_words)
		elseif not is_endtag then
			-- open tag - parse and add it
			local tag_settings = parse_tag(name, params, style)
			open_tags[#open_tags + 1] = tag_settings
		else
			-- end tag - remove it from the list of open tags
			local found = false
			for i=#open_tags,1,-1 do
				if open_tags[i].tag == name then
					table.remove(open_tags, i)
					found = true
					break
				end
			end
			if not found then print(("Found end tag '%s' without matching start tag"):format(name)) end
		end

		-- parse text after the tag on the next iteration
		text = after_tag
	end

	return all_words
end


---Get the length of a text, excluding any tags (except image and spine tags)
---@param text string The text to get the length of
---@return number The length of the text
function M.length(text)
	return utf8.len((text:gsub("<img.-/>", " "):gsub("<.->", "")))
end


return M
