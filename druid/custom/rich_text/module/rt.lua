---@diagnostic disable: inject-field
-- Source: https://github.com/britzl/defold-richtext version 5.19.0
-- Author: Britzl
-- Modified by: Insality

local helper = require("druid.helper")
local parser = require("druid.custom.rich_text.module.rt_parse")
local utf8_lua = require("druid.system.utf8")
local utf8 = utf8 or utf8_lua

local VECTOR_ZERO = vmath.vector3(0)
local COLOR_WHITE = vmath.vector4(1)

local M = {}

-- Font resource -> constant shift of measuring after "|", see get_prefix_shift
local PREFIX_SHIFT = {}

-- Trim spaces on string start
local function ltrim(text)
	return text:match('^%s*(.*)')
end


-- Keep only the last glyph run with trailing spaces: the advance of the next word
-- depends on the previous glyph only, and a longer text is just more to measure
local function get_line_tail(tail, font, word)
	if word.image then
		return nil, nil
	end
	if word.text == "" then
		return tail, font
	end
	if word.font ~= font then
		tail = nil
	end
	local text = (tail or "") .. word.text
	return text:match("%S+%s*$") or text, word.font
end


-- Line tail is a valid measure prefix only for a text word in the same font
local function get_prefix(tail, font, word)
	if word.image or word.font ~= font then
		return nil
	end
	return tail
end


-- compare two words and check that they have the same size, color, font and tags
local function compare_words(one, two)
	if one == nil
	or two == nil
	or one.size ~= two.size
	or one.color ~= two.color
	or one.shadow ~= two.shadow
	or one.outline ~= two.outline
	or one.font ~= two.font then
		return false
	end
	local one_tags, two_tags = one.tags, two.tags
	if one_tags == two_tags then
		return true
	end
	if one_tags == nil or two_tags == nil then
		return false
	end
	for k, v in pairs(one_tags) do
		if two_tags[k] ~= v then
			return false
		end
	end
	for k, v in pairs(two_tags) do
		if one_tags[k] ~= v then
			return false
		end
	end
	return true
end


---Get the length of a text ignoring any tags except image tags
---which are treated as having a length of 1
---@param text string|table<string, any> String with text or a list of words (from richtext.create)
---@return number Length of text
function M.length(text)
	assert(text)
	if type(text) == "string" then
		return parser.length(text)
	else
		local count = 0
		for i = 1, #text do
			local word = text[i]
			local is_text_node = not word.image
			count = count + (is_text_node and utf8.len(word.text) or 1)
		end
		return count
	end
end


-- Measuring after "|" shifts every word by the same amount, so a word with
-- no text before it would not start at the node origin. Remove this constant.
local function get_prefix_shift(font_resource)
	local shift = PREFIX_SHIFT[font_resource]
	if not shift then
		local single = resource.get_text_metrics(font_resource, "|").width
		local double = resource.get_text_metrics(font_resource, "||").width
		shift = double - single * 2
		PREFIX_SHIFT[font_resource] = shift
	end
	return shift
end


---@param font hash|string
---@param settings druid.rich_text.settings
---@return hash
local function get_font_resource(font, settings)
	local font_resources = settings.font_resources
	if not font_resources then
		font_resources = {}
		settings.font_resources = font_resources
	end
	local font_resource = font_resources[font]
	if not font_resource then
		font_resource = gui.get_font_resource(font)
		font_resources[font] = font_resource
	end
	return font_resource
end


-- Raw text metrics do not depend on the scale, so the fit loop and the line
-- tails measure the same strings again and again. The cache lives until the next create.
---@param font_resource hash
---@param text string
---@param settings druid.rich_text.settings
local function get_raw_metrics(font_resource, text, settings)
	local cache = settings.metrics_cache
	if not cache then
		cache = {}
		settings.metrics_cache = cache
	end
	local font_cache = cache[font_resource]
	if not font_cache then
		font_cache = {}
		cache[font_resource] = font_cache
	end
	local metrics = font_cache[text]
	if not metrics then
		metrics = resource.get_text_metrics(font_resource, text)
		font_cache[text] = metrics
	end
	return metrics
end


---@param word druid.rich_text.word
---@param prefix string|nil Text before the word on the same line
---@param settings druid.rich_text.settings
---@return druid.rich_text.metrics
local function get_text_metrics(word, prefix, settings)
	local text = word.text
	local font_resource = get_font_resource(word.font, settings)
	local word_scale_x = word.relative_scale * settings.scale.x * settings.adjust_scale
	local word_scale_y = word.relative_scale * settings.scale.y * settings.adjust_scale

	if text == "" then
		return {
			width = 0,
			height = get_raw_metrics(font_resource, "|", settings).height * word_scale_y,
			offset_x = 0,
			offset_y = 0,
		}
	end

	local alone = get_raw_metrics(font_resource, text, settings)

	-- A lone glyph's width includes distance-field padding on both sides.
	-- Measure after text that already paid that padding, then pull the node
	-- back so the padding overlaps the previous glyph instead of a word space.
	-- Spaces have no glyph to pay the padding, so keep "|" before them
	local previous_text = prefix or ""
	if not previous_text:find("%S") then
		previous_text = "|" .. previous_text
	end
	local base_width = get_raw_metrics(font_resource, previous_text, settings).width
	local width = get_raw_metrics(font_resource, previous_text .. text, settings).width - base_width

	return {
		width = width * word_scale_x,
		height = alone.height * word_scale_y,
		offset_x = (width - alone.width - get_prefix_shift(font_resource)) * word_scale_x,
		offset_y = 0,
	}
end


---@param word druid.rich_text.word
---@param settings druid.rich_text.settings
---@return druid.rich_text.metrics
local function get_image_metrics(word, settings)
	-- Image size does not change with the scale, read it from the node once
	local image_size = word.image_size
	if not image_size then
		local node = word.node
		if word.image.width or word.image.height then
			gui.set_size_mode(node, gui.SIZE_MODE_MANUAL)
		else
			gui.set_size_mode(node, gui.SIZE_MODE_AUTO)
		end
		gui.set_texture(node, word.image.texture)
		gui.play_flipbook(node, hash(word.image.anim))

		image_size = gui.get_size(node)
		image_size.x = word.image.width or image_size.x
		image_size.y = word.image.height or image_size.y
		word.image_size = image_size
	end

	return {
		width = image_size.x * word.relative_scale * settings.adjust_scale,
		height = image_size.y * word.relative_scale * settings.adjust_scale,
		node_size = vmath.vector3(image_size),
	}
end


---@param word druid.rich_text.word
---@param settings druid.rich_text.settings
---@param prefix string|nil Text before the word on the same line
---@return druid.rich_text.metrics
local function measure_node(word, settings, prefix)
	do -- Clone node if required
		local node
		if word.image then
			local size = vmath.vector3(
				word.image.width or 100,
				word.image.height or 100,
				0
			)
			node = word.node or gui.new_box_node(vmath.vector3(0), size)
		else
			node = word.node or gui.clone(settings.text_prefab)
		end
		word.node = node
	end

	if word.image then
		return get_image_metrics(word, settings)
	else
		return get_text_metrics(word, prefix, settings)
	end
end


-- Parse text into words, nodes are created on the first measure
---@param text string
---@param settings druid.rich_text.settings
---@param style druid.rich_text.style
---@return druid.rich_text.word[]
local function parse_words(text, settings, style)
	assert(text, "You must provide a text")
	settings.metrics_cache = {}
	settings.font_resources = {}

	-- default settings for a word
	-- will be assigned to each word unless tags override the values
	local word_params = {
		node = nil, -- Autofill on node creation
		relative_scale = 1,
		color = nil,
		position = nil, -- Autofill later
		scale = nil, -- Autofill later
		size = nil, -- Autofill later
		pivot = nil, -- Autofill later
		offset = nil, -- Autofill later
		metrics = {},
		-- text params
		source_text = nil,
		text = nil, -- Autofill later in parse.lua
		text_color = gui.get_color(settings.text_prefab),
		shadow = settings.shadow,
		outline = settings.outline,
		font = gui.get_font(settings.text_prefab),
		split_to_characters = settings.split_to_characters,
		-- Image params
		---@type druid.rich_text.word.image
		image = nil,
		-- Tags
		br = nil,
		nobr = nil,
	}

	return parser.parse(text, word_params, style)
end


-- Create rich text gui nodes from text
---@param text string The text to create rich text nodes from
---@param settings table Optional settings table (refer to documentation for details)
---@param style druid.rich_text.style
---@return druid.rich_text.word[]
---@return druid.rich_text.settings
---@return druid.rich_text.lines_metrics
function M.create(text, settings, style)
	local words = parse_words(text, settings, style)
	local lines = M._split_on_lines(words, settings)
	local lines_metrics = M._position_lines(lines, settings)
	M._update_nodes(lines, settings)

	return words, settings, lines_metrics
end


---Create rich text gui nodes from text, scaled down to fit the area. Nodes are updated once
---@param text string The text to create rich text nodes from
---@param settings druid.rich_text.settings
---@param style druid.rich_text.style
---@return druid.rich_text.word[]
---@return druid.rich_text.lines_metrics
function M.create_adjusted(text, settings, style)
	local words = parse_words(text, settings, style)
	local lines = M._split_on_lines(words, settings)

	local scale = M._get_fit_scale(words, settings, M._get_lines_metrics(lines, settings), style)
	if scale then
		settings.adjust_scale = scale
		lines = M._split_on_lines(words, settings)
	end

	local lines_metrics = M._position_lines(lines, settings)
	M._update_nodes(lines, settings)

	return words, lines_metrics
end


---@param word druid.rich_text.word
---@param metrics druid.rich_text.metrics
---@param settings druid.rich_text.settings
function M._fill_properties(word, metrics, settings)
	word.metrics = metrics

	word.position = word.position or vmath.vector3(0)
	word.position.x = 0
	word.position.y = 0
	word.position.z = 0

	if word.image then
		word.pivot = gui.PIVOT_CENTER
		word.size = metrics.node_size
		if word.image.width then
			word.size.y = word.image.height or (word.size.y * word.image.width / word.size.x)
			word.size.x = word.image.width
		end
		local image_scale = word.relative_scale * settings.adjust_scale
		word.scale = word.scale or vmath.vector3(image_scale)
		word.scale.x = image_scale
		word.scale.y = image_scale
		word.scale.z = image_scale

		word.offset = word.offset or vmath.vector3(0)
		word.offset.x = 0
		word.offset.y = 0
		word.offset.z = 0
	else
		word.pivot = gui.PIVOT_SW
		local text_scale = word.relative_scale * settings.adjust_scale

		word.scale = word.scale or vmath.vector3(settings.scale * text_scale)
		word.scale.x = settings.scale.x * text_scale
		word.scale.y = settings.scale.y * text_scale
		word.scale.z = settings.scale.z * text_scale

		word.size = word.size or vmath.vector3(metrics.width, metrics.height, 0)
		word.size.x = metrics.width
		word.size.y = metrics.height
		word.size.z = 0

		word.offset = word.offset or vmath.vector3(metrics.offset_x, metrics.offset_y, 0)
		word.offset.x = metrics.offset_x
		word.offset.y = metrics.offset_y
		word.offset.z = 0
	end
end


---@param words druid.rich_text.word[]
---@param settings druid.rich_text.settings
---@return druid.rich_text.word[][]
function M._split_on_lines(words, settings)
	local i = 1
	local lines = {}
	local current_line = {}
	local word_count = #words
	local current_line_width = 0
	local current_line_height = 0

	-- Text before the next word on the current line, see get_line_tail
	local line_tail = nil
	local line_font = nil
	local last_text_word = nil

	repeat
		local word = words[i]
		if word == nil then
			break
		end

		-- Reset texts to start measure again
		word.text = word.source_text

		local prefix = get_prefix(line_tail, line_font, word)
		if settings.combine_words and not compare_words(last_text_word, word) then
			prefix = nil
		end

		local word_metrics = measure_node(word, settings, prefix)

		-- A nobr run moves to the next line only as a whole, from its first word
		local previous_word = words[i - 1]
		local is_nobr_start = word.nobr and not (previous_word and previous_word.nobr)

		local next_words_width = word_metrics.width
		-- Collect width of nobr words from current to next words with nobr
		if is_nobr_start then
			local run_tail, run_font = get_line_tail(prefix, word.font, word)
			for index = i + 1, word_count do
				local next_word = words[index]
				if not next_word.nobr then
					break
				end
				next_word.text = next_word.source_text
				local next_word_measure = measure_node(next_word, settings, get_prefix(run_tail, run_font, next_word))
				next_words_width = next_words_width + next_word_measure.width
				run_tail, run_font = get_line_tail(run_tail, run_font, next_word)
			end
		end
		-- A word wider than the area stays on its line instead of leaving an empty one before it
		local overflow = #current_line > 0 and (current_line_width + next_words_width) > settings.width
		local can_break = not word.nobr or is_nobr_start
		local is_new_line = (overflow or word.br) and settings.is_multiline and can_break

		-- Trim first word of the line
		if is_new_line or #current_line == 0 then
			local trimmed = ltrim(word.text)
			if is_new_line or trimmed ~= word.text then
				word.text = trimmed
				word_metrics = measure_node(word, settings, nil)
			end
		end
		M._fill_properties(word, word_metrics, settings)

		-- check if the line overflows due to this word
		if not is_new_line then
			-- the word fits on the line, add it and update text metrics
			current_line_width = current_line_width + word.metrics.width
			current_line_height = math.max(current_line_height, word.metrics.height)
			current_line[#current_line + 1] = word
		else
			-- overflow, position the words that fit on the line
			lines[#lines + 1] = current_line

			current_line = { word }
			current_line_height = word.metrics.height
			current_line_width = word.metrics.width
			line_tail, line_font, last_text_word = nil, nil, nil
		end

		line_tail, line_font = get_line_tail(line_tail, line_font, word)
		if word.image then
			last_text_word = nil
		elseif word.text ~= "" then
			last_text_word = word
		end

		i = i + 1
	until i > word_count

	if #current_line > 0 then
		lines[#lines + 1] = current_line
	end

	return lines
end


---@param lines druid.rich_text.word[][]
---@param settings druid.rich_text.settings
---@return druid.rich_text.lines_metrics
function M._position_lines(lines, settings)
	local lines_metrics = M._get_lines_metrics(lines, settings)
	-- current x-y is left top point of text spawn

	local parent_size = gui.get_size(settings.parent)
	local pivot = helper.get_pivot_offset(gui.get_pivot(settings.parent))
	local offset_y = (parent_size.y - lines_metrics.text_height) * (pivot.y - 0.5) - (parent_size.y * (pivot.y - 0.5))

	local current_y = offset_y
	for line_index = 1, #lines do
		local line = lines[line_index]
		local line_metrics = lines_metrics.lines[line_index]
		local word_count = #line
		local extra_gap = 0
		local used_width = line_metrics.width
		if settings.is_justify and word_count > 1 and line_metrics.width < settings.width then
			extra_gap = (settings.width - line_metrics.width) / (word_count - 1)
			used_width = settings.width
		end
		local current_x = (parent_size.x - used_width) * (pivot.x + 0.5) - (parent_size.x * (pivot.x + 0.5))
		local max_height = 0
		for word_index = 1, word_count do
			local word = line[word_index]
			local pivot_offset = helper.get_pivot_offset(word.pivot)
			local word_width = word.metrics.width
			word.position.x = current_x + word_width * (pivot_offset.x + 0.5) + word.offset.x
			word.position.y = current_y + word.metrics.height * (pivot_offset.y - 0.5) + word.offset.y

			-- Align item on text line depends on anchor
			word.position.y = word.position.y - (word.metrics.height - line_metrics.height) * (pivot_offset.y - 0.5)

			current_x = current_x + word_width
			if extra_gap > 0 and word_index < word_count then
				current_x = current_x + extra_gap
			end

			-- TODO: check if we need to calculate images
			if not word.image then
				max_height = math.max(max_height, word.metrics.height)
			end

			if settings.image_pixel_grid_snap and word.image then
				word.position.x = helper.round(word.position.x)
				word.position.y = helper.round(word.position.y)
			end
		end

		current_y = current_y - line_metrics.height
	end

	return lines_metrics
end


---@param lines druid.rich_text.word[][]
---@param settings druid.rich_text.settings
---@return druid.rich_text.lines_metrics
function M._get_lines_metrics(lines, settings)
	local metrics = {}
	local text_width = 0
	local text_height = 0
	for line_index = 1, #lines do
		local line = lines[line_index]
		local width = 0
		local height = 0
		for word_index = 1, #line do
			local word = line[word_index]
			local word_width = word.metrics.width
			width = width + word_width
			-- TODO: Here too
			if not word.image then
				height = math.max(height, word.metrics.height)
			end
		end

		-- Exclude trailing space of last word from line width (parser adds "word " per token)
		local last = line[#line]
		if last and not last.image then
			local trimmed = last.text:match("^(.-)%s+$")
			if trimmed then
				local font_resource = get_font_resource(last.font, settings)
				local scale_x = last.relative_scale * settings.scale.x * settings.adjust_scale
				local space_w = get_raw_metrics(font_resource, last.text, settings).width - get_raw_metrics(font_resource, trimmed, settings).width
				width = width - space_w * scale_x
			end
		end

		-- Words are measured by advance, the line also takes the side padding of its first glyph
		local first = line[1]
		if first and not first.image then
			local scale_x = first.relative_scale * settings.scale.x * settings.adjust_scale
			width = width - get_prefix_shift(get_font_resource(first.font, settings)) * scale_x
		end

		if line_index > 1 then
			height = height * settings.text_leading
		end

		text_width = math.max(text_width, width)
		text_height = text_height + height

		metrics[#metrics + 1] = {
			width = width,
			height = height,
		}
	end

	---@type druid.rich_text.lines_metrics
	local lines_metrics = {
		text_width = text_width,
		text_height = text_height,
		lines = metrics,
	}

	return lines_metrics
end


---@param lines druid.rich_text.word[][]
---@param settings druid.rich_text.settings
function M._update_nodes(lines, settings)
	for line_index = 1, #lines do
		local line = lines[line_index]
		for word_index = 1, #line do
			local word = line[word_index]
			local node
			if word.image then
				node = word.node or gui.new_box_node(VECTOR_ZERO, word.size)
				gui.set_size_mode(node, gui.SIZE_MODE_MANUAL)
				gui.set_texture(node, word.image.texture)
				gui.play_flipbook(node, hash(word.image.anim))
				gui.set_color(node, word.color or COLOR_WHITE)
				gui.set_inherit_alpha(node, true)
			else
				node = word.node or gui.clone(settings.text_prefab)
				gui.set_outline(node, word.outline)
				gui.set_shadow(node, word.shadow)
				gui.set_text(node, word.text)
				gui.set_color(node, word.color or word.text_color)
				gui.set_font(node, word.font or settings.font)
			end
			word.node = node
			gui.set_enabled(node, true)
			gui.set_parent(node, settings.parent)
			gui.set_pivot(node, word.pivot)
			gui.set_size(node, word.size)
			gui.set_scale(node, word.scale)
			gui.set_position(node, word.position)
		end
	end
end


---@param words druid.rich_text.word[]
---@param settings druid.rich_text.settings
---@param scale number
---@return druid.rich_text.lines_metrics
function M.set_text_scale(words, settings, scale)
	settings.adjust_scale = scale

	local lines = M._split_on_lines(words, settings)
	local line_metrics = M._position_lines(lines, settings)
	M._update_nodes(lines, settings)

	return line_metrics
end


---Find the adjust scale to fit the text into the area
---@param words druid.rich_text.word[]
---@param settings druid.rich_text.settings
---@param lines_metrics druid.rich_text.lines_metrics Metrics at the current adjust scale
---@param style druid.rich_text.style
---@return number|nil scale Nil if the text already fits
function M._get_fit_scale(words, settings, lines_metrics, style)
	local width = settings.width
	local height = settings.height
	local current_scale = settings.adjust_scale

	if not settings.is_multiline then
		if lines_metrics.text_width <= width then
			return nil
		end
		return current_scale * width / lines_metrics.text_width
	end

	if lines_metrics.text_width <= width and lines_metrics.text_height <= height then
		return nil
	end

	-- Lines rewrap on every scale, so start from the area ratio and search around it:
	-- step away with a doubling step until fit and miss are around the answer, then halve
	local scale = current_scale * math.sqrt(height / lines_metrics.text_height)
	if lines_metrics.text_width * scale > width * current_scale then
		scale = current_scale * math.sqrt(width / lines_metrics.text_width)
	end

	local fit_scale = 0
	local miss_scale = current_scale
	local step = style.ADJUST_SCALE_DELTA
	if scale <= fit_scale or scale >= miss_scale then
		scale = (fit_scale + miss_scale) / 2
	end

	for _ = 1, style.ADJUST_STEPS do
		settings.adjust_scale = scale
		local metrics = M._get_lines_metrics(M._split_on_lines(words, settings), settings)
		local is_fit = metrics.text_width <= width and metrics.text_height <= height
		if is_fit then
			fit_scale = scale
		else
			miss_scale = scale
		end
		if miss_scale - fit_scale <= style.ADJUST_SCALE_DELTA then
			break
		end

		scale = is_fit and (scale + step) or (scale - step)
		step = step * 2
		if scale <= fit_scale or scale >= miss_scale then
			scale = (fit_scale + miss_scale) / 2
		end
	end

	settings.adjust_scale = current_scale
	return fit_scale > 0 and fit_scale or miss_scale
end


---@param words druid.rich_text.word[]
---@param settings druid.rich_text.settings
---@param lines_metrics druid.rich_text.lines_metrics
---@param style druid.rich_text.style
function M.adjust_to_area(words, settings, lines_metrics, style)
	local scale = M._get_fit_scale(words, settings, lines_metrics, style)
	if not scale then
		return lines_metrics
	end
	return M.set_text_scale(words, settings, scale)
end


---@return druid.rich_text.word[][] lines
function M.apply_scale_without_update(words, settings, scale)
	settings.adjust_scale = scale
	return M._split_on_lines(words, settings)
end


---@param lines druid.rich_text.word[][]
---@param settings druid.rich_text.settings
function M.is_fit_info_area(lines, settings)
	local lines_metrics = M._get_lines_metrics(lines, settings)
	local area_size = gui.get_size(settings.parent)
	return lines_metrics.text_width <= area_size.x and lines_metrics.text_height <= area_size.y
end


---Get all words with a specific tag
---@param words druid.rich_text.word[] The words to search (as received from richtext.create)
---@param tag string|nil The tag to search for. Nil to search for words without a tag
---@return druid.rich_text.word[] Words matching the tag
function M.tagged(words, tag)
	local tagged = {}
	for i = 1, #words do
		local word = words[i]
		if not tag and not word.tags then
			tagged[#tagged + 1] = word
		elseif word.tags and word.tags[tag] then
			tagged[#tagged + 1] = word
		end
	end
	return tagged
end


---Removes the gui nodes created by rich text
function M.remove(words)
	assert(words)

	for i = 1, #words do
		gui.delete_node(words[i].node)
	end
end


return M
