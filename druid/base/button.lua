--- Component to handle basic GUI button
-- @module base.button

-- TODO: Add button mode:
-- Long tap
-- Repeated tap

local data = require("druid.data")
local ui_animate = require("druid.helper.druid_animate")
local settings = require("druid.settings")
local helper = require("druid.helper")
local b_settings = settings.button

local M = {}
M.interest = {
	data.ON_INPUT
}

M.DEFAULT_DEACTIVATE_COLOR = vmath.vector4(0, 0, 0, 0)
M.DEFAULT_DEACTIVATE_SCALE = vmath.vector3(0.8, 0.9, 1)
M.DEFAULT_ACTIVATE_SCALE = vmath.vector3(1, 1, 1)
M.DEFAULT_ACTIVATION_TIME = 0.2


function M.init(self, node, callback, params, anim_node, event)
	self.node = helper.get_node(node)
	self.event = data.ACTION_TOUCH
	self.anim_node = anim_node and helper.get_node(anim_node) or self.node
	self.scale_from = gui.get_scale(self.anim_node)
	self.scale_to = self.scale_from + b_settings.SCALE_CHANGE
	self.scale_hover_to = self.scale_from + b_settings.HOVER_SCALE
	self.pos = gui.get_position(self.anim_node)
	self.callback = callback
	self.params = params
	self.tap_anim = M.tap_scale_animation
	self.back_anim = M.back_scale_animation
	self.hover_anim = b_settings.IS_HOVER
	self.sound = b_settings.BTN_SOUND
	self.sound_disable = b_settings.BTN_SOUND_DISABLED
	self.click_zone = nil

	-- TODO: to separate component "block_input"?
	-- If callback is nil, so the buttons is stub and without anim
	-- Used for zones, what should dont pass the input to other UI elements
	if not callback then
		self.stub = true
		self.hover_anim = false
		self.callback = function() end
	end
end


local function set_hover(self, state)
	if self.hover_anim and self._is_hovered ~= state then
		local target_scale = state and self.scale_hover_to or self.scale_from
		ui_animate.scale(self, self.anim_node, target_scale, b_settings.HOVER_TIME)
		self._is_hovered = state
	end
end


local function on_button_release(self)
	if not self.disabled then
		if not self.stub and self.can_action then
			self.can_action = false
			if self.tap_anim then
				self.tap_anim(self)
			end
			self.callback(self.parent.parent, self.params, self)
			settings.play_sound(self.sound)
		else
			set_hover(self, false)
		end
		return true
	else
		settings.play_sound(self.sound_disable)
		return false
	end
end


--- Set text to text field
-- @param action_id - input action id
-- @param action - input action
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


function M.tap_scale_animation(self)
	ui_animate.scale_to(self, self.anim_node, self.scale_to,
		function()
			if self.back_anim then
				self.back_anim(self)
			end
		end
	)
end


function M.back_scale_animation(self)
	ui_animate.scale_to(self, self.anim_node, self.scale_from)
end


function M.deactivate(self, is_animate, callback)
	self.disabled = true
	if is_animate then
		-- callback call three times in gui.animation
		local clbk = helper.after(3, function()
			if callback then
				callback(self.parent.parent)
			end
		end)

		ui_animate.color(self, self.node, M.DEFAULT_DEACTIVATE_COLOR,
			clbk, M.DEFAULT_ACTIVATION_TIME, 0, gui.EASING_OUTBOUNCE)

		ui_animate.scale_y_from_to(self, self.node, M.DEFAULT_ACTIVATE_SCALE.x,
			M.DEFAULT_DEACTIVATE_SCALE.x, clbk, M.DEFAULT_ACTIVATION_TIME, gui.EASING_OUTBOUNCE)

		ui_animate.scale_x_from_to(self, self.node, M.DEFAULT_ACTIVATE_SCALE.y,
			M.DEFAULT_DEACTIVATE_SCALE.y, clbk, M.DEFAULT_ACTIVATION_TIME, gui.EASING_OUTBOUNCE)
	else
		gui.set_color(self.node, M.DEFAULT_DEACTIVATE_COLOR)
		gui.set_scale(self.node, M.DEFAULT_DEACTIVATE_SCALE)
		if callback then
			callback(self.parent.parent)
		end
	end
end


function M.activate(self, is_animate, callback)
	if is_animate then
		-- callback call three times in gui.animation
		local clbk = helper.after(3, function()
				self.disabled = false
				if callback then
					callback(self.parent.parent)
				end
		end)

		ui_animate.color(self, self.node, ui_animate.TINT_SHOW,
			clbk, M.DEFAULT_ACTIVATION_TIME, 0, gui.EASING_OUTBOUNCE)

		ui_animate.scale_y_from_to(self, self.node, M.DEFAULT_DEACTIVATE_SCALE.x,
			M.DEFAULT_ACTIVATE_SCALE.x, clbk, M.DEFAULT_ACTIVATION_TIME, gui.EASING_OUTBOUNCE)

		ui_animate.scale_x_from_to(self, self.node, M.DEFAULT_DEACTIVATE_SCALE.y,
			M.DEFAULT_ACTIVATE_SCALE.y, clbk, M.DEFAULT_ACTIVATION_TIME, gui.EASING_OUTBOUNCE)
	else
		gui.set_color(self.node, ui_animate.TINT_SHOW)
		gui.set_scale(self.node, M.DEFAULT_ACTIVATE_SCALE)
		self.disabled = false
		if callback then
			callback(self.parent.parent)
		end
	end
end


function M.disable_animation(self)
	self.hover_anim = false
	self.tap_anim = nil
	self.back_anim = nil
end


--- Set additional node, what need to be clicked on button click
-- Used, if need setup, what button can be clicked only in special zone
function M.set_click_zone(self, zone)
	self.click_zone = helper.get_node(zone)
end


return M
