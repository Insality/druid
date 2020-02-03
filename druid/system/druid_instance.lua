local const = require("druid.const")
local druid_input = require("druid.helper.druid_input")
local settings = require("druid.system.settings")
local class = require("druid.system.middleclass")

local Druid = class("druid.druid_instance")


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
local function create(self, instance_class)
	---@class component
	local instance = instance_class()

	-- Component context, self from component creation
	instance:setup_component(self._context, self._style)

	self.components[const.ALL] = self.components[const.ALL] or {}
	table.insert(self.components[const.ALL], instance)

	local register_to = instance:get_interests()
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


--- Druid constructor
function Druid.initialize(self, context, style)
	self._context = context
	self._style = style or settings.default_style
	self.components = {}
end


--- Create new component inside druid instance
function Druid.create(self, instance_class, ...)
	local instance = create(self, instance_class)

	if instance.init then
		instance:init(...)
	end

	return instance
end


--- Remove component from druid instance
-- It will call on_remove on component, if exist
function Druid.remove(self, component)
	local all_components = self.components[const.ALL]
	for i = #all_components, 1, -1 do
		if all_components[i] == component then
			if component.on_remove then
				component:on_remove()
			end
			table.remove(self, i)
		end
	end

	local interests = component:get_interests()
	if interests then
		for i = 1, #interests do
			local interest = interests[i]
			local components = self.components[interest]
			for j = #components, 1, -1 do
				if components[j] == component then
					table.remove(components, j)
				end
			end
		end
	end
end


--- Druid instance update function
-- @function druid:update(dt)
function Druid.update(self, dt)
	local components = self.components[const.ON_UPDATE]
	if components then
		for i = 1, #components do
			components[i]:update(dt)
		end
	end
end


--- Druid instance on_input function
-- @function druid:on_input(action_id, action)
function Druid.on_input(self, action_id, action)
	-- TODO: расписать отличия ON_SWIPE и ON_INPUT
	-- Почему-то некоторые используют ON_SWIPE, а логичнее ON_INPUT? (blocker, slider)
	local components = self.components[const.ON_SWIPE]
	if components then
		local result
		for i = #components, 1, -1 do
			local v = components[i]
			result = result or v:on_input(action_id, action)
		end
		if result then
			notify_input_on_swipe(self)
			return true
		end
	end

	components = self.components[const.ON_INPUT]
	if components then
		for i = #components, 1, -1 do
			local v = components[i]
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
function Druid.on_message(self, message_id, message, sender)
	local specific_ui_message = const.SPECIFIC_UI_MESSAGES[message_id]
	if specific_ui_message then
		local components = self.components[message_id]
		if components then
			for i = 1, #components do
				local component = components[i]
				component[specific_ui_message](component, message, sender)
			end
		end
	else
		local components = self.components[const.ON_MESSAGE] or const.EMPTY_TABLE
		for i = 1, #components do
			components[i]:on_message(message_id, message, sender)
		end
	end
end


return Druid
