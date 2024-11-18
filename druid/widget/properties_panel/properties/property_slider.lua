---@class property_slider: druid.widget
---@field root node
---@field container druid.container
---@field druid druid_instance
---@field text_name druid.lang_text
---@field text_value druid.text
---@field slider druid.slider
local M = {}


---@param template string
---@param nodes table<hash, node>
function M:init(template, nodes)
	self.druid = self:get_druid(template, nodes)

	self.root = self:get_node("root")
	self.selected = self:get_node("selected")
	gui.set_alpha(self.selected, 0)
	self._value = 0

	self.text_name = self.druid:new_lang_text("text_name") --[[@as druid.lang_text]]
	self.text_value = self.druid:new_text("text_value")
	self.slider = self.druid:new_slider("slider_pin", vmath.vector3(55, 0, 0), self._on_slider_change_by_user) --[[@as druid.slider]]
	self.slider:set_input_node("slider")

	self:set_text_function(function(value)
		return math.floor(value * 100) .. "%"
	end)

	self.container = self.druid:new_container(self.root)
	self.container:add_container("text_name")
	self.container:add_container("E_Anchor")
end


---@param callback fun(value:number):string
function M:set_text_function(callback)
	self._text_function = callback
	self.text_value:set_to(self._text_function(self._value))
end


---@param value number
function M:set_value(value, is_instant)
	if self._value == value then
		return
	end

	self._value = value
	self.slider:set(value, true)
	self.text_value:set_to(self._text_function(value))

	if not is_instant then
		gui.set_alpha(self.selected, 1)
		gui.animate(self.selected, "color.w", 0, gui.EASING_INSINE, 0.16)
	end
end


---@return number
function M:get_value()
	return self._value
end


function M:_on_slider_change_by_user(value)
	self._value = value
	self.text_value:set_to(self._text_function(value))

	gui.set_alpha(self.selected, 1)
	gui.animate(self.selected, "color.w", 0, gui.EASING_INSINE, 0.16)
end


return M
