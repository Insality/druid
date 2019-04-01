local data = require("druid.data")
local helper = require("druid.helper.helper")

local M = {}

M.interest = {
	data.LAYOUT_CHANGED,
	data.ON_UPDATE,
}

local LERP_KOEF = 0.2
local LERP_DELTA = 0.005

local PROP_X = "x"
local PROP_Y = "y"

function M.init(instance, name, key, init_value)
	instance.prop = hash("scale."..key)
	instance.key = key

	instance.node = gui.get_node(name)
	instance.scale = gui.get_scale(instance.node)
	instance.size = gui.get_size(instance.node)
	instance.max_size = instance.size[instance.key]
	instance.slice = gui.get_slice9(instance.node)
	if key == PROP_X then
		instance.slice_size = instance.slice.x + instance.slice.z
	else
		instance.slice_size = instance.slice.y + instance.slice.w
	end

	instance:set_to(init_value or 1)
end


local function check_steps(instance, from, to, exactly)
	if not instance.steps then
		return
	end

	for i = 1, #instance.steps do
		local step = instance.steps[i]
		local v1, v2 = from, to
		if v1 > v2 then
			v1, v2 = v2, v1
		end

		if v1 < step and step < v2 then
			instance.step_callback(instance.parent.parent, step)
		end
		if exactly and exactly == step then
			instance.step_callback(instance.parent.parent, step)
		end
	end
end


local function set_bar_to(instance, set_to, is_silence)
	local prev_value = instance.last_value
	instance.last_value = set_to

	local total_width = set_to * instance.max_size

	local scale = math.min(total_width / instance.slice_size, 1)
	local size = math.max(total_width, instance.slice_size)

	instance.scale[instance.key] = scale
	gui.set_scale(instance.node, instance.scale)
	instance.size[instance.key] = size
	gui.set_size(instance.node, instance.size)

	if not is_silence then
		check_steps(instance, prev_value, set_to)
	end
end


--- Fill a progress bar and stop progress animation
function M.fill(instance)
	set_bar_to(instance, 1, true)
end


--- To empty a progress bar
function M.empty(instance)
	set_bar_to(instance, 0, true)
end


--- Set fill a progress bar to value
-- @param to - value between 0..1
function M.set_to(instance, to)
	set_bar_to(instance, to)
end


function M.get(instance)
	return instance.last_value
end


function M.set_steps(instance, steps, step_callback)
	instance.steps = steps
	instance.step_callback = step_callback
end


--- Start animation of a progress bar
-- @param to - value between 0..1
-- @param callback - callback when progress ended if need
function M.to(instance, to, callback)
	to = helper.clamp(to, 0, 1)
	-- cause of float error
	local value = helper.round(to, 5)
	if value ~= instance.last_value then
		instance.target = value
		instance.target_callback = callback
	else
		if callback then
			callback(instance.parent.parent, to)
		end
	end
end


--- Called when layout updated (rotate for example)
function M.on_layout_updated(instance)
	instance:set_to(instance.last_value)
end


function M.update(instance, dt)
	if instance.target then
		local prev_value = instance.last_value
		local step = math.abs(instance.last_value - instance.target) * LERP_KOEF
		step = math.max(step, LERP_DELTA)
		instance:set_to(helper.step(instance.last_value, instance.target, step))

		if instance.last_value == instance.target then
			check_steps(instance, prev_value, instance.target, instance.target)

			if instance.target_callback then
				instance.target_callback(instance.parent.parent, instance.target)
			end

			instance.target = nil
		end
	end
end


return M