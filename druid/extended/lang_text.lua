--- Component to handle all GUI texts
-- Good working with localization system
-- @module LangText
-- @within BaseComponent
-- @alias druid.lang_text

--- On change text callback
-- @tfield druid_event on_change

--- The text component
-- @tfield Text text


local Event = require("druid.event")
local settings = require("druid.system.settings")
local component = require("druid.component")

local LangText = component.create("lang_text", { component.ON_LANGUAGE_CHANGE })


--- Component init function
-- @tparam LangText self
-- @tparam node node The text node
-- @tparam string locale_id Default locale id, optional
-- @tparam bool no_adjust If true, will not correct text size
function LangText.init(self, node, locale_id, no_adjust)
	self.druid = self:get_druid()
	self.text = self.druid:new_text(node, locale_id, no_adjust)
	self.last_locale_args = {}

	self.on_change = Event()

	if locale_id then
		self:translate(locale_id)
	end

	return self
end


function LangText.on_language_change(self)
	if self.last_locale then
		self:translate(self.last_locale, unpack(self.last_locale_args))
	end
end


--- Setup raw text to lang_text component
-- @tparam LangText self
-- @tparam string text Text for text node
function LangText.set_to(self, text)
	self.last_locale = false
	self.text:set_to(text)
	self.on_change:trigger()
end


--- Translate the text by locale_id
-- @tparam LangText self
-- @tparam string locale_id Locale id
function LangText.translate(self, locale_id, ...)
	self.last_locale_args = {...}
	self.last_locale = locale_id or self.last_locale
	self.text:set_to(settings.get_text(self.last_locale, ...) or "")
end


return LangText
