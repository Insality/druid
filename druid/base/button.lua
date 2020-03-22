--- Component to handle basic GUI button
-- @module druid.button

--- Component events
-- @table Events
-- @tfield druid_event on_click On release button callback
-- @tfield druid_event on_repeated_click On repeated action button callback
-- @tfield druid_event on_long_click On long tap button callback
-- @tfield druid_event on_double_click On double tap button callback
-- @tfield druid_event on_hold_click On button hold before long_click callback

--- Component fields
-- @table Fields
-- @tfield node node Trigger node
-- @tfield[opt=node] node anim_node Animation node
-- @tfield vector3 scale_from Initial scale of anim_node
-- @tfield vector3 pos Initial pos of anim_node
-- @tfield any params Params to click callbacks
-- @tfield druid.hover hover Druid hover logic component
-- @tfield[opt] node click_zone Restriction zone

--- Component style params
-- @table Style
-- @tfield function on_click (self, node)
-- @tfield function on_click_disabled (self, node)
-- @tfield function on_hover (self, node, hover_state)
-- @tfield function on_set_enabled (self, node, enabled_state)
-- @tfield bool IS_HOVER

local Event = require("druid.event")
local const = require("druid.const")
local helper = require("druid.helper")
local component = require("druid.component")

local M = component.create("button", { const.ON_INPUT })


local function is_input_match(self, action_id)
	if action_id == const.ACTION_TOUCH then
		return true
	end

	if self.key_trigger and action_id == self.key_trigger then
		return true
	end

	return false
end


local function on_button_hover(self, hover_state)
	if not self._style.on_hover then
		return
	end

	self._style.on_hover(self, self.anim_node, hover_state)
end


local function on_button_click(self)
	if self._style.on_click then
		self._style.on_click(self, self.anim_node)
	end
	self.click_in_row = 1
	self.on_click:trigger(self:get_context(), self.params, self)
end


local function on_button_repeated_click(self)
	if not self.is_repeated_started then
		self.click_in_row = 0
		self.is_repeated_started = true
	end

	if self._style.on_click then
		self._style.on_click(self, self.anim_node)
	end
	self.click_in_row = self.click_in_row + 1
	self.on_repeated_click:trigger(self:get_context(), self.params, self, self.click_in_row)
end


local function on_button_long_click(self)
	if self._style.on_click then
		self._style.on_click(self, self.anim_node)
	end
	self.click_in_row = 1
	local time = socket.gettime() - self.last_pressed_time
	self.on_long_click:trigger(self:get_context(), self.params, self, time)
end


local function on_button_double_click(self)
	if self._style.on_click then
		self._style.on_click(self, self.anim_node)
	end
	self.click_in_row = self.click_in_row + 1
	self.on_double_click:trigger(self:get_context(), self.params, self, self.click_in_row)
end


local function on_button_hold(self, press_time)
	self.on_hold_click:trigger(self:get_context(), self.params, self, press_time)
end


local function on_button_release(self)
	if self.is_repeated_started then
		return false
	end

	if not self.disabled then
		if self.can_action then
			self.can_action = false

			local time = socket.gettime()
			local is_long_click = (time - self.last_pressed_time) > self._style.LONGTAP_TIME
			is_long_click = is_long_click and self.on_long_click:is_exist()

			local is_double_click = (time - self.last_released_time) < self._style.DOUBLETAP_TIME
			is_double_click = is_double_click and self.on_double_click:is_exist()

			if is_long_click then
				on_button_long_click(self)
			elseif is_double_click then
				on_button_double_click(self)
			else
				on_button_click(self)
			end

			self.last_released_time = time
		end
		return true
	else
		if self._style.on_click_disabled then
			self._style.on_click_disabled(self, self.anim_node)
		end
		return false
	end
end


--- Component init function
-- @function button:init
-- @tparam node node Gui node
-- @tparam function callback Button callback
-- @tparam[opt] table params Button callback params
-- @tparam[opt] node anim_node Button anim node (node, if not provided)
-- @tparam[opt] string event Button react event, const.ACTION_TOUCH by default
function M.init(self, node, callback, params, anim_node, event)
	self.druid = self:get_druid()
	self.node = self:get_node(node)

	self.anim_node = anim_node and helper:get_node(anim_node) or self.node
	-- TODO: rename to start_scale
	self.scale_from = gui.get_scale(self.anim_node)
	self.params = params
	self.hover = self.druid:new_hover(node, on_button_hover)
	self.click_zone = nil
	self.is_repeated_started = false
	self.last_pressed_time = 0
	self.last_released_time = 0
	self.click_in_row = 0
	self.key_trigger = nil

	-- Event stubs
	self.on_click = Event(callback)
	self.on_repeated_click = Event()
	self.on_long_click = Event()
	self.on_double_click = Event()
	self.on_hold_click = Event()
end


function M.on_input(self, action_id, action)
	if not is_input_match(self, action_id) then
		return false
	end

	if not helper.is_enabled(self.node) then
		return false
	end

	local is_pick = true
	local is_key_trigger = (action_id == self.key_trigger)
	if not is_key_trigger then
		is_pick = gui.pick_node(self.node, action.x, action.y)
		if self.click_zone then
			is_pick = is_pick and gui.pick_node(self.click_zone, action.x, action.y)
		end
	end

	if not is_pick then
		-- Can't interact, if touch outside of button
		self.can_action = false
		return false
	end

	if is_key_trigger then
		self.hover:set_hover(not action.released)
	end

	if action.pressed then
		-- Can interact if start touch on the button
		self.can_action = true
		self.is_repeated_started = false
		self.last_pressed_time = socket.gettime()
		return true
	end

	-- While hold button, repeat rate pick from input.repeat_interval
	if action.repeated then
		if not self.disabled and self.on_repeated_click:is_exist() and self.can_action then
			on_button_repeated_click(self)
			return true
		end
	end

	if action.released then
		return on_button_release(self)
	end

	if not self.disabled and self.can_action and self.on_long_click:is_exist() then
		local press_time = socket.gettime() - self.last_pressed_time

		if self._style.AUTOHOLD_TRIGGER and self._style.AUTOHOLD_TRIGGER <= press_time then
			on_button_release(self)
			return true
		end

		if press_time >= self._style.LONGTAP_TIME then
			on_button_hold(self, press_time)
			return true
		end
	end

	return not self.disabled
end


function M.on_input_interrupt(self)
	self.can_action = false
end


--- Set enabled button component state
-- @function button:set_enabled
-- @tparam bool state Enabled state
function M.set_enabled(self, state)
	self.disabled = not state
	if self._style.on_set_enabled then
		self._style.on_set_enabled(self, self.node, state)
	end
end


--- Return button enabled state
-- @function button:is_enabled
-- @treturn bool True, if button is enabled
function M.is_enabled(self)
	return not self.disabled
end


--- Strict button click area. Useful for
-- no click events outside stencil node
-- @function button:set_click_zone
-- @tparam node zone Gui node
function M.set_click_zone(self, zone)
	self.click_zone = self:get_node(zone)
	self.hover:set_click_zone(zone)
end


--- Set key-code to trigger this button
-- @function button:set_key_trigger
-- @tparam hash key The action_id of the key
function M.set_key_trigger(self, key)
	self.key_trigger = hash(key)
end


--- Get key-code to trigger this button
-- @function button:get_key_trigger
-- @treturn hash The action_id of the key
function M.get_key_trigger(self)
	return self.key_trigger
end


return M
