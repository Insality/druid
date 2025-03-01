local helper = require("druid.helper")
local druid_const = require("druid.const")
local component = require("druid.component")

---@class hover_hint: druid.base_component
---@field druid druid.instance
---@field root node
---@field panel_hint node
---@field text_hint druid.text
---@field hovers druid.hover[]
---@field is_shown boolean
---@field private _hint_text string
---@field private _hover_timer_id hash
local M = component.create("hover_hint")

local TIMER_DELAY = 0.5
local MIN_PANEL_WIDTH = 100
local MIN_PANEL_HEIGHT = 50
local PANEL_MARGIN = 40
local HINT_OFFSET = 20

---@param template string
function M:init(template, nodes)
	self.druid = self:get_druid(template, nodes)

	self.root = self:get_node("root")
	self.panel_hint = self:get_node("panel_hint")
	self.text_hint = self.druid:new_text("text_hint")

	self.hovers = {}
	self._timer_id = nil
	self.is_shown = false

	gui.set_enabled(self.root, false)
end


---@param node node|string
---@param hint_text string
---@param pivot_point constant
---@param content_pivot constant
function M:add_hover_hint(node, hint_text, pivot_point, content_pivot)
	local hover = self.druid:new_hover(node, nil, function(_, is_hover)
		self:hide_hint()

		if is_hover then
			self._timer_id = timer.delay(TIMER_DELAY, false, function()
				self._timer_id = nil
				self:show_hint(node, hint_text, pivot_point, content_pivot)
			end)
		end
	end)

	table.insert(self.hovers, hover)
end


function M:hide_hint()
	if self._timer_id then
		timer.cancel(self._timer_id)
		self._timer_id = nil
	end

	if self.is_shown then
		self.is_shown = false
		gui.animate(self.root, "color.w", 0, gui.EASING_OUTSINE, 0.2, 0, function()
			gui.set_enabled(self.root, false)
		end)
	end
end


---@param hint_text string
---@param pivot_point constant
---@param content_pivot constant
function M:show_hint(node, hint_text, pivot_point, content_pivot)
	self:refresh_content(node, hint_text, pivot_point, content_pivot)

	self.is_shown = true

	do -- Animate appear
		gui.set_enabled(self.root, true)
		gui.set_alpha(self.root, 0)
		gui.animate(self.root, "color.w", 1, gui.EASING_OUTSINE, 0.2)
	end
end


---@private
function M:refresh_content(node, hint_text, pivot_point, content_pivot)
	self.text_hint:set_text(hint_text)
	local text_width, text_height = self.text_hint:get_text_size()

	local panel_width = math.max(text_width, MIN_PANEL_WIDTH) + PANEL_MARGIN
	local panel_height = math.max(text_height, MIN_PANEL_HEIGHT) + PANEL_MARGIN

	gui.set(self.root, "size.x", panel_width)
	gui.set(self.root, "size.y", panel_height)
	gui.set(self.panel_hint, "size.x", panel_width)
	gui.set(self.panel_hint, "size.y", panel_height)

	self:refresh_position(node, pivot_point, content_pivot)
end


---@private
---@param node node
---@param pivot_point constant
---@param content_pivot constant
function M:refresh_position(node, pivot_point, content_pivot)
	local screen_position = gui.get_screen_position(node)
	local node_size = gui.get_size(node)
	node_size.x = node_size.x + HINT_OFFSET * 2
	node_size.y = node_size.y + HINT_OFFSET * 2

	-- Offset for trigger node
	local offset = -vmath.mul_per_elem(node_size, druid_const.PIVOTS[gui.get_pivot(node)])

	-- Offset from center to pivot pointi
	offset = offset + vmath.mul_per_elem(node_size, druid_const.PIVOTS[pivot_point])

	-- Offset for hint component
	local hint_size = gui.get_size(self.root)
	offset = offset - vmath.mul_per_elem(hint_size, druid_const.PIVOTS[content_pivot])

	-- Position
	local world_scale = helper.get_scene_scale(self.root)
	local local_pos = gui.screen_to_local(self.root, screen_position) / world_scale.x
	gui.set_position(self.root, local_pos)

	local position = gui.get_position(self.root)
	if offset then
		position = position + offset
	end
	gui.set_position(self.root, position)
end


return M
