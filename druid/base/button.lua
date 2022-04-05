-- Copyright (c) 2021 Maksim Tuprikov <insality@gmail.com>. This code is licensed under MIT license

--- Component to handle basic GUI button
-- @module Button
-- @within BaseComponent
-- @alias druid.button

--- On release button callback(self, params, button_instance)
-- @tfield DruidEvent on_click @{DruidEvent}

--- On repeated action button callback(self, params, button_instance, click_amount)
-- @tfield DruidEvent on_repeated_click @{DruidEvent}

---On long tap button callback(self, params, button_instance, time)
-- @tfield DruidEvent on_long_click @{DruidEvent}

---On double tap button callback(self, params, button_instance, click_amount)
-- @tfield DruidEvent on_double_click @{DruidEvent}

---On button hold before long_click callback(self, params, button_instance, time)
-- @tfield DruidEvent on_hold_callback @{DruidEvent}

---On click outside of button(self, params, button_instance)
-- @tfield DruidEvent on_click_outside @{DruidEvent}

---Trigger node
-- @tfield node node

---The hash of trigger node
-- @tfield node_id hash

---Animation node
-- @tfield[opt=node] node anim_node

---Initial scale of anim_node
-- @tfield vector3 start_scale

---Initial pos of anim_node
-- @tfield vector3 start_pos

---Initial pos of anim_node
-- @tfield vector3 pos

---Params to click callbacks
-- @tfield any params

---Druid hover logic component
-- @tfield Hover hover @{Hover}

---Restriction zone
-- @tfield[opt] node click_zone

---

local Event = require("druid.event")
local const = require("druid.const")
local helper = require("druid.helper")
local component = require("druid.component")

local Button = component.create("button")


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
	self.style.on_hover(self, self.anim_node, hover_state)
end


local function on_button_mouse_hover(self, hover_state)
	self.style.on_mouse_hover(self, self.anim_node, hover_state)
end


local function on_button_click(self)
	self.click_in_row = 1
	self.on_click:trigger(self:get_context(), self.params, self)
	self.style.on_click(self, self.anim_node)
end


local function on_button_repeated_click(self)
	if not self.is_repeated_started then
		self.click_in_row = 0
		self.is_repeated_started = true
	end

	self.click_in_row = self.click_in_row + 1
	self.on_repeated_click:trigger(self:get_context(), self.params, self, self.click_in_row)
	self.style.on_click(self, self.anim_node)
end


local function on_button_long_click(self)
	self.click_in_row = 1
	local time = socket.gettime() - self.last_pressed_time
	self.on_long_click:trigger(self:get_context(), self.params, self, time)
	self.style.on_click(self, self.anim_node)
end


local function on_button_double_click(self)
	self.click_in_row = self.click_in_row + 1
	self.on_double_click:trigger(self:get_context(), self.params, self, self.click_in_row)
	self.style.on_click(self, self.anim_node)
end


local function on_button_hold(self, press_time)
	self.on_hold_callback:trigger(self:get_context(), self.params, self, press_time)
end


local function on_button_release(self)
	if self.is_repeated_started then
		return false
	end

	local check_function_result = true
	if self._check_function then
		check_function_result = self._check_function(self:get_context())
	end

	if self.disabled then
		self.style.on_click_disabled(self, self.anim_node)
		return true
	elseif not check_function_result then
		if self._failure_callback then
			self._failure_callback(self:get_context())
		end
		return true
	else
		if self.can_action then
			self.can_action = false

			local time = socket.gettime()
			local is_long_click = (time - self.last_pressed_time) > self.style.LONGTAP_TIME
			is_long_click = is_long_click and self.on_long_click:is_exist()

			local is_double_click = (time - self.last_released_time) < self.style.DOUBLETAP_TIME
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
	end
end


--- Component style params.
-- You can override this component styles params in druid styles table
-- or create your own style
-- @table style
-- @tfield[opt=0.4] number LONGTAP_TIME Minimum time to trigger on_hold_callback
-- @tfield[opt=0.8] number AUTOHOLD_TRIGGER Maximum hold time to trigger button release while holding
-- @tfield[opt=0.4] number DOUBLETAP_TIME Time between double taps
-- @tfield function on_click (self, node)
-- @tfield function on_click_disabled (self, node)
-- @tfield function on_hover (self, node, hover_state)
-- @tfield function on_mouse_hover (self, node, hover_state)
-- @tfield function on_set_enabled (self, node, enabled_state)
function Button.on_style_change(self, style)
	self.style = {}
	self.style.LONGTAP_TIME = style.LONGTAP_TIME or 0.4
	self.style.AUTOHOLD_TRIGGER = style.AUTOHOLD_TRIGGER or 0.8
	self.style.DOUBLETAP_TIME = style.DOUBLETAP_TIME or 0.4

	self.style.on_click = style.on_click or function(_, node) end
	self.style.on_click_disabled = style.on_click_disabled or function(_, node) end
	self.style.on_mouse_hover = style.on_mouse_hover or function(_, node, state) end
	self.style.on_hover = style.on_hover or function(_, node, state) end
	self.style.on_set_enabled = style.on_set_enabled or function(_, node, state) end
end


--- Component init function
-- @tparam Button self @{Button}
-- @tparam node node Gui node
-- @tparam function callback Button callback
-- @tparam[opt] table params Button callback params
-- @tparam[opt] node anim_node Button anim node (node, if not provided)
function Button.init(self, node, callback, params, anim_node)
	self.druid = self:get_druid()
	self.node = self:get_node(node)
	self.node_id = gui.get_id(self.node)

	self.anim_node = anim_node and self:get_node(anim_node) or self.node
	self.start_scale = gui.get_scale(self.anim_node)
	self.start_pos = gui.get_position(self.anim_node)
	self.params = params
	self.hover = self.druid:new_hover(node, on_button_hover)
	self.hover.on_mouse_hover:subscribe(on_button_mouse_hover)
	self.click_zone = nil
	self.is_repeated_started = false
	self.last_pressed_time = 0
	self.last_released_time = 0
	self.click_in_row = 0
	self.key_trigger = nil

	self._check_function = nil
	self._failure_callback = nil

	-- Event stubs
	self.on_click = Event(callback)
	self.on_repeated_click = Event()
	self.on_long_click = Event()
	self.on_double_click = Event()
	self.on_hold_callback = Event()
	self.on_click_outside = Event()
end


function Button.on_late_init(self)
	if not self.click_zone and const.IS_STENCIL_CHECK then
		local stencil_node = helper.get_closest_stencil_node(self.node)
		if stencil_node then
			self:set_click_zone(stencil_node)
		end
	end
end


function Button.on_internal_remove(self)
	component.on_internal_remove(self)
	self.on_click:clear()
	self.on_repeated_click:clear()
	self.on_long_click:clear()
	self.on_double_click:clear()
	self.on_hold_callback:clear()
	self.on_click_outside:clear()
end


function Button.on_input(self, action_id, action)
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
		if action.released then
			self.on_click_outside:trigger(self:get_context(), self.params, self)
		end
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

		if self.style.AUTOHOLD_TRIGGER <= press_time then
			on_button_release(self)
			return true
		end

		if press_time >= self.style.LONGTAP_TIME then
			on_button_hold(self, press_time)
			return true
		end
	end

	return not self.disabled
end


function Button.on_input_interrupt(self)
	self.can_action = false
end


function Button.on_message_input(self, node_id, message)
	if node_id ~= self.node_id or self.disabled or not helper.is_enabled(self.node) then
		return false
	end

	if message.action == const.MESSAGE_INPUT.BUTTON_CLICK then
		on_button_click(self)
	end

	if message.action == const.MESSAGE_INPUT.BUTTON_LONG_CLICK then
		on_button_long_click(self)
	end

	if message.action == const.MESSAGE_INPUT.BUTTON_DOUBLE_CLICK then
		on_button_double_click(self)
	end

	if message.action == const.MESSAGE_INPUT.BUTTON_REPEATED_CLICK then
		on_button_repeated_click(self)
		self.is_repeated_started = false
		self.last_pressed_time = socket.gettime()
	end
end


--- Set enabled button component state
-- @tparam Button self @{Button}
-- @tparam bool state Enabled state
-- @treturn Button Current button instance
function Button.set_enabled(self, state)
	self.disabled = not state
	self.hover:set_enabled(state)
	self.style.on_set_enabled(self, self.node, state)

	return self
end


--- Return button enabled state
-- @tparam Button self @{Button}
-- @treturn bool True, if button is enabled
function Button.is_enabled(self)
	return not self.disabled
end


--- Strict button click area. Useful for
-- no click events outside stencil node
-- @tparam Button self @{Button}
-- @tparam node zone Gui node
-- @treturn Button Current button instance
function Button.set_click_zone(self, zone)
	self.click_zone = self:get_node(zone)
	self.hover:set_click_zone(zone)

	return self
end


--- Set key-code to trigger this button
-- @tparam Button self @{Button}
-- @tparam hash key The action_id of the key
-- @treturn Button Current button instance
function Button.set_key_trigger(self, key)
	self.key_trigger = hash(key)

	return self
end


--- Get key-code to trigger this button
-- @tparam Button self
-- @treturn hash The action_id of the key
function Button.get_key_trigger(self)
	return self.key_trigger
end


--- Set function for additional check for button click availability
-- @tparam Button self
-- @tparam[opt] function check_function Should return true or false. If true - button can be pressed.
-- @tparam[opt] function failure_callback Function what will be called on button click, if check function return false
-- @treturn Button Current button instance
function Button.set_check_function(self, check_function, failure_callback)
	self._check_function = check_function
	self._failure_callback = failure_callback
end


return Button
