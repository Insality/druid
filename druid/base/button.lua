--- Component to handle basic GUI button
-- @module druid.button

--- Component events
-- @table Events
-- @tfield druid_event on_click (self, params, button_instance) On release button callback
-- @tfield druid_event on_repeated_click (self, params, button_instance, click_amount) On repeated action button callback
-- @tfield druid_event on_long_click (self, params, button_instance, time) On long tap button callback
-- @tfield druid_event on_double_click (self, params, button_instance, click_amount) On double tap button callback
-- @tfield druid_event on_hold_callback (self, params, button_instance, time) On button hold before long_click callback
-- @tfield druid_event on_click_outside (self, params, button_instance) On click outside of button

--- Component fields
-- @table Fields
-- @tfield node node Trigger node
-- @tfield[opt=node] node anim_node Animation node
-- @tfield vector3 start_scale Initial scale of anim_node
-- @tfield vector3 start_pos Initial pos of anim_node
-- @tfield vector3 pos Initial pos of anim_node
-- @tfield any params Params to click callbacks
-- @tfield druid.hover hover Druid hover logic component
-- @tfield[opt] node click_zone Restriction zone

local Event = require("druid.event")
local const = require("druid.const")
local helper = require("druid.helper")
local component = require("druid.component")

local M = component.create("button", { const.ON_INPUT })

local function is_single_triggered(self, action_id)
	return self.key_trigger and action_id == self.key_trigger
end

local function is_key_triggered(self, action_id, action)
	if self.key_combo_trigger[action_id] then
		local triggered = true

		if action.pressed then
			self.key_combo_count = self.key_combo_count + 1
			self.key_combo_triggered[action_id] = self.key_combo_count
		elseif action.released then
			self.key_combo_count = self.key_combo_count - 1
			self.key_combo_triggered[action_id] = nil
		end

		for key, order in pairs(self.key_combo_trigger) do
			if order ~= self.key_combo_triggered[key] then
				triggered = false
			end
		end

		return triggered
	elseif is_single_triggered(self, action_id) then
		return true
	else
		return false
	end
end

local function is_input_match(self, action_id)
	if action_id == const.ACTION_TOUCH then
		return true
	end

	if self.key_trigger and action_id == self.key_trigger then
		return true
	end

	if self.key_combo_trigger[action_id] then
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
	self.style.on_click(self, self.anim_node)

	self.click_in_row = 1
	self.on_click:trigger(self:get_context(), self.params, self)
end


local function on_button_repeated_click(self)
	if not self.is_repeated_started then
		self.click_in_row = 0
		self.is_repeated_started = true
	end

	self.style.on_click(self, self.anim_node)

	self.click_in_row = self.click_in_row + 1
	self.on_repeated_click:trigger(self:get_context(), self.params, self, self.click_in_row)
end


local function on_button_long_click(self)
	self.style.on_click(self, self.anim_node)

	self.click_in_row = 1
	local time = socket.gettime() - self.last_pressed_time
	self.on_long_click:trigger(self:get_context(), self.params, self, time)
end


local function on_button_double_click(self)
	self.style.on_click(self, self.anim_node)

	self.click_in_row = self.click_in_row + 1
	self.on_double_click:trigger(self:get_context(), self.params, self, self.click_in_row)
end


local function on_button_hold(self, press_time)
	self.on_hold_callback:trigger(self:get_context(), self.params, self, press_time)
end


local function on_button_release(self)
	if self.is_repeated_started then
		return false
	end

	if not self.disabled then
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
	else
		self.style.on_click_disabled(self, self.anim_node)
		return false
	end
end


--- Component style params.
-- You can override this component styles params in druid styles table
-- or create your own style
-- @table Style
-- @tfield[opt=0.4] number LONGTAP_TIME Minimum time to trigger on_hold_callback
-- @tfield[opt=0.8] number AUTOHOLD_TRIGGER Maximum hold time to trigger button release while holding
-- @tfield[opt=0.4] number DOUBLETAP_TIME Time between double taps
-- @tfield function on_click (self, node)
-- @tfield function on_click_disabled (self, node)
-- @tfield function on_hover (self, node, hover_state)
-- @tfield function on_mouse_hover (self, node, hover_state)
-- @tfield function on_set_enabled (self, node, enabled_state)
function M.on_style_change(self, style)
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
-- @function button:init
-- @tparam node node Gui node
-- @tparam function callback Button callback
-- @tparam[opt] table params Button callback params
-- @tparam[opt] node anim_node Button anim node (node, if not provided)
function M.init(self, node, callback, params, anim_node)
	self.druid = self:get_druid()
	self.node = self:get_node(node)

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
	self.key_combo_trigger = {}
	self.key_combo_count = 0
	self.key_combo_triggered = {}

	-- Event stubs
	self.on_click = Event(callback)
	self.on_repeated_click = Event()
	self.on_long_click = Event()
	self.on_double_click = Event()
	self.on_hold_callback = Event()
	self.on_click_outside = Event()
end


function M.on_input(self, action_id, action)
	if not is_input_match(self, action_id) then
		return false
	end

	if not helper.is_enabled(self.node) then
		return false
	end

	local is_pick = true
	local is_key_trigger = is_key_triggered(self, action_id, action)
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
		if is_single_triggered(self, action_id) then
			self.hover:set_hover(not action.released)
		else
			self.can_action = true
			self.is_repeated_started = false
			self.last_pressed_time = socket.gettime()
			self.key_combo_triggered[action_id] = nil
			return on_button_release(self)
		end
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


function M.on_input_interrupt(self)
	self.can_action = false
end


--- Set enabled button component state
-- @function button:set_enabled
-- @tparam bool state Enabled state
function M.set_enabled(self, state)
	self.disabled = not state
	self.style.on_set_enabled(self, self.node, state)
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
-- @tparam druid.button Self instance to make chain calls
function M.set_click_zone(self, zone)
	self.click_zone = self:get_node(zone)
	self.hover:set_click_zone(zone)
	return self
end


--- Set key-code to trigger this button
-- @function button:set_key_trigger
-- @tparam hash key The action_id of the key
-- @tparam druid.button Self instance to make chain calls
function M.set_key_trigger(self, key)
	self.key_trigger = hash(key)
	return self
end


--- Get key-code to trigger this button
-- @function button:get_key_trigger
-- @treturn hash The action_id of the key
function M.get_key_trigger(self)
	return self.key_trigger
end


--- Set combo-key-code to trigger this button
-- @function button:set_key_combo_trigger
-- @tparam varargs of hash keys Multiple action_id's of the keys
-- @treturn druid.button Self instance to make chain calls
function M.set_key_combo_trigger(self, ...)
	local triggers = {}
	local triggered = {}

	for i, v in pairs({...}) do
		triggers[hash(v)] = i
		triggered[hash(v)] = nil
	end

	self.key_combo_trigger = triggers
	self.key_combo_triggered = triggered
	return self
end


--- Get combo-key-code to trigger this button
-- @function button:get_key_combo_trigger
-- @treturn table Where key is hash key and value is press order
function M.get_key_combo_trigger(self)
	return self.key_combo_trigger
end


return M
