local event = require("event.event")
local const = require("druid.const")
local helper = require("druid.helper")
local utf8_lua = require("druid.system.utf8")
local component = require("druid.component")
local utf8 = utf8 or utf8_lua --[[@as utf8]]

---@class druid.text.style
---@field TRIM_POSTFIX string|nil The postfix for TRIM adjust type. Default: ...
---@field DEFAULT_ADJUST string|nil The default adjust type for any text component. Default: DOWNSCALE
---@field ADJUST_STEPS number|nil Amount of iterations for text adjust by height. Default: 20
---@field ADJUST_SCALE_DELTA number|nil Scale step on each height adjust step. Default: 0.02

---@alias druid.text.adjust_type "downscale"|"trim"|"no_adjust"|"downscale_limited"|"scroll"|"scale_then_scroll"|"trim_left"|"scale_then_trim"|"scale_then_trim_left"

---Basic Druid text component. Text components by default have the text size adjusting.
---
---### Setup
---Create text node with druid: `text = druid:new_text(node_name, [initial_value], [text_adjust_type])`
---
---### Notes
---- Text component by default have auto adjust text sizing. Text never will be bigger, than text node size, which you can setup in GUI scene.
---- Text pivot can be changed with `text:set_pivot`, and text will save their position inside their text size box
---- There are several text adjust types:
----   - **"downscale"** - Change text's scale to fit in the text node size (default)
----   - **"trim"** - Trim the text with postfix (default - "...") to fit in the text node size
----   - **"no_adjust"** - No any adjust, like default Defold text node
----   - **"downscale_limited"** - Change text's scale like downscale, but there is limit for text's scale
----   - **"scroll"** - Change text's pivot to imitate scrolling in the text box. Use with stencil node for better effect.
----   - **"scale_then_scroll"** - Combine two modes: first limited downscale, then scroll
----   - **"trim_left"** - Trim the text with postfix (default - "...") to fit in the text node size
----   - **"scale_then_trim"** - Combine two modes: first limited downscale, then trim
----   - **"scale_then_trim_left"** - Combine two modes: first limited downscale, then trim left
---@class druid.text: druid.component
---@field node node The text node
---@field on_set_text event fun(self: druid.text, text: string) The event triggered when the text is set
---@field on_update_text_scale event fun(self: druid.text, scale: vector3, metrics: table) The event triggered when the text scale is updated
---@field on_set_pivot event fun(self: druid.text, pivot: userdata) The event triggered when the text pivot is set
---@field style druid.text.style The style of the text
---@field start_pivot userdata The start pivot of the text
---@field start_scale vector3 The start scale of the text
---@field scale vector3 The current scale of the text
local M = component.create("text")


---The Text constructor
---@param node string|node Node name or GUI Text Node itself
---@param value string|nil Initial text. Default value is node text from GUI scene. Default: nil
---@param adjust_type druid.text.adjust_type|nil Adjust type for text. By default is "downscale". Options: "downscale", "trim", "no_adjust", "downscale_limited", "scroll", "scale_then_scroll", "trim_left", "scale_then_trim", "scale_then_trim_left"
function M:init(node, value, adjust_type)
	self.node = self:get_node(node)
	self.pos = gui.get_position(self.node)
	self.node_id = gui.get_id(self.node)

	self.start_pivot = gui.get_pivot(self.node)
	self.start_scale = gui.get_scale(self.node)
	self.scale = gui.get_scale(self.node)

	self.start_size = gui.get_size(self.node)
	self.text_area = gui.get_size(self.node)
	self.text_area.x = self.text_area.x * self.start_scale.x
	self.text_area.y = self.text_area.y * self.start_scale.y

	self.adjust_type = adjust_type or self.style.DEFAULT_ADJUST
	self.color = gui.get_color(self.node)

	self.on_set_text = event.create()
	self.on_set_pivot = event.create()
	self.on_update_text_scale = event.create()

	self:set_text(value or gui.get_text(self.node))
end


---@private
---@param style druid.text.style
function M:on_style_change(style)
	self.style = {
		TRIM_POSTFIX = style.TRIM_POSTFIX or "...",
		DEFAULT_ADJUST = style.DEFAULT_ADJUST or "downscale",
		ADJUST_STEPS = style.ADJUST_STEPS or 20,
		ADJUST_SCALE_DELTA = style.ADJUST_SCALE_DELTA or 0.02
	}
end


---@private
function M:on_layout_change()
	self:set_text(self.last_value)
end


---Calculate text width with font with respect to trailing space
---@param text string|nil The text to calculate the size of, if nil - use current text
---@return number width The text width
---@return number height The text height
function M:get_text_size(text)
	text = text or self.last_value
	local font_name = gui.get_font(self.node)
	local font = gui.get_font_resource(font_name)
	local scale = self.last_scale or gui.get_scale(self.node)
	local linebreak = gui.get_line_break(self.node)
	local dot_width = resource.get_text_metrics(font, ".").width

	local metrics = resource.get_text_metrics(font, text .. ".", {
		line_break = linebreak,
		leading = 1,
		tracking = 0,
		width = self.start_size.x
	})

	local width = metrics.width - dot_width
	return width * scale.x, metrics.height * scale.y
end


---Get chars count by width
---@param width number The width to get the chars count of
---@return number index The chars count
function M:get_text_index_by_width(width)
	local text = self.last_value
	local font_name = gui.get_font(self.node)
	local font = gui.get_font_resource(font_name)
	local scale = self.last_scale or gui.get_scale(self.node)

	local text_index = 0
	local text_width = 0
	local text_length = utf8.len(text)
	local dot_width = resource.get_text_metrics(font, ".").width
	local previous_width = 0
	for i = 1, text_length do
		local subtext = utf8.sub(text, 1, i) .. "."
		local subtext_width = resource.get_text_metrics(font, subtext).width
		subtext_width = subtext_width - dot_width
		text_width = subtext_width * scale.x
		local width_delta = text_width - previous_width
		previous_width = text_width

		if (text_width - width_delta/2) < width then
			text_index = i
		else
			break
		end
	end

	return text_index
end


---Set text to text field
---@deprecated
---@param set_to string Text for node
---@return druid.text self Current text instance
function M:set_to(set_to)
	set_to = tostring(set_to or "")

	self.last_value = set_to
	gui.set_text(self.node, set_to)

	self.on_set_text:trigger(self:get_context(), set_to)

	self:_update_adjust()

	return self
end


function M:set_text(new_text)
---@diagnostic disable-next-line: deprecated
	return self:set_to(new_text)
end


function M:get_text()
	return self.last_value
end


---Set text area size
---@param size vector3 The new text area size
---@return druid.text self Current text instance
function M:set_size(size)
	self.start_size = size
	self.text_area = vmath.vector3(size)
	self.text_area.x = self.text_area.x * self.start_scale.x
	self.text_area.y = self.text_area.y * self.start_scale.y
	self:_update_adjust()

	return self
end


---Set color
---@param color vector4 Color for node
---@return druid.text self Current text instance
function M:set_color(color)
	self.color = color
	gui.set_color(self.node, color)

	return self
end


---Set alpha
---@param alpha number Alpha for node
---@return druid.text self Current text instance
function M:set_alpha(alpha)
	self.color.w = alpha
	gui.set_color(self.node, self.color)

	return self
end


---Set scale
---@param scale vector3 Scale for node
---@return druid.text self Current text instance
function M:set_scale(scale)
	self.last_scale = scale
	gui.set_scale(self.node, scale)

	return self
end


---Set text pivot. Text will re-anchor inside text area
---@param pivot userdata The gui.PIVOT_* constant
---@return druid.text self Current text instance
function M:set_pivot(pivot)
	local prev_pivot = gui.get_pivot(self.node)
	local prev_offset = const.PIVOTS[prev_pivot]

	gui.set_pivot(self.node, pivot)
	local cur_offset = const.PIVOTS[pivot]

	local pos_offset = vmath.vector3(
		self.text_area.x * (cur_offset.x - prev_offset.x),
		self.text_area.y * (cur_offset.y - prev_offset.y),
		0
	)

	self.pos = self.pos + pos_offset
	gui.set_position(self.node, self.pos)

	self.on_set_pivot:trigger(self:get_context(), pivot)

	return self
end


---Return true, if text with line break
---@return boolean Is text node with line break
function M:is_multiline()
	return gui.get_line_break(self.node)
end


---Set text adjust, refresh the current text visuals, if needed
---@param adjust_type druid.text.adjust_type|nil The adjust type to set, values: "downscale", "trim", "no_adjust", "downscale_limited", "scroll", "scale_then_scroll", "trim_left", "scale_then_trim", "scale_then_trim_left"
---@param minimal_scale number|nil To remove minimal scale, use `text:set_minimal_scale(nil)`, if pass nil - not change minimal scale
---@return druid.text self Current text instance
function M:set_text_adjust(adjust_type, minimal_scale)
	self.adjust_type = adjust_type
	self._minimal_scale = minimal_scale or self._minimal_scale
	self:set_text(self.last_value)

	return self
end


---Set minimal scale for "downscale_limited" or "scale_then_scroll" adjust types
---@param minimal_scale number If pass nil - not use minimal scale
---@return druid.text self Current text instance
function M:set_minimal_scale(minimal_scale)
	self._minimal_scale = minimal_scale

	return self
end


---Return current text adjust type
---@return string adjust_type The current text adjust type
function M:get_text_adjust()
	return self.adjust_type
end


---@private
function M:_update_text_size()
	if self.scale.x == 0 or self.scale.y == 0 then
		return
	end
	if self.start_scale.x == 0 or self.start_scale.y == 0 then
		return
	end

	local size = vmath.vector3(
		self.start_size.x * (self.start_scale.x / self.scale.x),
		self.start_size.y * (self.start_scale.y / self.scale.y),
		self.start_size.z
	)
	gui.set_size(self.node, size)
end


---Reset initial scale for text
---@private
function M:_reset_default_scale()
	self.scale.x = self.start_scale.x
	self.scale.y = self.start_scale.y
	self.scale.z = self.start_scale.z
	gui.set_scale(self.node, self.start_scale)
	gui.set_size(self.node, self.start_size)
end


---@private
---@param metrics table
---@return boolean
function M:_is_fit_info_area(metrics)
	return metrics.width * self.scale.x <= self.text_area.x and
		   metrics.height * self.scale.y <= self.text_area.y
end


---Setup scale x, but can only be smaller, than start text scale
---@private
function M:_update_text_area_size()
	self:_reset_default_scale()

	local metrics = helper.get_text_metrics_from_node(self.node)

	if metrics.width == 0 then
		self:_reset_default_scale()
		self.on_update_text_scale:trigger(self:get_context(), self.start_scale, metrics)
		return
	end

	local text_area_width = self.text_area.x
	local text_area_height = self.text_area.y

	-- Adjust by width
	local scale_modifier = text_area_width / metrics.width

	-- Adjust by height
	if self:is_multiline() then
		-- Approximate scale by height to start adjust scale
		scale_modifier = math.sqrt(text_area_height / metrics.height)
		if metrics.width * scale_modifier > text_area_width then
			scale_modifier = text_area_width / metrics.width
		end

		-- #RMME
		if self._minimal_scale then
			scale_modifier = math.max(scale_modifier, self._minimal_scale)
		end
		-- Limit max scale by initial scale
		scale_modifier = math.min(scale_modifier, self.start_scale.x)
		-- #RMME

		local is_fit = self:_is_fit_info_area(metrics)
		local step = is_fit and self.style.ADJUST_SCALE_DELTA or -self.style.ADJUST_SCALE_DELTA

		for i = 1, self.style.ADJUST_STEPS do
			-- Grow down to check if we fit
			if step < 0 and is_fit then
				break
			end
			-- Grow up to check if we still fit
			if step > 0 and not is_fit then
				break
			end

			scale_modifier = scale_modifier + step

			if self._minimal_scale then
				scale_modifier = math.max(scale_modifier, self._minimal_scale)
			end
			-- Limit max scale by initial scale
			scale_modifier = math.min(scale_modifier, self.start_scale.x)

			self.scale.x = scale_modifier
			self.scale.y = scale_modifier
			self.scale.z = self.start_scale.z
			gui.set_scale(self.node, self.scale)
			self:_update_text_size()
			metrics = helper.get_text_metrics_from_node(self.node)
			is_fit = self:_is_fit_info_area(metrics)
		end
	end

	if self._minimal_scale then
		scale_modifier = math.max(scale_modifier, self._minimal_scale)
	end

	-- Limit max scale by initial scale
	scale_modifier = math.min(scale_modifier, self.start_scale.x)

	self.scale.x = scale_modifier
	self.scale.y = scale_modifier
	self.scale.z = self.start_scale.z
	gui.set_scale(self.node, self.scale)
	self:_update_text_size()

	self.on_update_text_scale:trigger(self:get_context(), self.scale, metrics)
end


---@private
---@param trim_postfix string
function M:_update_text_with_trim(trim_postfix)
	local max_width = self.text_area.x
	local text_width = self:get_text_size()

	if text_width > max_width then
		local text_length = utf8.len(self.last_value)
		local new_text = self.last_value
		while text_width > max_width do
			text_length = text_length - 1
			new_text = utf8.sub(self.last_value, 1, text_length)
			text_width = self:get_text_size(new_text .. trim_postfix)
			if text_length == 0 then
				break
			end
		end

		gui.set_text(self.node, new_text .. trim_postfix)
	else
		gui.set_text(self.node, self.last_value)
	end
end


---@private
---@param trim_postfix string
function M:_update_text_with_trim_left(trim_postfix)
	local max_width = self.text_area.x
	local text_width = self:get_text_size()
	local text_length = utf8.len(self.last_value)
	local trim_index = 1

	if text_width > max_width then
		local new_text = self.last_value
		while text_width > max_width and trim_index < text_length do
			trim_index = trim_index + 1
			new_text = trim_postfix .. utf8.sub(self.last_value, trim_index, text_length)
			text_width = self:get_text_size(new_text)
		end

		gui.set_text(self.node, new_text)
	end
end


---@private
function M:_update_text_with_anchor_shift()
	if self:get_text_size() >= self.text_area.x then
		self:set_pivot(const.REVERSE_PIVOTS[self.start_pivot])
	else
		self:set_pivot(self.start_pivot)
	end
end


---@private
function M:_update_adjust()
	if not self.adjust_type or self.adjust_type == "no_adjust" then
		self:_reset_default_scale()
		return
	end

	if self.adjust_type == "downscale" then
		self:_update_text_area_size()
	end

	if self.adjust_type == "trim" then
		self:_update_text_with_trim(self.style.TRIM_POSTFIX)
	end

	if self.adjust_type == "trim_left" then
		self:_update_text_with_trim_left(self.style.TRIM_POSTFIX)
	end

	if self.adjust_type == "downscale_limited" then
		self:_update_text_area_size()
	end

	if self.adjust_type == "scroll" then
		self:_update_text_with_anchor_shift()
	end

	if self.adjust_type == "scale_then_scroll" then
		self:_update_text_area_size()
		self:_update_text_with_anchor_shift()
	end

	if self.adjust_type == "scale_then_trim" then
		self:_update_text_area_size()
		self:_update_text_with_trim(self.style.TRIM_POSTFIX)
	end

	if self.adjust_type == "scale_then_trim_left" then
		self:_update_text_area_size()
		self:_update_text_with_trim_left(self.style.TRIM_POSTFIX)
	end
end


return M
