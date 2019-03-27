local data = require("druid.data")
local druid_input = require("druid.helper.druid_input")
local settings = require("druid.settings")

local M = {}

local log = settings.log
local _factory = {}

local STRING = "string"

--- New druid era, registering components
local components = {
	-- basic
	button = require("druid.base.button"),
	android_back = require("druid.base.android_back"),
	text = require("druid.base.text"),
	timer = require("druid.base.timer"),
}


local function register_basic_components()
	for k, v in pairs(components) do
		M.register(k, v)
	end
end


function M.register(name, module)
	-- TODO: Find better solution to creating elements?
	_factory["new_" .. name] = function(factory, node_name, ...)
			M.create(factory, module, node_name, ...)
		end
		log("Register component", name)
end

--- Create UI instance for ui elements
-- @return instance with all ui components
function M.new(self)
	local factory = setmetatable({}, {__index = _factory})
	factory.parent = self
	return factory
end

--------------------------------------------------------------------------------

local function input_init(factory)
	if not factory.input_inited then
		factory.input_inited = true
		druid_input.focus()
	end
end


local function create(module, factory, name, ...)
	local instance = setmetatable({}, {__index = module})
	instance.parent = factory
	if name then
		if type(name) == STRING then
			instance.name = name
			instance.node = gui.get_node(name)
		else
			--name already is node
			instance.name = nil
			instance.node = name
		end
	end
	factory[#factory + 1] = instance

	local register_to = module.interest or {}
	for i, v in ipairs(register_to) do
		if not factory[v] then
			factory[v] = {}
		end
		factory[v][#factory[v] + 1] = instance

		if v == data.ON_INPUT then
			input_init(factory)
		end
	end
	return instance
end


function M.create(factory, module, name, ...)
	local instance = create(module, factory, name)

	if instance.init then
		instance:init(...)
	end
end

register_basic_components()
--------------------------------------------------------------------------------

--- Called on_message
function _factory.on_message(factory, message_id, message, sender)
	if message_id == data.LAYOUT_CHANGED then
		if factory[data.LAYOUT_CHANGED] then
			M.translate(factory)
			for i, v in ipairs(factory[data.LAYOUT_CHANGED]) do
				v:on_layout_updated(message)
			end
		end
	elseif message_id == data.TRANSLATABLE then
		M.translate(factory)
	else
		if factory[data.ON_MESSAGE] then
			for i, v in ipairs(factory[data.ON_MESSAGE]) do
				v:on_message(message_id, message, sender)
			end
		end
	end
end


--- Called ON_INPUT
function _factory.on_input(factory, action_id, action)
	if factory[data.ON_SWIPE] then
		local v, result
		local len = #factory[data.ON_SWIPE]
		for i = 1, len do
			v = factory[data.ON_SWIPE][i]
			result = result or v:on_input(action_id, action)
		end
		if result then
			return true
		end
	end
	if factory[data.ON_INPUT] then
		local v
		local len = #factory[data.ON_INPUT]
		for i = 1, len do
			v = factory[data.ON_INPUT][i]
			if action_id == v.event and v:on_input(action_id, action) then
				return true
			end
		end
		return false
	end
	return false
end


--- Called on_update
function _factory.update(factory, dt)
	if factory[data.ON_UPDATE] then
		for i, v in ipairs(factory[data.ON_UPDATE]) do
			v:update(dt)
		end
	end
end

return M