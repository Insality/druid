--- Druid UI Library.
-- Component based UI library to make your life easier.
-- Contains a lot of base components and give API
-- to create your own rich components.
-- @module druid


local const = require("druid.const")
local druid_instance = require("druid.system.druid_instance")
local settings = require("druid.system.settings")

local M = {}


local log = settings.log
-- Temporary, what the place for it?
local default_style = {}


--- Basic components
M.comps = {
	button = require("druid.base.button"),
	blocker = require("druid.base.blocker"),
	back_handler = require("druid.base.back_handler"),
	text = require("druid.base.text"),
	locale = require("druid.base.locale"),
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
		if not druid_instance["new_" .. k] then
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
	-- Possibly: druid.new(druid.BUTTON, etc?)
	-- Current way is very implicit
	druid_instance["new_" .. name] = function(self, ...)
		return druid_instance.new(self, module, ...)
	end
	log("Register component", name)
end


--- Create Druid instance for creating components
-- @return instance with all ui components
function M.new(component_script, style)
	if register_basic_components then
		register_basic_components()
		register_basic_components = false
	end
	local self = setmetatable({}, { __index = druid_instance })

	-- Druid context here (who created druid)
	-- Usually gui_script, but can be component from self:get_druid()
	self._context = component_script
	self._style = style or default_style

	-- TODO: Find the better way to handle components
	-- All component list
	self.all_components = {}
	-- Map: interest: {components}
	self.components = {}

	return self
end


function M.set_default_style(style)
	default_style = style
end


function M.set_text_function(callback)
	settings.get_text = callback or const.EMPTY_FUNCTION
	-- TODO: Update all localized text
end


function M.set_sound_function(callback)
	settings.play_sound = callback or const.EMPTY_FUNCTION
end


return M
