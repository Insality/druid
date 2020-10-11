--- Component to handle all GUI texts
-- Good working with localization system
-- @module druid.lang_text
-- @within BaseComponent
-- @alias druid.lang_text

--- Component events
-- @table Events
-- @tfield druid_event on_change On change text callback

--- Component fields
-- @table Fields
-- @tfield druid.text text The text component

local Event = require("druid.event")
local const = require("druid.const")
local settings = require("druid.system.settings")
local component = require("druid.component")

local LangText = component.create("lang_text", { const.ON_LANGUAGE_CHANGE })


--- Component init function
-- @function lang_text:init
-- @tparam node node The text node
-- @tparam string locale_id Default locale id
-- @tparam bool no_adjust If true, will not correct text size
function LangText:init(node, locale_id, no_adjust)
	self.druid = self:get_druid()
	self.text = self.druid:new_text(node, locale_id, no_adjust)
	self.last_locale_args = {}

	self.on_change = Event()

	self:translate(locale_id)

	return self
end


function LangText:on_language_change()
	if self.last_locale then
		self:translate(self.last_locale, unpack(self.last_locale_args))
	end
end


--- Setup raw text to lang_text component
-- @function lang_text:set_to
-- @tparam string text Text for text node
function LangText:set_to(text)
	self.last_locale = false
	self.text:set_to(text)
	self.on_change:trigger()
end


--- Translate the text by locale_id
-- @function lang_text:translate
-- @tparam string locale_id Locale id
function LangText:translate(locale_id, ...)
	self.last_locale_args = {...}
	self.last_locale = locale_id or self.last_locale
	self.text:set_to(settings.get_text(self.last_locale, ...))
end


return LangText
