local event = require("event.event")
local helper = require("druid.helper")

---@class druid.widget.property_slider: druid.widget
---@field root node
---@field container druid.container
---@field druid druid.instance
---@field text_name druid.text
---@field text_value druid.text
---@field slider druid.slider
---@field on_change_value event fun(value:number)
local M = {}


function M:init()
	self.root = self:get_node("root")
	self.selected = self:get_node("selected")
	gui.set_alpha(self.selected, 0)
	self._value = 0

	self.min = 0
	self.max = 1
	self.step = 0.01

	self.text_name = self.druid:new_text("text_name")
		:set_text_adjust("scale_then_trim", 0.3)

	self.text_value = self.druid:new_text("text_value")
	self.slider = self.druid:new_slider("slider_pin", vmath.vector3(55, 0, 0), self.update_value) --[[@as druid.slider]]
	self.slider:set_input_node("slider")

	self:set_text_function(function(value)
		return math.floor(value * 100) .. "%"
	end)

	self.container = self.druid:new_container(self.root)
	self.container:add_container("text_name")
	self.container:add_container("E_Anchor")

	self.on_change_value = event.create()
end


---@param callback fun(value:number):string
function M:set_text_function(callback)
	self._text_function = callback
	self.text_value:set_text(self._text_function(self._value))
end


---Sets the text property of the slider
---@param text string
function M:set_text_property(text)
	self.text_name:set_text(text)
end


---Sets the callback function for when the slider value changes
---@param callback fun(value:number)
function M:on_change(callback)
	self.on_change_value:subscribe(callback)
end


---@param value number
function M:set_value(value, is_instant)
	local diff = math.abs(self.max - self.min)
	self.slider:set((value - self.min) / diff, true)

	local is_changed = self._value ~= value
	if not is_changed then
		return
	end

	self._value = value
	self.text_value:set_text(self._text_function(value))
	self.on_change_value:trigger(value)

	if not is_instant then
		gui.set_alpha(self.selected, 1)
		gui.animate(self.selected, "color.w", 0, gui.EASING_INSINE, 0.16)
	end
end


---@return number
function M:get_value()
	return self._value
end


function M:update_value(value)
	local current_value = self._value

	local diff = math.abs(self.max - self.min)
	-- [0..1] To range
	value = value * diff + self.min

	-- Round to steps value (0.1, or 5. Should be divided on this value)
	value = math.floor(value / self.step + 0.5) * self.step

	value = helper.clamp(value, self.min, self.max)

	self:set_value(value)
end


function M:set_number_type(min, max, step)
	self.min = min or 0
	self.max = max or 1
	self.step = step

	self:set_text_function(function(value)
		return tostring(value)
	end)

	self:set_value(self._value, true)
end


function M:_on_slider_change_by_user(value)
	self:set_value(value)
end


return M
