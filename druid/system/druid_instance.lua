local const = require("druid.const")
local druid_input = require("druid.helper.druid_input")

local M = {}


local function input_init(self)
	if not self.input_inited then
		self.input_inited = true
		druid_input.focus()
	end
end


-- Create the component
local function create(self, module)
	local instance = setmetatable({}, { __index = module })
	-- Component context, self from component creation
	instance:setup_component(self._context, self._style)

	table.insert(self, instance)

	local register_to = module._component.interest
	if register_to then
		local v
		for i = 1, #register_to do
			v = register_to[i]
			if not self[v] then
				self[v] = {}
			end
			table.insert(self[v], instance)

			if const.UI_INPUT[v] then
				input_init(self)
			end
		end
	end

	return instance
end


function M.new(self, module, ...)
	local instance = create(self, module)

	if instance.init then
		instance:init(...)
	end

	return instance
end


function M.remove(self, instance)
	for i = #self, 1, -1 do
		if self[i] == instance then
			table.remove(self, i)
		end
	end

	local interest = instance._component.interest
	if interest then
		local v
		for i = 1, #interest do
			v = interest[i]
			local array = self[v]
			for j = #array, 1, -1 do
				if array[j] == instance then
					table.remove(array, j)
				end
			end
		end
	end
end


--- Called on_message
function M.on_message(self, message_id, message, sender)
	local specific_ui_message = const.SPECIFIC_UI_MESSAGES[message_id]
	if specific_ui_message then
		local array = self[message_id]
		if array then
			local item
			for i = 1, #array do
				item = array[i]
				item[specific_ui_message](item, message, sender)
			end
		end
	else
		local array = self[const.ON_MESSAGE]
		if array then
			for i = 1, #array do
				array[i]:on_message(message_id, message, sender)
			end
		end
	end
end


local function notify_input_on_swipe(self)
	if self[const.ON_INPUT] then
		local len = #self[const.ON_INPUT]
		for i = len, 1, -1 do
			local comp = self[const.ON_INPUT][i]
			if comp.on_swipe then
				comp:on_swipe()
			end
		end
	end
end


local function match_event(action_id, events)
	if type(events) == "table" then
		for i = 1, #events do
			if action_id == events[i] then
				return true
			end
		end
	else
		return action_id == events
	end
end


--- Called ON_INPUT
function M.on_input(self, action_id, action)
	local array = self[const.ON_SWIPE]
	if array then
		local v, result
		local len = #array
		for i = len, 1, -1 do
			v = array[i]
			result = result or v:on_input(action_id, action)
		end
		if result then
			notify_input_on_swipe(self)
			return true
		end
	end

	array = self[const.ON_INPUT]
	if array then
		local v
		local len = #array
		for i = len, 1, -1 do
			v = array[i]
			if match_event(action_id, v.event) and v:on_input(action_id, action) then
				return true
			end
		end
		return false
	end
	return false
end


--- Called on_update
function M.update(self, dt)
	local array = self[const.ON_UPDATE]
	if array then
		for i = 1, #array do
			array[i]:update(dt)
		end
	end
end


return M
