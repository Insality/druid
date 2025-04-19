local event = require("event.event")
local const = require("druid.const")
local helper = require("druid.helper")
local component = require("druid.component")

---@class druid.hover.style
---@field ON_HOVER_CURSOR string|nil Mouse hover style on node hover
---@field ON_MOUSE_HOVER_CURSOR string|nil Mouse hover style on node mouse hover

---The component for handling hover events on a node
---@class druid.hover: druid.component
---@field node node Gui node
---@field on_hover event fun(self: druid.hover, is_hover: boolean) Hover event
---@field on_mouse_hover event fun(self: druid.hover, is_hover: boolean) Mouse hover event
---@field style druid.hover.style Style of the hover component
---@field click_zone node Click zone of the hover component
---@field private _is_hovered boolean|nil True if the node is hovered
---@field private _is_mouse_hovered boolean|nil True if the node is mouse hovered
---@field private _is_enabled boolean|nil True if the hover component is enabled
---@field private _is_mobile boolean True if the platform is mobile
local M = component.create("hover")


---The constructor for the hover component
---@param node node Gui node
---@param on_hover_callback function Hover callback
---@param on_mouse_hover function On mouse hover callback
function M:init(node, on_hover_callback, on_mouse_hover)
	self.node = self:get_node(node)

	self._is_hovered = false
	self._is_mouse_hovered = false
	self._is_enabled = true
	self._is_mobile = helper.is_mobile()

	self.on_hover = event.create(on_hover_callback)
	self.on_mouse_hover = event.create(on_mouse_hover)
end


---@private
function M:on_late_init()
	if not self.click_zone then
		local stencil_node = helper.get_closest_stencil_node(self.node)
		if stencil_node then
			self:set_click_zone(stencil_node)
		end
	end
end


---@private
---@param style druid.hover.style
function M:on_style_change(style)
	self.style = {}
	self.style.ON_HOVER_CURSOR = style.ON_HOVER_CURSOR or nil
	self.style.ON_MOUSE_HOVER_CURSOR = style.ON_MOUSE_HOVER_CURSOR or nil
end


---@private
---@param action_id hash Action id from on_input
---@param action table Action from on_input
---@return boolean is_consumed True if the input was consumed
function M:on_input(action_id, action)
	if action_id ~= const.ACTION_TOUCH and action_id ~= nil then
		return false
	end

	-- Disable nil (it's mouse) hover or mobile platforms
	if self._is_mobile and not action_id then
		return false
	end

	if not gui.is_enabled(self.node, true) or not self._is_enabled then
		self:set_hover(false)
		self:set_mouse_hover(false)
		return false
	end

	local is_pick = helper.pick_node(self.node, action.x, action.y, self.click_zone)
	local hover_function = action_id and self.set_hover or self.set_mouse_hover

	if not is_pick then
		hover_function(self, false)
		return false
	end

	if action.released then
		hover_function(self, false)
	else
		hover_function(self, true)
	end

	return false
end


---@private
function M:on_input_interrupt()
	self:set_hover(false)
end


---Set hover state
---@param state boolean|nil The hover state
function M:set_hover(state)
	if self._is_hovered == state then
		return
	end

	self._is_hovered = state
	self.on_hover:trigger(self:get_context(), state, self)

	if defos and self.style.ON_HOVER_CURSOR then
		self:_set_cursor(3, state and self.style.ON_HOVER_CURSOR or nil)
	end
end


---Return current hover state. True if touch action was on the node at current time
---@return boolean is_hovered The current hovered state
function M:is_hovered()
	return self._is_hovered
end


---Set mouse hover state
---@param state boolean|nil The mouse hover state
function M:set_mouse_hover(state)
	if self._is_mouse_hovered == state then
		return
	end

	self._is_mouse_hovered = state
	self.on_mouse_hover:trigger(self:get_context(), state, self)

	if defos and self.style.ON_MOUSE_HOVER_CURSOR then
		self:_set_cursor(2, state and self.style.ON_MOUSE_HOVER_CURSOR or nil)
	end
end


---Return current hover state. True if nil action_id (usually desktop mouse) was on the node at current time
---@return boolean The current hovered state
function M:is_mouse_hovered()
	return self._is_mouse_hovered
end


---Strict hover click area. Useful for no click events outside stencil node
---@param zone node|string|nil Gui node
function M:set_click_zone(zone)
	if not zone then
		self.click_zone = nil
		return
	end

	self.click_zone = self:get_node(zone)
end


---Set enable state of hover component.
---If hover is not enabled, it will not generate
---any hover events
---@param state boolean|nil The hover enabled state
function M:set_enabled(state)
	self._is_enabled = state

	if not state then
		if self._is_hovered then
			self:set_hover(false)
		end
		if self._is_mouse_hovered then
			self:set_mouse_hover(false)
		end
	end
end


---Return current hover enabled state
---@return boolean The hover enabled state
function M:is_enabled()
	return self._is_enabled
end


-- Internal cursor stack
local cursor_stack = {}
---@local
function M:_set_cursor(priority, cursor)
	if not defos then
		return
	end

	local uid = self:get_uid()
	cursor_stack[uid] = cursor_stack[uid] or {}
	cursor_stack[uid][priority] = cursor

	-- set cursor with high priority via pairs
	local priority = nil
	local cursor_to_set = nil
	for _, stack in pairs(cursor_stack) do
		for pr, _ in pairs(stack) do
			if pr > (priority or 0) then
				priority = pr
				cursor_to_set = stack[priority]
			end
		end
	end

	defos.set_cursor(cursor_to_set)
end


return M
