-- Druid helper module for animating GUI nodes
-- @module helper.animate

local M = {}

local PROP_SCALE = gui.PROP_SCALE
local PROP_POSITION = gui.PROP_POSITION
local PROP_COLOR = hash("color")
local PROP_SCALE_X = "scale.x"
local PROP_SCALE_Y = "scale.y"

M.PROP_POS_X = hash("position.x")
M.PROP_POS_Y = hash("position.y")
M.PROP_ALPHA = hash("color.w")

M.TINT_HIDE = vmath.vector4(1, 1, 1, 0)
M.TINT_SHOW = vmath.vector4(1, 1, 1, 1)

M.V3_ONE = vmath.vector3(1, 1, 1)
M.V3_ZERO = vmath.vector3(0, 0, 1)

M.SCALE_ANIMATION_TIME = 0.1
M.BOUNCE_ANIMATION_TIME = 0.25
M.ALPHA_ANIMATION_TIME = 0.25


function M.alpha(self, node, alpha, callback, time, delay, easing, playback)
	time = time or M.ALPHA_ANIMATION_TIME
	delay = delay or 0
	easing = easing or gui.EASING_LINEAR
	playback = playback or gui.PLAYBACK_ONCE_FORWARD
	gui.animate(node, M.PROP_ALPHA, alpha, easing, time, delay,
		function()
			if callback then
				callback(self, node)
			end
		end,
	playback)
end


function M.color(self, node, color, callback, time, delay, easing, playback)
	time = time or M.ALPHA_ANIMATION_TIME
	delay = delay or 0
	easing = easing or gui.EASING_LINEAR
	playback = playback or gui.PLAYBACK_ONCE_FORWARD
	gui.animate(node, PROP_COLOR, color, easing, time, delay,
		function()
			if callback then
				callback(self, node)
			end
		end,
	playback)
end


function M.shake(self, node, callback, str, time)
	str = str or - 30
	time = time or 0.25
	local pos = gui.get_position(node)
	pos.x = pos.x + str
	gui.animate(node, PROP_POSITION, pos, gui.EASING_INELASTIC, time,
		0,
		function()
			if callback then
				callback(self)
			end
		end,
		gui.PLAYBACK_ONCE_BACKWARD
	)
end


function M.bounce(self, node, change_to, callback, time, easing, playback, delaly)
	time = time or M.BOUNCE_ANIMATION_TIME
	delaly = delaly or 0
	easing = easing or gui.EASING_OUTSINE
	playback = playback or gui.PLAYBACK_ONCE_PINGPONG
	gui.animate(node, PROP_SCALE, change_to, easing, time, delaly,
		function()
			if callback then
				callback(self)
			end
		end,
	playback)
end


function M.fly_to(self, node, to_pos, speed, callback, delay, easing)
	easing = easing or gui.EASING_OUTSINE
	delay = delay or 0
	local time = vmath.length(to_pos - gui.get_position(node)) / 100 / speed
	gui.animate(node, gui.PROP_POSITION, to_pos, easing, time, delay,
		function()
			if callback then
				callback(self, node)
			end
	end)
end


function M.fly_by_x(self, node, to_x, time, callback, delay, easing, playback)
	playback = playback or gui.PLAYBACK_ONCE_FORWARD
	easing = easing or gui.EASING_OUTSINE
	delay = delay or 0
	gui.animate(node, M.PROP_POS_X, to_x, easing, time, delay,
		function()
			if callback then
				callback(self, node)
			end
		end,
	playback)
end


function M.fly_by_y(self, node, to_y, time, callback, delay, easing, playback)
	playback = playback or gui.PLAYBACK_ONCE_FORWARD
	easing = easing or gui.EASING_OUTSINE
	delay = delay or 0
	time = time or 0.25
	gui.animate(node, M.PROP_POS_Y, to_y, easing, time, delay,
		function()
			if callback then
				callback(self, node)
			end
		end,
	playback)
end


function M.scale_to(self, node, to, callback, time, delay, easing)
	easing = easing or gui.EASING_INSINE
	time = time or M.SCALE_ANIMATION_TIME
	delay = delay or 0
	time = time or 0.25
	gui.animate(node, PROP_SCALE, to, easing, time, delay,
		function()
			if callback then
				callback(self, node)
			end
		end
	)
end


function M.scale(self, node, to, time)
	gui.animate(node, "scale", to, gui.EASING_OUTSINE, time)
end


function M.scale_x_from_to(self, node, from, to, callback, time, easing, delay, playback)
	easing = easing or gui.EASING_INSINE
	time = time or M.SCALE_ANIMATION_TIME
	delay = delay or 0
	playback = playback or gui.PLAYBACK_ONCE_FORWARD
	local scale = gui.get_scale(node)
	scale.x = from
	gui.set_scale(node, scale)
	gui.animate(node, PROP_SCALE_X, to, easing, time, delay,
		function()
			if callback then
				callback(self)
			end
		end,
		playback
	)
end


function M.scale_y_from_to(self, node, from, to, callback, time, easing, delay, playback)
	easing = easing or gui.EASING_INSINE
	time = time or M.SCALE_ANIMATION_TIME
	delay = delay or 0
	playback = playback or gui.PLAYBACK_ONCE_FORWARD
	local scale = gui.get_scale(node)
	scale.y = from
	gui.set_scale(node, scale)
	gui.animate(node, PROP_SCALE_Y, to, easing, time, delay,
		function()
			if callback then
				callback(self)
			end
		end,
		playback
	)
end


return M