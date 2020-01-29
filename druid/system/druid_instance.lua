local const = require("druid.const")
local druid_input = require("druid.helper.druid_input")
local settings = require("druid.system.settings")

local M = {}


local function input_init(self)
	-- TODO: To custom settings
	if not settings.auto_focus_gain then
		return
	end

	if not self.input_inited then
		self.input_inited = true
		druid_input.focus()
	end
end


-- Create the component
local function create(self, module)
	---@class component
	local instance = setmetatable({}, { __index = module })

	-- Component context, self from component creation
	instance:setup_component(self._context, self._style)

	table.insert(self.all_components, instance)

	local register_to = module._component.interest
	if register_to then
		for i = 1, #register_to do
			local interest = register_to[i]
			if not self.components[interest] then
				self.components[interest] = {}
			end
			table.insert(self.components[interest], instance)

			if const.UI_INPUT[interest] then
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
	for i = #self.all_components, 1, -1 do
		if self.all_components[i] == instance then
			table.remove(self, i)
		end
	end

	local interests = instance._component.interest
	if interests then
		for i = 1, #interests do
			local interest = interests[i]
			local array = self.components[interest]
			for j = #array, 1, -1 do
				if array[j] == instance then
					table.remove(array, j)
				end
			end
		end
	end
end


--- Druid instance update function
-- @function druid:update(dt)
function M.update(self, dt)
	local array = self.components[const.ON_UPDATE]
	if array then
		for i = 1, #array do
			array[i]:update(dt)
		end
	end
end


local function notify_input_on_swipe(self)
	if self.components[const.ON_INPUT] then
		local len = #self.components[const.ON_INPUT]
		for i = len, 1, -1 do
			local comp = self.components[const.ON_INPUT][i]
			if comp.on_swipe then
				comp:on_swipe()
			end
		end
	end
end


local function match_event(action_id, events)
	if type(events) == const.TABLE then
		for i = 1, #events do
			if action_id == events[i] then
				return true
			end
		end
	else
		return action_id == events
	end
end


--- Druid instance on_input function
-- @function druid:on_input(action_id, action)
function M.on_input(self, action_id, action)
	-- TODO: расписать отличия ON_SWIPE и ON_INPUT
	-- Почему-то некоторые используют ON_SWIPE, а логичнее ON_INPUT? (blocker, slider)
	local array = self.components[const.ON_SWIPE]
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

	array = self.components[const.ON_INPUT]
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


--- Druid instance on_message function
-- @function druid:on_message(message_id, message, sender)
function M.on_message(self, message_id, message, sender)
	local specific_ui_message = const.SPECIFIC_UI_MESSAGES[message_id]
	if specific_ui_message then
		local array = self.components[message_id]
		if array then
			local item
			for i = 1, #array do
				item = array[i]
				item[specific_ui_message](item, message, sender)
			end
		end
	else
		local array = self.components[const.ON_MESSAGE]
		if array then
			for i = 1, #array do
				array[i]:on_message(message_id, message, sender)
			end
		end
	end
end


return M
