--- Druid UI Library.
-- Component based UI library to make your life easier.
-- Contains a lot of base components and give API
-- to create your own rich components.
-- @module druid

local const = require("druid.const")
local druid_input = require("druid.helper.druid_input")
local settings = require("druid.settings")

local M = {}

local log = settings.log
local _fct_metatable = {}

--- Basic components
M.comps = {
	button = require("druid.base.button"),
	back_handler = require("druid.base.back_handler"),
	text = require("druid.base.text"),
	timer = require("druid.base.timer"),
	progress = require("druid.base.progress"),
	grid = require("druid.base.grid"),
	scroll = require("druid.base.scroll"),
	slider = require("druid.base.slider"),
	checkbox = require("druid.base.checkbox"),
	checkbox_group = require("druid.base.checkbox_group"),
	radio_group = require("druid.base.radio_group"),

	progress_rich = require("druid.rich.progress_rich"),
}


local function register_basic_components()
	for k, v in pairs(M.comps) do
		if not _fct_metatable["new_" .. k] then
			M.register(k, v)
		else
			log("Basic component", k, "already registered")
		end
	end
end


--- Register external module
-- @tparam string name module name
-- @tparam table module lua table with module
function M.register(name, module)
	-- TODO: Find better solution to creating elements?
	_fct_metatable["new_" .. name] = function(self, ...)
		return _fct_metatable.new(self, module, ...)
	end
	log("Register component", name)
end


--- Create UI instance for ui elements
-- @return instance with all ui components
function M.new(component_script)
	if register_basic_components then
		register_basic_components()
		register_basic_components = false
	end
	local self = setmetatable({}, {__index = _fct_metatable})
	self.parent = component_script
	return self
end


local function input_init(self)
	if not self.input_inited then
		self.input_inited = true
		druid_input.focus()
	end
end


local function create(self, module)
	local instance = setmetatable({}, {__index = module})
	instance.parent = self
	self[#self + 1] = instance

	local register_to = module.interest
	if register_to then
		local v
		for i = 1, #register_to do
			v = register_to[i]
			if not self[v] then
				self[v] = {}
			end
			self[v][#self[v] + 1] = instance

			if const.ui_input[v] then
				input_init(self)
			end
		end
	end
	return instance
end


function _fct_metatable.remove(self, instance)
	for i = #self, 1, -1 do
		if self[i] == instance then
			table.remove(self, i)
		end
	end
	local interest = instance.interest
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


function _fct_metatable.new(self, module, ...)
	local instance = create(self, module)

	if instance.init then
		instance:init(...)
	end

	return instance
end


--- Called on_message
function _fct_metatable.on_message(self, message_id, message, sender)
	local specific_ui_message = const.specific_ui_messages[message_id]
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
function _fct_metatable.on_input(self, action_id, action)
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
function _fct_metatable.update(self, dt)
	local array = self[const.ON_UPDATE]
	if array then
		for i = 1, #array do
			array[i]:update(dt)
		end
	end
end


return M
