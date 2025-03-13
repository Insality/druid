local helper = require("druid.helper")
local mini_graph = require("druid.widget.mini_graph.mini_graph")

---@class widget.fps_panel: druid.widget
---@field root node
local M = {}

local TARGET_FPS = sys.get_config_int("display.update_frequency", 60)
if TARGET_FPS == 0 then
	TARGET_FPS = 60
end


function M:init()
	self.root = self:get_node("root")

	self.delta_time = 0.1 -- in seconds
	self.collect_time = 3 -- in seconds
	self.collect_time_counter = 0
	self.graph_samples = self.collect_time / self.delta_time

	-- Store frame time in seconds last collect_time seconds
	self.fps_samples = {}

	self.mini_graph = self.druid:new_widget(mini_graph, "mini_graph")
	self.mini_graph:set_samples(self.graph_samples) -- show last 30 seconds
	self.mini_graph:set_max_value(TARGET_FPS)

	do -- Set parent manually
		local parent_node = self.mini_graph.content
		local position = helper.get_full_position(parent_node, self.mini_graph.root)
		local content = self:get_node("content")
		gui.set_parent(content, self.mini_graph.content)
		gui.set_position(content, -position)
	end

	self.text_min_fps = self.druid:new_text("text_min_fps")
	self.text_fps = self.druid:new_text("text_fps")

	self.timer_id = timer.delay(self.delta_time, true, function()
		self:push_fps_value()
	end)

	--self.container = self.druid:new_container(self.root)
	--self.container:add_container(self.mini_graph.container)
	--local container_content = self.container:add_container("content")
	--container_content:add_container("text_min_fps")
	--container_content:add_container("text_fps")
end


function M:on_remove()
	timer.cancel(self.timer_id)
end


function M:update(dt)
	if not self.previous_time then
		self.previous_time = socket.gettime()
		return
	end

	local current_time = socket.gettime()
	local delta_time = current_time - self.previous_time
	self.previous_time = current_time
	self.collect_time_counter = self.collect_time_counter + delta_time

	table.insert(self.fps_samples, 1, delta_time)

	while self.collect_time_counter > self.collect_time do
		-- Remove last
		local removed_value = table.remove(self.fps_samples)
		self.collect_time_counter = self.collect_time_counter - removed_value
	end
end


function M:push_fps_value()
	if #self.fps_samples == 0 then
		return
	end

	local max_frame_time = 0
	local average_frame_time = 0
	local average_samples_count = self.delta_time
	local average_collected = 0
	for index = 1, #self.fps_samples do
		if average_frame_time < average_samples_count then
			average_frame_time = average_frame_time + self.fps_samples[index]
			average_collected = average_collected + 1
		end
		max_frame_time = math.max(max_frame_time, self.fps_samples[index])
	end

	average_frame_time = average_frame_time / average_collected

	self.mini_graph:push_line_value(1 / average_frame_time)

	self.text_fps:set_text(tostring(math.ceil(1 / average_frame_time) .. " FPS"))
	local lowest_value = math.ceil(self.mini_graph:get_lowest_value())
	self.text_min_fps:set_text(lowest_value .. " lowest")
end


return M
