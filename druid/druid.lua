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


--- Basic components
M.components = {
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
	for k, v in pairs(M.components) do
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
function M.new(context, style)
	if register_basic_components then
		register_basic_components()
		register_basic_components = false
	end
	local druid = setmetatable({}, { __index = druid_instance })

	-- Druid context here (who created druid)
	-- Usually gui_script, but can be component from self:get_druid()
	druid._context = context
	druid._style = style or settings.default_style

	-- TODO: Find the better way to handle components
	-- All component list
	druid.all_components = {}
	-- Map: interest: {components}
	druid.components = {}

	return druid
end


function M.set_default_style(style)
	settings.default_style = style
end


function M.set_text_function(callback)
	settings.get_text = callback or const.EMPTY_FUNCTION
	-- TODO: Update all localized text
end


function M.set_sound_function(callback)
	settings.play_sound = callback or const.EMPTY_FUNCTION
end


return M
