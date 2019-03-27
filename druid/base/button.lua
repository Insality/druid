local data = require("druid.data")
local ui_animate = require "druid.helper.druid_animate"
local settings = require("druid.settings")
local b_settings = settings.button

local M = {}

M.interest = {
	data.ON_INPUT
}

M.DEFAULT_DEACTIVATE_COLOR = vmath.vector4(0, 0, 0, 0)
M.DEFAULT_DEACTIVATE_SCALE = vmath.vector3(0.8, 0.9, 1)
M.DEFAULT_ACTIVATE_SCALE = vmath.vector3(1, 1, 1)
M.DEFAUL_ACTIVATION_TIME = 0.2


function M.init(instance, callback, params, animate_node_name, event)
	instance.event = data.A_TOUCH
	instance.anim_node = animate_node_name and gui.get_node(animate_node_name) or instance.node
	instance.scale_from = gui.get_scale(instance.anim_node)
	instance.scale_to = instance.scale_from + b_settings.SCALE_CHANGE
	instance.scale_hover_to = instance.scale_from + b_settings.HOVER_SCALE
	instance.pos = gui.get_position(instance.anim_node)
	instance.callback = callback
	instance.params = params
	instance.tap_anim = M.tap_scale_animation
	instance.back_anim = M.back_scale_animation
	instance.hover_anim = b_settings.IS_HOVER
	-- instance.sound = sound or BTN_SOUND
	-- instance.sound_disable = sound_disable or BTN_SOUND_DISABLED
end


local function set_hover(instance, state)
	if instance.hover_anim and instance._is_hovered ~= state then
		local target_scale = state and instance.scale_hover_to or instance.scale_from
		ui_animate.scale(instance, instance.node, target_scale, b_settings.HOVER_TIME)
		instance._is_hovered = state
	end
end

local function on_button_release(instance)
	if not instance.disabled then
		if not instance.stub and instance.can_action then
			instance.can_action = false
			instance.tap_anim(instance)
			-- instance.sound()
			instance.callback(instance.parent.parent, instance.params, instance)
		else
			set_hover(instance, false)
		end
		return true
	else
		instance.sound_disable()
		return false
	end
end


--- Set text to text field
-- @param action_id - input action id
-- @param action - input action
function M.on_input(instance, action_id, action)
	if gui.pick_node(instance.node, action.x, action.y) then
		if action.pressed then
			-- Can interact if start touch on the button
			instance.can_action = true
			return true
		end

		if action.released then
			return on_button_release(instance)
		else
			set_hover(instance, true)
		end
		return not instance.disabled
	else
		-- Can't interact, if touch outside of button
		instance.can_action = false
		set_hover(instance, false)
		return false
	end
end

function M.tap_scale_animation(instance)
	ui_animate.scale_to(instance, instance.anim_node, instance.scale_to,
		function()
			if instance.back_anim then
				instance.back_anim(instance)
			end
			-- instance.sound()
		end
	)
end


function M.back_scale_animation(instance)
	ui_animate.scale_to(instance, instance.anim_node, instance.scale_from)
end


function M.deactivate(instance, is_animate, callback)
	instance.disabled = true
	if is_animate then
		local counter = 0
		local clbk = function()
			counter = counter + 1
			if counter == 3 and callback then
				callback(instance.parent.parent)
			end
		end
		ui_animate.color(instance, instance.node, M.DEFAULT_DEACTIVATE_COLOR, clbk, M.DEFAUL_ACTIVATION_TIME, 0,
		gui.EASING_OUTBOUNCE)
		ui_animate.scale_y_from_to(instance, instance.node, M.DEFAULT_ACTIVATE_SCALE.x, M.DEFAULT_DEACTIVATE_SCALE.x, clbk,
		M.DEFAUL_ACTIVATION_TIME, gui.EASING_OUTBOUNCE)
		ui_animate.scale_x_from_to(instance, instance.node, M.DEFAULT_ACTIVATE_SCALE.y, M.DEFAULT_DEACTIVATE_SCALE.y, clbk,
		M.DEFAUL_ACTIVATION_TIME, gui.EASING_OUTBOUNCE)
	else
		gui.set_color(instance.node, M.DEFAULT_DEACTIVATE_COLOR)
		gui.set_scale(instance.node, M.DEFAULT_DEACTIVATE_SCALE)
		if callback then
			callback(instance.parent.parent)
		end
	end
end


function M.activate(instance, is_animate, callback)
	if is_animate then
		local counter = 0
		local clbk = function()
			counter = counter + 1
			if counter == 3 then
				instance.disabled = false
				if callback then
					callback(instance.parent.parent)
				end
			end
		end
		ui_animate.color(instance, instance.node, ui_animate.TINT_SHOW, clbk, M.DEFAUL_ACTIVATION_TIME, 0,
		gui.EASING_OUTBOUNCE)
		ui_animate.scale_y_from_to(instance, instance.node, M.DEFAULT_DEACTIVATE_SCALE.x, M.DEFAULT_ACTIVATE_SCALE.x, clbk,
		M.DEFAUL_ACTIVATION_TIME, gui.EASING_OUTBOUNCE)
		ui_animate.scale_x_from_to(instance, instance.node, M.DEFAULT_DEACTIVATE_SCALE.y, M.DEFAULT_ACTIVATE_SCALE.y, clbk,
		M.DEFAUL_ACTIVATION_TIME, gui.EASING_OUTBOUNCE)
	else
		gui.set_color(instance.node, ui_animate.TINT_SHOW)
		gui.set_scale(instance.node, M.DEFAULT_ACTIVATE_SCALE)
		instance.disabled = false
		if callback then
			callback(instance.parent.parent)
		end
	end
end

return M
