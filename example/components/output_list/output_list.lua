local component = require("druid.component")
local container = require("example.components.container.container")
local lang_text = require("druid.extended.lang_text")

---@class output_list: druid.base_component
---@field root druid.container
---@field text_header druid.text
---@field scroll druid.scroll
---@field druid druid_instance
local M = component.create("output_list")

---@param template string
---@param nodes table<hash, node>
function M:init(template, nodes)
	self.druid = self:get_druid(template, nodes)

	self.root = self.druid:new(container, "root") --[[@as druid.container]]
	self.root:add_container("text_header")
	self.root:add_container("separator")

	self.created_texts = {}
	self.prefab = self:get_node("text")
	gui.set_enabled(self.prefab, false)

	self.grid = self.druid:new_static_grid("scroll_content", "text", 1)
	self.scroll = self.druid:new_scroll("scroll_view", "scroll_content")
	self.scroll:bind_grid(self.grid)
	self.scroll:set_horizontal_scroll(false)

	self.druid:new(lang_text, "text_header", "ui_output")

	local defold_version = sys.get_engine_info().version
	gui.set_text(self:get_node("text_version_defold"), "Defold v" .. defold_version)

	local druid_version = sys.get_config_string("project.version")
	gui.set_text(self:get_node("text_version_druid"), "Druid v" .. druid_version)
end


---@param text string
function M:add_log_text(text)
	local text_node = gui.clone(self.prefab)
	gui.set_enabled(text_node, true)

	local text_instance = self.druid:new_text(text_node, text)
	self.grid:add(text_instance.node)
	table.insert(self.created_texts, text_instance)

	self.scroll:scroll_to_percent(vmath.vector3(0, 0, 0))

	if #self.created_texts > 64 then
		self.grid:remove(1)
		self.druid:remove(self.created_texts[1])
		gui.delete_node(self.created_texts[1].node)
		table.remove(self.created_texts, 1)
	end
end


function M:clear()
	for index = 1, #self.created_texts do
		self.druid:remove(self.created_texts[index])
	end

	local nodes = self.grid.nodes
	for index = 1, #nodes do
		gui.delete_node(nodes[index])
	end
	self.created_texts = {}
	self.grid:clear()
end


return M
