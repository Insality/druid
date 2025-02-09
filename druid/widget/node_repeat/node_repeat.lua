local helper = require("druid.helper")
local event_queue = require("druid.event_queue")

---@class druid.node_repeat: druid.widget
---@field animation table
---@field node node
---@field params vector4
---@field time number
local M = {}

function M:init(node)
	self.node = self:get_node(node)
	self.animation = nil
	gui.set_material(self.node, hash("gui_repeat"))
	self.time = 0
	self.margin = 0

	self.params = gui.get(self.node, "params") --[[@as vector4]]
	self:get_atlas_path(function(atlas_path)
		self.is_inited = self:init_tiling_animation(atlas_path)
		local repeat_x, repeat_y = self:get_repeat()
		self:animate(repeat_x, repeat_y)
	end)

	--self.druid.events.on_node_property_changed:subscribe(self.on_node_property_changed, self)
end


function M:on_node_property_changed(node, property)
	if not self.is_inited or node ~= self.node then
		return
	end

	if property == "size" or property == "scale" then
		local repeat_x, repeat_y = self:get_repeat()
		self:set_repeat(repeat_x, repeat_y)
	end
end


function M:get_repeat()
	if not self.is_inited then
		return 1, 1
	end
	local size_x = gui.get(self.node, helper.PROP_SIZE_X)
	local size_y = gui.get(self.node, helper.PROP_SIZE_Y)
	local scale_x = gui.get(self.node, helper.PROP_SCALE_X)
	local scale_y = gui.get(self.node, helper.PROP_SCALE_Y)

	local repeat_x = (size_x / self.animation.width) / scale_x
	local repeat_y = (size_y / self.animation.height) / scale_y

	return repeat_x, repeat_y
end


function M:get_atlas_path(callback)
	event_queue.request("druid.get_atlas_path", callback, gui.get_texture(self.node), msg.url())
end


---@return boolean
function M:init_tiling_animation(atlas_path)
	if not atlas_path then
		print("No atlas path found for node", gui.get_id(self.node), gui.get_texture(self.node))
		print("Probably you should add druid.script at window collection to access resources")
		return false
	end

	self.animation = helper.get_animation_data_from_node(self.node, atlas_path)
	return true
end

-- Start our repeat shader work
-- @param repeat_x -- X factor
-- @param repeat_y -- Y factor
function M:animate(repeat_x, repeat_y)
	if not self.is_inited then
		return
	end

	local node = self.node
	local animation = self.animation

	local frame = animation.frames[1]
	gui.set(node, "uv_coord", frame.uv_coord)
	self:set_repeat(repeat_x, repeat_y)

	if #animation.frames > 1 and animation.fps > 0 then
		animation.handle =
		timer.delay(1/animation.fps, true, function(self, handle, time_elapsed)
			local next_rame = animation.frames[animation.current_frame]
			gui.set(node, "uv_coord", next_rame.uv_coord)

			animation.current_frame = animation.current_frame + 1
			if animation.current_frame > #animation.frames then
				animation.current_frame = 1
			end
		end)
	end
end


function M:final()
	local animation = self.animation
	if animation.handle then
		timer.cancel(animation.handle)
		animation.handle = nil
	end
end


-- Update repeat factor values
-- @param repeat_x
-- @param repeat_y
function M:set_repeat(repeat_x, repeat_y)
	local animation = self.animation
	animation.v.x = repeat_x or animation.v.x
	animation.v.y = repeat_y or animation.v.y

	local anchor = helper.get_pivot_offset(gui.get_pivot(self.node))
	animation.v.z = anchor.x
	animation.v.w = anchor.y

	gui.set(self.node, "uv_repeat", animation.v)
end


function M:set_perpective(perspective_x, perspective_y)
	if perspective_x then
		gui.set(self.node, "perspective.x", perspective_x)
	end

	if perspective_y then
		gui.set(self.node, "perspective.y", perspective_y)
	end

	return self
end


function M:set_perpective_offset(offset_x, offset_y)
	if offset_x then
		gui.set(self.node, "perspective.z", offset_x)
	end

	if offset_y then
		gui.set(self.node, "perspective.w", offset_y)
	end

	return self
end


function M:set_offset(offset_perc_x, offset_perc_y)
	self.params.z = offset_perc_x or self.params.z
	self.params.w = offset_perc_y or self.params.w
	gui.set(self.node, "params", self.params)
	return self
end


function M:set_margin(margin_x, margin_y)
	self.params.x = margin_x or self.params.x
	self.params.y = margin_y or self.params.y
	gui.set(self.node, "params", self.params)
	return self
end


---@param scale number
function M:set_scale(scale)
	local current_scale_x = gui.get(self.node, helper.PROP_SCALE_X)
	local current_scale_y = gui.get(self.node, helper.PROP_SCALE_Y)
	local current_size_x = gui.get(self.node, helper.PROP_SIZE_X)
	local current_size_y = gui.get(self.node, helper.PROP_SIZE_Y)

	local delta_scale_x = scale / current_scale_x
	local delta_scale_y = scale / current_scale_y
	gui.set(self.node, helper.PROP_SCALE_X, scale)
	gui.set(self.node, helper.PROP_SCALE_Y, scale)
	gui.set(self.node, helper.PROP_SIZE_X, current_size_x / delta_scale_x)
	gui.set(self.node, helper.PROP_SIZE_Y, current_size_y / delta_scale_y)

	--self.druid:on_node_property_changed(self.node, "scale")
	--self.druid:on_node_property_changed(self.node, "size")

	--local repeat_x, repeat_y = self:get_repeat()
	--self:set_repeat(repeat_x, repeat_y)

	return self
end


return M
