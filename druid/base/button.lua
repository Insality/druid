local event = require("event.event")
local const = require("druid.const")
local helper = require("druid.helper")
local component = require("druid.component")

---Button style params.
---You can override this component styles params in Druid styles table or create your own style
---@class druid.button.style
---@field LONGTAP_TIME number|nil Minimum time to trigger on_hold_callback. Default: 0.4
---@field AUTOHOLD_TRIGGER number|nil Maximum hold time to trigger button release while holding. Default: 0.8
---@field DOUBLETAP_TIME number|nil Time between double taps. Default: 0.4
---@field on_click fun(self, node)|nil
---@field on_click_disabled fun(self, node)|nil
---@field on_hover fun(self, node, hover_state)|nil
---@field on_mouse_hover fun(self, node, hover_state)|nil
---@field on_set_enabled fun(self, node, enabled_state)|nil

---Basic Druid input component. Handle input on node and provide different callbacks on touch events.
---
---### Setup
---Create button with druid: `button = druid:new_button(node_name, callback, [params], [animation_node])`
---Where node_name is name of node from GUI scene. You can use `node_name` as input trigger zone and point another node for animation via `animation_node`
---
---### Notes
---- Button callback have next params: (self, params, button_instance)
----   - **self** - Druid self context
----   - **params** - Additional params, specified on button creating
----   - **button_instance** - button itself
---- You can set _params_ on button callback on button creating: `druid:new_button("node_name", callback, params)`.
---- Button have several events like on_click, on_repeated_click, on_long_click, on_hold_click, on_double_click
---- Click event will not trigger if between pressed and released state cursor was outside of node zone
---- Button can have key trigger to use them by key: `button:set_key_trigger`
----
---@class druid.button: druid.component
---@field on_click event function(self, custom_args, button_instance)
---@field on_pressed event function(self, custom_args, button_instance)
---@field on_repeated_click event function(self, custom_args, button_instance, click_count) Repeated click callback, while holding the button
---@field on_long_click event function(self, custom_args, button_instance, hold_time) Callback on long button tap
---@field on_double_click event function(self, custom_args, button_instance, click_amount) Different callback, if tap button 2+ in row
---@field on_hold_callback event function(self, custom_args, button_instance, press_time) Hold callback, before long_click trigger
---@field on_click_outside event function(self, custom_args, button_instance)
---@field node node Clickable node
---@field node_id hash Node id
---@field anim_node node Animation node. In default case equals to clickable node
---@field params any Custom arguments for any Button event
---@field hover druid.hover Hover component for this button
---@field click_zone node|nil Click zone node to restrict click area
---@field start_scale vector3 Start scale of the button
---@field start_pos vector3 Start position of the button
---@field disabled boolean Is button disabled
---@field key_trigger hash Key trigger for this button
---@field style table Style for this button
local M = component.create("button")


---The constructor for the button component
---@param node_or_node_id node|string Node name or GUI Node itself
---@param callback fun()|nil Callback on button click
---@param custom_args any|nil Custom args for any Button event, will be passed to callbacks
---@param anim_node node|string|nil Node to animate instead of trigger node, useful for animating small icons on big panels
function M:init(node_or_node_id, callback, custom_args, anim_node)
	self.druid = self:get_druid()
	self.node = self:get_node(node_or_node_id)
	self.node_id = gui.get_id(self.node)

	self.anim_node = anim_node and self:get_node(anim_node) or self.node
	self.start_scale = gui.get_scale(self.anim_node)
	self.start_pos = gui.get_position(self.anim_node)
	self.params = custom_args
	self.hover = self.druid:new_hover(node_or_node_id, self._on_button_hover)
	self.hover.on_mouse_hover:subscribe(self._on_button_mouse_hover)
	self.click_zone = nil
	self.is_repeated_started = false
	self.last_pressed_time = 0
	self.last_released_time = 0
	self.click_in_row = 0
	self.key_trigger = nil

	self._check_function = nil
	self._failure_callback = nil
	self._is_html5_mode = false
	self._is_html5_listener_set = false

	-- Events
	self.on_click = event.create(callback)
	self.on_pressed = event.create()
	self.on_repeated_click = event.create()
	self.on_long_click = event.create()
	self.on_double_click = event.create()
	self.on_hold_callback = event.create()
	self.on_click_outside = event.create()
end


---@private
---@param style druid.button.style
function M:on_style_change(style)
	self.style = {
		LONGTAP_TIME = style.LONGTAP_TIME or 0.4,
		AUTOHOLD_TRIGGER = style.AUTOHOLD_TRIGGER or 0.8,
		DOUBLETAP_TIME = style.DOUBLETAP_TIME or 0.4,

		on_click = style.on_click or function(_, node) end,
		on_click_disabled = style.on_click_disabled or function(_, node) end,
		on_mouse_hover = style.on_mouse_hover or function(_, node, state) end,
		on_hover = style.on_hover or function(_, node, state) end,
		on_set_enabled = style.on_set_enabled or function(_, node, state) end,
	}
end


---Remove default button style animations
---@return druid.button self The current button instance
function M:set_animations_disabled()
	local empty_function = function() end

	self.style.on_click = empty_function
	self.style.on_hover = empty_function
	self.style.on_mouse_hover = empty_function
	self.style.on_set_enabled = empty_function
	self.style.on_click_disabled = empty_function

	return self
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
---@param action_id hash The action id
---@param action table The action table
---@return boolean is_consumed True if the input was consumed
function M:on_input(action_id, action)
	if not self:_is_input_match(action_id) then
		return false
	end

	if not gui.is_enabled(self.node, true) then
		return false
	end

	local is_consume = true
	local is_pick = true
	local is_key_trigger = (action_id == self.key_trigger)
	if not is_key_trigger then
		is_pick = helper.pick_node(self.node, action.x, action.y, self.click_zone)
	end

	if not is_pick then
		-- Can't interact, if touch outside of button
		self.can_action = false
		if action.released then
			self.on_click_outside:trigger(self:get_context(), self.params, self)
		end

		if self._is_html5_mode and self._is_html5_listener_set then
			self._is_html5_listener_set = false
			html5.set_interaction_listener(nil)
		end
		return false
	end

	if is_key_trigger then
		self.hover:set_hover(not action.released)
		is_consume = false
	end

	if action.pressed then
		-- Can interact if start touch on the button
		self.can_action = true
		self.is_repeated_started = false
		self.last_pressed_time = socket.gettime()
		self.on_pressed:trigger(self:get_context(), self.params, self)

		if self._is_html5_mode then
			self._is_html5_listener_set = true
			html5.set_interaction_listener(function()
				self:_on_button_click()
			end)
		end
		return is_consume
	end

	-- While hold button, repeat rate pick from input.repeat_interval
	if action.repeated then
		if not self.on_repeated_click:is_empty() and self.can_action then
			self:_on_button_repeated_click()
			return is_consume
		end
	end

	if action.released then
		return self:_on_button_release() and is_consume
	end

	if self.can_action and not self.on_long_click:is_empty() then
		local press_time = socket.gettime() - self.last_pressed_time

		if self.style.AUTOHOLD_TRIGGER <= press_time then
			self:_on_button_release()
			return is_consume
		end

		if press_time >= self.style.LONGTAP_TIME then
			self:_on_button_hold(press_time)
			return is_consume
		end
	end

	return not self.disabled and is_consume
end


---@private
function M:on_input_interrupt()
	self.can_action = false
	self.hover:set_hover(false)
	self.hover:set_mouse_hover(false)
end


---Set button enabled state.
---The style.on_set_enabled will be triggered.
---Disabled button is not clickable.
---@param state boolean|nil Enabled state
---@return druid.button self The current button instance
function M:set_enabled(state)
	self.disabled = not state
	self.hover:set_enabled(state)
	self.style.on_set_enabled(self, self.node, state)

	return self
end


---Get button enabled state.
---By default all Buttons is enabled on creating.
---@return boolean is_enabled True, if button is enabled now, False overwise
function M:is_enabled()
	return not self.disabled
end


---Set additional button click area.
---Useful to restrict click outside out stencil node or scrollable content.
---If button node placed inside stencil node, it will be automatically set to this stencil node.
---@param zone node|string|nil Gui node
---@return druid.button self The current button instance
function M:set_click_zone(zone)
	self.click_zone = zone and self:get_node(zone) or nil
	self.hover:set_click_zone(zone)

	return self
end


---Set key name to trigger this button by keyboard.
---@param key hash|string The action_id of the input key. Example: "key_space"
---@return druid.button self The current button instance
function M:set_key_trigger(key)
	if type(key) == "string" then
		self.key_trigger = hash(key)
	else
		self.key_trigger = key
	end

	return self
end


---Get current key name to trigger this button.
---@return hash key_trigger The action_id of the input key
function M:get_key_trigger()
	return self.key_trigger
end


---Set function for additional check for button click availability
---@param check_function function|nil Should return true or false. If true - button can be pressed.
---@param failure_callback function|nil Function will be called on button click, if check function return false
---@return druid.button self The current button instance
function M:set_check_function(check_function, failure_callback)
	self._check_function = check_function
	self._failure_callback = failure_callback

	return self
end


---Set Button mode to work inside user HTML5 interaction event.
---
---It's required to make protected things like copy & paste text, show mobile keyboard, etc
---The HTML5 button's doesn't call any events except on_click event.
---
---If the game is not HTML, html mode will be not enabled
---@param is_web_mode boolean|nil If true - button will be called inside html5 callback
---@return druid.button self The current button instance
function M:set_web_user_interaction(is_web_mode)
	self._is_html5_mode = not not (is_web_mode and html5)
	return self
end


---@param action_id hash The action id
---@return boolean is_match True if the input matches the button
function M:_is_input_match(action_id)
	if action_id == const.ACTION_TOUCH or action_id == const.ACTION_MULTITOUCH then
		return true
	end

	if self.key_trigger and action_id == self.key_trigger then
		return true
	end

	return false
end


---@param hover_state boolean True if the hover state is active
function M:_on_button_hover(hover_state)
	self.style.on_hover(self, self.anim_node, hover_state)
end


---@param hover_state boolean True if the hover state is active
function M:_on_button_mouse_hover(hover_state)
	self.style.on_mouse_hover(self, self.anim_node, hover_state)
end


function M:_on_button_click()
	if self._is_html5_mode then
		self._is_html5_listener_set = false
		html5.set_interaction_listener(nil)
	end
	self.click_in_row = 1
	self.on_click:trigger(self:get_context(), self.params, self)
	self.style.on_click(self, self.anim_node)
end


function M:_on_button_repeated_click()
	if not self.is_repeated_started then
		self.click_in_row = 0
		self.is_repeated_started = true
	end

	self.click_in_row = self.click_in_row + 1
	self.on_repeated_click:trigger(self:get_context(), self.params, self, self.click_in_row)
	self.style.on_click(self, self.anim_node)
end


function M:_on_button_long_click()
	self.click_in_row = 1
	local time = socket.gettime() - self.last_pressed_time
	self.on_long_click:trigger(self:get_context(), self.params, self, time)
	self.style.on_click(self, self.anim_node)
end


function M:_on_button_double_click()
	self.click_in_row = self.click_in_row + 1
	self.on_double_click:trigger(self:get_context(), self.params, self, self.click_in_row)
	self.style.on_click(self, self.anim_node)
end


---@param press_time number Amount of time the button was held
function M:_on_button_hold(press_time)
	self.on_hold_callback:trigger(self:get_context(), self.params, self, press_time)
end


function M:_on_button_release()
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
		if self.can_action and not self._is_html5_mode then
			self.can_action = false

			local time = socket.gettime()
			local is_long_click = (time - self.last_pressed_time) >= self.style.LONGTAP_TIME
			is_long_click = is_long_click and not self.on_long_click:is_empty()

			local is_double_click = (time - self.last_released_time) < self.style.DOUBLETAP_TIME
			is_double_click = is_double_click and not self.on_double_click:is_empty()

			if is_long_click then
				local is_hold_complete = (time - self.last_pressed_time) >= self.style.AUTOHOLD_TRIGGER
				if is_hold_complete then
					self:_on_button_long_click()
				else
					self.on_click_outside:trigger(self:get_context(), self.params, self)
				end
			elseif is_double_click then
				self:_on_button_double_click()
			else
				self:_on_button_click()
			end

			self.last_released_time = time
		end
		return true
	end
end


return M
