-- Copyright (c) 2021 Maksim Tuprikov <insality@gmail.com>. This code is licensed under MIT license

--- Druid Component for Handling User Click Interactions: Click, Long Click, Double Click, and More.
--
-- <b># Overview #</b>
--
-- This component provides a versatile solution for handling user click interactions.
-- It allows you to make any GUI node clickable and define various callbacks for different types of clicks.
--
-- <b># Notes #</b>
--
-- • The click callback will not trigger if the cursor moves outside the node's
-- area between the pressed and released states.
--
-- • If a button has a double click event subscriber and the double click event is triggered,
-- the regular click callback will not be triggered.
--
-- • Buttons can be triggered using a keyboard key by calling the button:set_key_trigger method.
--
-- • To animate a small icon on a big button panel, you can use an animation node.
-- The trigger node name should be set as "big panel," and the animation node should be set as "small icon."
--
-- <a href="https://insality.github.io/druid/druid/index.html?example=general_buttons" target="_blank"><b>Example Link</b></a>
-- @usage
-- local function on_button_click(self, args, button)
--     print("Button has clicked with params: " .. args)
--     print("Also the button component is passed in callback params")
-- end
--
-- local custom_args = "Any variable to pass inside callback"
-- local button = self.druid:new_button("button_name", on_button_click, custom_args)
--
-- @module Button
-- @within BaseComponent
-- @alias druid.button


--- The event: Event on successful release action over button.
-- @usage
-- -- Custom args passed in Button constructor
-- button.on_click:subscribe(function(self, custom_args, button_instance)
--     print("On button click!")
-- end)
-- @tfield event on_click event


--- The event: Event on repeated action over button.
--
-- This callback will be triggered if user hold the button. The repeat rate pick from `input.repeat_interval` in game.project
-- @usage
-- -- Custom args passed in Button constructor
-- button.on_repeated_click:subscribe(function(self, custom_args, button_instance, click_count)
--     print("On repeated Button click!")
-- end)
-- @tfield event on_repeated_click event


--- The event: Event on long tap action over button.
--
-- This callback will be triggered if user pressed the button and hold the some amount of time.
-- The amount of time picked from button style param: LONGTAP_TIME
-- @usage
-- -- Custom args passed in Button constructor
-- button.on_long_click:subscribe(function(self, custom_args, button_instance, hold_time)
--     print("On long Button click!")
-- end)
-- @tfield event on_long_click event


--- The event: Event on double tap action over button.
--
-- If secondary click was too fast after previous one, the double
-- click will be called instead usual click (if on_double_click subscriber exists)
-- @usage
-- -- Custom args passed in Button constructor
-- button.on_double_click:subscribe(function(self, custom_args, button_instance, click_amount)
--     print("On double Button click!")
-- end)
-- @tfield event on_double_click event


--- The event: Event calls every frame before on_long_click event.
--
-- If long_click subscriber exists, the on_hold_callback will be called before long_click trigger.
--
-- Usecase: Animate button progress of long tap
-- @usage
-- -- Custom args passed in Button constructor
-- button.on_double_click:subscribe(function(self, custom_args, button_instance, time)
--     print("On hold Button callback!")
-- end)
-- @tfield event on_hold_callback event


--- The event: Event calls if click event was outside of button.
--
-- This event will be triggered for each button what was not clicked on user click action
--
-- Usecase: Hide the popup when click outside
-- @usage
-- -- Custom args passed in Button constructor
-- button.on_click_outside:subscribe(function(self, custom_args, button_instance)
--     print("On click Button outside!")
-- end)
-- @tfield event on_click_outside event


--- The event: Event triggered if button was pressed by user.
-- @usage
-- -- Custom args passed in Button constructor
-- button.on_pressed:subscribe(function(self, custom_args, button_instance)
--     print("On Button pressed!")
-- end)
-- @tfield event on_pressed event

--- Button trigger node
-- @tfield node node

---The GUI node id from button node
-- @tfield hash node_id

--- Button animation node.
-- In default case equals to clickable node.
--
-- Usecase: You have the big clickable panel, but want to animate only one small icon on it.
-- @tfield node|nil anim_node Default node

---Custom args for any Button event. Setup in Button constructor
-- @tfield any params

--- The Hover: Button Hover component
-- @tfield Hover hover Hover

--- Additional button click area, defined by another GUI node
-- @tfield node|nil click_zone

---

local event = require("event.event")
local const = require("druid.const")
local helper = require("druid.helper")
local component = require("druid.component")

---@class druid.button: druid.base_component
---@field on_click event
---@field on_pressed event
---@field on_repeated_click event
---@field on_long_click event
---@field on_double_click event
---@field on_hold_callback event
---@field on_click_outside event
---@field node node
---@field node_id hash
---@field anim_node node
---@field params any
---@field hover druid.hover
---@field click_zone node
---@field start_scale vector3
---@field start_pos vector3
---@field disabled boolean
---@field key_trigger hash
---@field style table
local M = component.create("button")


local function is_input_match(self, action_id)
	if action_id == const.ACTION_TOUCH or action_id == const.ACTION_MULTITOUCH then
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
	if self._is_html5_mode then
		self._is_html5_listener_set = false
		html5.set_interaction_listener(nil)
	end
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


---@param self druid.button
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
					on_button_long_click(self)
				else
					self.on_click_outside:trigger(self:get_context(), self.params, self)
				end
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
---You can override this component styles params in Druid styles table
---or create your own style
---@class druid.button.style
---@field LONGTAP_TIME number|nil Minimum time to trigger on_hold_callback. Default: 0.4
---@field AUTOHOLD_TRIGGER number|nil Maximum hold time to trigger button release while holding. Default: 0.8
---@field DOUBLETAP_TIME number|nil Time between double taps. Default: 0.4
---@field on_click fun(self, node)|nil
---@field on_click_disabled fun(self, node)|nil
---@field on_hover fun(self, node, hover_state)|nil
---@field on_mouse_hover fun(self, node, hover_state)|nil
---@field on_set_enabled fun(self, node, enabled_state)|nil

---@param style druid.button.style
function M:on_style_change(style)
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


---Button constructor
---@param node_or_node_id node|string Node name or GUI Node itself.
---@param callback fun()|nil Callback on button click
---@param custom_args any|nil Custom args for any Button event
---@param anim_node node|string|nil Node to animate instead of trigger node.
function M:init(node_or_node_id, callback, custom_args, anim_node)
	self.druid = self:get_druid()
	self.node = self:get_node(node_or_node_id)
	self.node_id = gui.get_id(self.node)

	self.anim_node = anim_node and self:get_node(anim_node) or self.node
	self.start_scale = gui.get_scale(self.anim_node)
	self.start_pos = gui.get_position(self.anim_node)
	self.params = custom_args
	self.hover = self.druid:new_hover(node_or_node_id, on_button_hover)
	self.hover.on_mouse_hover:subscribe(on_button_mouse_hover)
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


function M:on_late_init()
	if not self.click_zone then
		local stencil_node = helper.get_closest_stencil_node(self.node)
		if stencil_node then
			self:set_click_zone(stencil_node)
		end
	end
end


function M:on_input(action_id, action)
	if not is_input_match(self, action_id) then
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
				on_button_click(self)
			end)
		end
		return is_consume
	end

	-- While hold button, repeat rate pick from input.repeat_interval
	if action.repeated then
		if not self.on_repeated_click:is_empty() and self.can_action then
			on_button_repeated_click(self)
			return is_consume
		end
	end

	if action.released then
		return on_button_release(self) and is_consume
	end

	if self.can_action and not self.on_long_click:is_empty() then
		local press_time = socket.gettime() - self.last_pressed_time

		if self.style.AUTOHOLD_TRIGGER <= press_time then
			on_button_release(self)
			return is_consume
		end

		if press_time >= self.style.LONGTAP_TIME then
			on_button_hold(self, press_time)
			return is_consume
		end
	end

	return not self.disabled and is_consume
end


function M:on_input_interrupt()
	self.can_action = false
	self.hover:set_hover(false)
	self.hover:set_mouse_hover(false)
end


--- Set button enabled state.
-- The style.on_set_enabled will be triggered.
-- Disabled button is not clickable.
---@param state boolean|nil Enabled state
---@return druid.button self
function M:set_enabled(state)
	self.disabled = not state
	self.hover:set_enabled(state)
	self.style.on_set_enabled(self, self.node, state)

	return self
end


--- Get button enabled state.
--
-- By default all Buttons is enabled on creating.
---@return boolean @True, if button is enabled now, False overwise
function M:is_enabled()
	return not self.disabled
end


--- Set additional button click area.
-- Useful to restrict click outside out stencil node or scrollable content.
--
-- This functions calls automatically if you don't disable it in game.project: druid.no_stencil_check
---@param zone node|string|nil Gui node
---@return druid.button self
function M:set_click_zone(zone)
	self.click_zone = self:get_node(zone)
	self.hover:set_click_zone(zone)

	return self
end


---Set key name to trigger this button by keyboard.
---@param key hash|string The action_id of the input key. Example: "key_space"
---@return druid.button self
function M:set_key_trigger(key)
	self.key_trigger = hash(key)

	return self
end


--- Get current key name to trigger this button.
---@return hash key_trigger The action_id of the input key
function M:get_key_trigger()
	return self.key_trigger
end


--- Set function for additional check for button click availability
---@param check_function function|nil Should return true or false. If true - button can be pressed.
---@param failure_callback function|nil Function will be called on button click, if check function return false
---@return druid.button self
function M:set_check_function(check_function, failure_callback)
	self._check_function = check_function
	self._failure_callback = failure_callback
end


--- Set Button mode to work inside user HTML5 interaction event.
--
-- It's required to make protected things like copy & paste text, show mobile keyboard, etc
-- The HTML5 button's doesn't call any events except on_click event.
--
-- If the game is not HTML, html mode will be not enabled
---@param is_web_mode boolean|nil If true - button will be called inside html5 callback
---@return druid.button self
function M:set_web_user_interaction(is_web_mode)
	self._is_html5_mode = not not (is_web_mode and html5)
	return self
end


return M
