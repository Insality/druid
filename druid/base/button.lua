--- Component to handle basic GUI button
-- @module druid.button

-- TODO: Add button mode:
-- Long tap
-- Repeated tap
-- Double tap?

local const = require("druid.const")
local helper = require("druid.helper")
local component = require("druid.component")

local M = component.create("button", { const.ON_INPUT })


--- Component init function
-- @function button:init
-- @tparam table self Component instance
-- @tparam node node Gui node
-- @tparam function callback Button callback
-- @tparam[opt] table params Button callback params
-- @tparam[opt] node anim_node Button anim node (node, if not provided)
-- @tparam[opt] string event Button react event, const.ACTION_TOUCH by default
function M.init(self, node, callback, params, anim_node, event)
	assert(callback, "Button should have callback. To block input on zone use blocker component")

	self.style = self:get_style()
	self.node = self:get_node(node)

	-- TODO: match event inside on_input?
	self.event = const.ACTION_TOUCH
	self.anim_node = anim_node and helper:get_node(anim_node) or self.node
	-- TODO: rename to start_scale
	self.scale_from = gui.get_scale(self.anim_node)
	self.pos = gui.get_position(self.anim_node)
	self.callback = callback
	self.params = params
	self.hover_anim = self.style.IS_HOVER
	self.click_zone = nil
end


local function set_hover(self, state)
	if self._is_hovered ~= state then
		if self.style.on_hover then
			self.style.on_hover(self, self.anim_node, state)
		end
		self._is_hovered = state
	end
end


local function on_button_release(self)
	if not self.disabled then
		if not self.stub and self.can_action then
			self.can_action = false
			if self.style.on_click then
				self.style.on_click(self, self.anim_node)
			end
			self.callback(self:get_context(), self.params, self)
		else
			set_hover(self, false)
		end
		return true
	else
		if self.style.on_click_disabled then
			self.style.on_click_disabled(self, self.anim_node)
		end
		return false
	end
end


function M.on_input(self, action_id, action)
	if not helper.is_enabled(self.node) then
		return false
	end

	local is_pick = gui.pick_node(self.node, action.x, action.y)
	if self.click_zone then
		is_pick = is_pick and gui.pick_node(self.click_zone, action.x, action.y)
	end

	if not is_pick then
		-- Can't interact, if touch outside of button
		self.can_action = false
		set_hover(self, false)
		return false
	end

	if action.pressed then
		-- Can interact if start touch on the button
		self.can_action = true
		self.repeated_counter = 0
		return true
	end

	if action.released then
		set_hover(self, false)
		return on_button_release(self)
	else
		set_hover(self, true)
	end

	return not self.disabled
end


function M.on_swipe(self)
	-- unhover button if start swipe
	self.can_action = false
	set_hover(self, false)
end


function M.set_enabled(self, state)
	-- if self.disabled == state then
	-- 	return
	-- end

	self.disabled = not state
	if self.style.on_set_enabled then
		self.style.on_set_enabled(self, self.node, state)
	end
end


function M.get_enabled(self)
	return not self.disabled
end


--- Disable all button animations
-- @function button:disable_animation
-- @tparam table self Component instance
function M.disable_animation(self)
	self.hover_anim = false
end


--- Strict button click area. Useful for
-- no click events outside stencil node
-- @function button:set_click_zone
-- @tparam table self Component instance
-- @tparam node zone Gui node
function M.set_click_zone(self, zone)
	self.click_zone = self:get_node(zone)
end


return M
