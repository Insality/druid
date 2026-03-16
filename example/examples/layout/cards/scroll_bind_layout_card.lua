local event = require("event.event")

---@class widget.scroll_bind_layout_card: druid.widget
---@field root node
local M = {}

local SIZES = {
	300,
	400,
	500,
}


function M:init()
	self.root = self:get_node("root")
	self.button = self.druid:new_button("button_text/root", self.button_click)
	self.text_header = self.druid:new_text("text_header")
	self.text_description = self.druid:new_text("text_description")
	self.scale = gui.get_scale(self.root)

	self.on_select = event.create()

	local random_size = SIZES[math.random(1, 3)]
	gui.set(self.root, "size.x", random_size)
	gui.set(self:get_node("panel"), "size.x", random_size)

end


function M:set_level(level)
	self.level = level
	self.text_header:set_text("Level " .. level)
	self.text_description:set_text("The level " .. level .. ", play and conquire!")
end


function M:button_click()
	self.on_select:trigger(self.level)
end


function M:get_distance(position)
	return self._distance
end


function M:set_on_scroll_position(position)
	local visible_area = 250
	local fade_area = 400

	self._distance = math.abs(gui.get_position(self.root).x + position.x)

	if self._distance < visible_area then
		gui.set_alpha(self.root, 1)
		self:_set_scale(1.1)
		self.button:set_input_enabled(true)
	elseif self._distance < visible_area + fade_area then
		local progress = (self._distance - visible_area) / fade_area
		gui.set_alpha(self.root, 1 - progress)
		self:_set_scale(0.9 + (1 - 0.8) * (1 - progress))

		self.button:set_input_enabled(false)
	else
		gui.set_alpha(self.root, 0)
		gui.set_scale(self.root, vmath.vector3(1, 1, 1))
		self.button:set_input_enabled(false)
	end
end


---@private
---@param scale number
function M:_set_scale(scale)
	self.scale.x = scale
	self.scale.y = scale
	gui.set_scale(self.root, self.scale)
end


return M
