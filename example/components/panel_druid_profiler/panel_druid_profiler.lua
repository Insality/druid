local event = require("event.event")
local helper = require("druid.helper")
local component = require("druid.component")


---@class panel_druid_profiler: druid.component
---@field root druid.container
---@field druid druid.instance
local M = component.create("panel_druid_profiler")
local FPS_SAMPLES = 60

---@param template string
---@param nodes table<hash, node>
function M:init(template, nodes)
	self.druid = self:get_druid(template, nodes)

	self.root = self.druid:new_container("root") --[[@as druid.container]]
	self.group_memory = self.root:add_container("group_memory")
	self.group_fps = self.root:add_container("group_fps")
	self.group_components = self.root:add_container("group_components")

	self.root:add_container("layout", nil, function()
		self.layout:set_dirty()
	end)
	self.layout = self.druid:new_layout("layout", "horizontal")
	self.layout:add(self.group_memory.node)
	self.layout:add(self.group_fps.node)
	self.layout:add(self.group_components.node)
	self.layout:set_justify(true)

	self.druid:new_button("group_memory", self.run_collectgarbage)

	self.group_memory:set_min_size(270, nil)
	self.group_fps:set_min_size(270, nil)
	self.group_components:set_min_size(270, nil)

	self.text_memory_amount = self.druid:new_text("text_memory_amount")
	self.text_fps_amount = self.druid:new_text("text_fps_amount")
	self.text_fps_min = self.druid:new_text("text_fps_min")
	self.text_components_amount = self.druid:new_text("text_components_amount")

	self.druid:new_lang_text("text_memory", "ui_profiler_memory")
	self.druid:new_lang_text("text_fps", "ui_profiler_fps")
	self.druid:new_lang_text("text_components", "ui_profiler_components")

	self.previous_time = nil
	self.fps_samples = {}

	self.nodes_memory = {
		self:get_node("text_memory"),
		self:get_node("text_memory_amount"),
		self:get_node("text_memory_kb"),
	}
	self.nodes_fps = {
		self:get_node("text_fps"),
		self:get_node("text_fps_amount"),
		self:get_node("text_fps_min"),
	}
	self.nodes_components = {
		self:get_node("text_components"),
		self:get_node("text_components_amount"),
	}

	timer.delay(0.16, true, function()
		self:update_memory()
		self:update_fps()
		self:update_components()
		self.layout:set_dirty()
	end)
end


function M:on_language_change()
	self:update_memory()
	self:update_fps()
	self:update_components()
	self.layout:set_dirty()
end


function M:update_memory()
	local memory = collectgarbage("count")
	self.text_memory_amount:set_text(tostring(math.ceil(memory)))

	local width = helper.centrate_nodes(2, unpack(self.nodes_memory))
	for index = 1, #self.nodes_memory do
		local node = self.nodes_memory[index]
		local position_x = gui.get(node, "position.x")
		gui.set(node, "position.x", position_x + width/2)
	end
	self.group_memory:set_size(width, nil)
end


function M:update_fps()
	local average_frame_time = 0
	local max_frame_time = 0
	for index = 1, #self.fps_samples do
		average_frame_time = average_frame_time + self.fps_samples[index]
		max_frame_time = math.max(max_frame_time, self.fps_samples[index])
	end
	average_frame_time = average_frame_time / #self.fps_samples

	self.text_fps_amount:set_text(tostring(math.ceil(1 / average_frame_time)))
	self.text_fps_min:set_text("/ " .. tostring(math.ceil(1 / max_frame_time)))

	local width = helper.centrate_nodes(2, unpack(self.nodes_fps))
	self.group_fps:set_size(width, nil)
end


function M:update_components()
	---@diagnostic disable-next-line, invisible
	local components = #self.druid.components_all

	self.text_components_amount:set_text(tostring(components))
	local width = helper.centrate_nodes(2, unpack(self.nodes_components))
	self.group_components:set_size(width, nil)
end


function M:update()
	self:sample_fps()
end


function M:sample_fps()
	if not self.previous_time then
		self.previous_time = socket.gettime()
		return
	end

	local current_time = socket.gettime()
	local delta_time = current_time - self.previous_time
	self.previous_time = current_time

	table.insert(self.fps_samples, delta_time)
	if #self.fps_samples > FPS_SAMPLES then
		table.remove(self.fps_samples, 1)
	end
end


function M:run_collectgarbage()
	collectgarbage("collect")
end


return M
