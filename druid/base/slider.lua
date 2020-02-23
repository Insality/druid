--- Druid slider component
-- @module druid.slider

local helper = require("druid.helper")
local const = require("druid.const")
local component = require("druid.component")

local M = component.create("slider", { const.ON_INPUT_HIGH })


local function on_change_value(self)
	if self.callback then
		self.callback(self:get_context(), self.value)
	end
end


function M.init(self, node, end_pos, callback)
	self.node = self:get_node(node)

	self.start_pos = gui.get_position(self.node)
	self.pos = gui.get_position(self.node)
	self.target_pos = self.pos
	self.end_pos = end_pos

	self.dist = self.end_pos - self.start_pos
	self.is_drag = false
	self.value = 0
	self.callback = callback

	assert(self.dist.x == 0 or self.dist.y == 0, "Slider for now can be only vertical or horizontal")
end


function M.on_input(self, action_id, action)
	if action_id ~= const.ACTION_TOUCH then
		return false
	end

	if gui.pick_node(self.node, action.x, action.y) then
		if action.pressed then
			self.pos = gui.get_position(self.node)
			self.is_drag = true
		end
	end

	if self.is_drag and not action.pressed then
		-- move
		self.pos.x = self.pos.x + action.dx
		self.pos.y = self.pos.y + action.dy

		local prev_x = self.target_pos.x
		local prev_y = self.target_pos.y

		self.target_pos.x = helper.clamp(self.pos.x, self.start_pos.x, self.end_pos.x)
		self.target_pos.y = helper.clamp(self.pos.y, self.start_pos.y, self.end_pos.y)

		gui.set_position(self.node, self.target_pos)

		if prev_x ~= self.target_pos.x or prev_y ~= self.target_pos.y then

			if self.dist.x > 0 then
				self.value = (self.target_pos.x - self.start_pos.x) / self.dist.x
			end

			if self.dist.y > 0 then
				self.value = (self.target_pos.y - self.start_pos.y) / self.dist.y
			end

			on_change_value(self)
		end
	end

	if action.released then
		self.is_drag = false
	end

	return self.is_drag
end


function M.set(self, value)
	value = helper.clamp(value, 0, 1)

	gui.set_position(self.node, self.start_pos + self.dist * value)
	self.value = value
	on_change_value(self)
end


return M
