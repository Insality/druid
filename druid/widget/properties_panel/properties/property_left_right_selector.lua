local event = require("event.event")

---@class widget.property_left_right_selector: druid.widget
---@field root node
---@field druid druid_instance
---@field text_name druid.text
---@field button druid.button
---@field selected node
---@field value string|number
---@field on_change_value event fun(value: string|number)
local M = {}


function M:init()
	self.root = self:get_node("root")
	self.selected = self:get_node("selected")
	gui.set_alpha(self.selected, 0)

	self.text_name = self.druid:new_text("text_name")
		:set_text_adjust("scale_then_trim", 0.3)

	self.text_value = self.druid:new_text("text_value")
	self.button_left = self.druid:new_button("button_left", self.on_button_left)
	self.button_left.on_repeated_click:subscribe(self.on_button_left, self)

	self.button_right = self.druid:new_button("button_right", self.on_button_right)
	self.button_right.on_repeated_click:subscribe(self.on_button_right, self)

	self.on_change_value = event.create()

	self.container = self.druid:new_container(self.root)
	self.container:add_container("text_name")
	self.container:add_container("E_Anchor")
end


function M:set_text(text)
	self.text_name:set_text(text)
	return self
end


---Helper to cycle number in range
---@param value number Current value
---@param min number Min range value
---@param max number Max range value
---@param step number Step size
---@param is_loop boolean Is looped
---@return number Cycled value
local function step_number(value, min, max, step, is_loop)
	local range = max - min + 1
	if is_loop then
		-- Normalize step within range
		local effective_step = step
		if math.abs(step) >= range then
			effective_step = step % range
			if effective_step == 0 then
				effective_step = step > 0 and range or -range
			end
		end

		value = value + effective_step
		-- Handle wrapping
		if max then
			while value > max do
				value = min + (value - max - 1)
			end
		end
		if min then
			while value < min do
				value = max - (min - value - 1)
			end
		end
	else
		-- Clamp values
		value = value + step
		if max and value > max then
			return max
		elseif min and value < min then
			return min
		end
	end
	return value
end


---Helper to cycle array index with proper step wrapping
---@param array table Array to cycle through
---@param current_value any Current value to find index for
---@param step number Step direction
---@param is_loop boolean If true, cycle values. If false, clamp at ends
---@return any Next value in cycle
local function step_array(array, current_value, step, is_loop)
	local index = 1
	for i, v in ipairs(array) do
		if v == current_value then
			index = i
			break
		end
	end

	if is_loop then
		-- Normalize step within array length
		local range = #array
		local effective_step = step
		if math.abs(step) >= range then
			effective_step = step % range
			if effective_step == 0 then
				effective_step = step > 0 and range or -range
			end
		end

		index = index + effective_step
		-- Handle wrapping
		while index > range do
			index = 1 + (index - range - 1)
		end
		while index < 1 do
			index = range - (1 - index - 1)
		end
	else
		-- Clamp values
		index = index + step
		if index > #array then
			index = #array
		elseif index < 1 then
			index = 1
		end
	end

	return array[index]
end


function M:on_button_left()
	self:add_step(-1)
end

function M:on_button_right()
	self:add_step(1)
end


---@param koef number -1 0 1, on 0 will not move
function M:add_step(koef)
	local array_type = self.array_type
	if array_type then
		local value = self.value
		local new_value = step_array(array_type.array, value, koef * array_type.steps, array_type.is_loop)
		self:set_value(new_value)
		return
	end


	local number_type = self.number_type
	if number_type then
		local value = tonumber(self.value) --[[@as number]]
		local new_value = step_number(value, number_type.min, number_type.max, koef * number_type.steps, number_type.is_loop)
		self:set_value(new_value)
		return
	end
end


function M:set_number_type(min, max, is_loop, steps)
	self.number_type = {
		min = min,
		max = max,
		steps = steps or 1,
		is_loop = is_loop,
	}

	return self
end


function M:set_array_type(array, is_loop, steps)
	self.array_type = {
		array = array,
		steps = steps or 1,
		is_loop = is_loop,
	}

	return self
end


---@param value string|number
function M:set_value(value, is_instant)
	if self.value == value then
		return
	end

	self.value = value
	self.text_value:set_text(tostring(value))
	self.on_change_value:trigger(value)

	if not is_instant then
		gui.set_alpha(self.selected, 1)
		gui.animate(self.selected, "color.w", 0, gui.EASING_INSINE, 0.16)
	end
end


---@return string|number
function M:get_value()
	return self.value
end


return M
