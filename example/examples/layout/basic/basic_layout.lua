local helper = require("druid.helper")
local layout = require("druid.extended.layout")

---@class examples.basic_layout: druid.widget
---@field root node
---@field layout druid.layout
---@field prefab node
---@field nodes table<number, node>
local M = {}

local PIVOTS = {
	gui.PIVOT_CENTER,
	gui.PIVOT_N,
	gui.PIVOT_NE,
	gui.PIVOT_E,
	gui.PIVOT_SE,
	gui.PIVOT_S,
	gui.PIVOT_SW,
	gui.PIVOT_W,
	gui.PIVOT_NW,
}


function M:init()
	self.root = self:get_node("root")
	self.layout = self.druid:new(layout, "layout", "horizontal_wrap")

	self.prefab = self:get_node("prefab")
	gui.set_enabled(self.prefab, false)
	local default_size = gui.get_size(self.prefab)

	self.nodes = {}

	for _ = 1, 12 do
		local node = gui.clone(self.prefab)

		-- Set different size for some nodes
		if math.random() > 0.5 then
			local size = vmath.vector3(default_size.x * 2, default_size.y, 0)
			gui.set_size(node, size)
		end

		-- Set random pivot point for each node
		local pivot = PIVOTS[math.random(1, #PIVOTS)]
		gui.set_pivot(node, pivot)

		gui.set_enabled(node, true)
		self.layout:add(node)
		table.insert(self.nodes, node)
	end
end


function M:set_pivot(pivot)
	local offset = helper.get_pivot_offset(pivot)
	local size = gui.get_size(self.root)
	local pos = vmath.vector3(size.x * offset.x, size.y * offset.y, 0)
	gui.set_position(self.layout.node, pos)
	gui.set_pivot(self.layout.node, pivot)

	self.layout:refresh_layout()
end


function M:on_remove()
	self.layout:clear_layout()
	for _, node in ipairs(self.nodes) do
		gui.delete_node(node)
	end
end


return M
