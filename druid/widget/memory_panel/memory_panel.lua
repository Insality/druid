local helper = require("druid.helper")
local mini_graph = require("druid.widget.mini_graph.mini_graph")

---@class widget.memory_panel: druid.widget
---@field root node
local M = {}


function M:init()
	self.root = self:get_node("root")
	self.delta_time = 0.1
	self.samples_count = 30
	self.memory_limit = 100

	self.mini_graph = self.druid:new_widget(mini_graph, "mini_graph")
	self.mini_graph:set_samples(self.samples_count)

	-- This one is not works with scaled root
	--gui.set_parent(self:get_node("content"), self.mini_graph.content, true)

	do -- Set parent manually
		local parent_node = self.mini_graph.content
		local position = helper.get_full_position(parent_node, self.mini_graph.root)
		local content = self:get_node("content")
		gui.set_parent(content, self.mini_graph.content)
		gui.set_position(content, -position)
	end

	self.max_value = self.druid:new_text("text_max_value")
	self.text_per_second = self.druid:new_text("text_per_second")
	self.text_memory = self.druid:new_text("text_memory")

	self.memory = collectgarbage("count")
	self.memory_samples = {}

	self:update_text_memory()

	self.timer_id = timer.delay(self.delta_time, true, function()
		self:push_next_value()
	end)

	self.container = self.druid:new_container(self.root)
	self.container:add_container(self.mini_graph.container)
	local container_content = self.container:add_container("content")
	container_content:add_container("text_max_value")
	container_content:add_container("text_per_second")
end


function M:on_remove()
	timer.cancel(self.timer_id)
end


function M:set_low_memory_limit(limit)
	self.memory_limit = limit
end


function M:push_next_value()
	local memory = collectgarbage("count")
	local diff = math.max(0, memory - self.memory)
	self.memory = memory
	self:update_text_memory()

	table.insert(self.memory_samples, diff)
	if #self.memory_samples > self.samples_count then
		table.remove(self.memory_samples, 1)
	end

	self.mini_graph:push_line_value(diff)

	local max_value = math.max(unpack(self.memory_samples))
	max_value = math.max(max_value, self.memory_limit) -- low limit to display
	self.mini_graph:set_max_value(max_value)

	local max_memory = math.ceil(self.mini_graph:get_highest_value())
	self.max_value:set_text(max_memory .. " KB")

	local last_second = 0
	local last_second_samples = math.ceil(1 / self.delta_time)
	for index = #self.memory_samples - last_second_samples + 1, #self.memory_samples do
		last_second = last_second + (self.memory_samples[index] or 0)
	end
	self.text_per_second:set_text(math.ceil(last_second) .. " KB/s")
end


function M:update_text_memory()
	local memory = math.ceil(collectgarbage("count")) -- in KB
	if memory > 1024 then
		memory = memory / 1024
		self.text_memory:set_text(string.format("%.2f", memory) .. " MB")
	else
		self.text_memory:set_text(memory .. " KB")
	end
end


return M
