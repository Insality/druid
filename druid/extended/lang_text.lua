-- Copyright (c) 2021 Maksim Tuprikov <insality@gmail.com>. This code is licensed under MIT license

--- Component to wrap over GUI Text nodes with localization helpers
--
-- <b># Overview #</b>
--
-- • The initialization of druid.set_text_function is required to enable localization
-- using the localization ID.
--
-- • The LangText component supports up to 7 string format parameters.
-- This limitation exists due to certain issues with using ... arguments.
--
-- <b># Notes #</b>
--
-- <a href="https://insality.github.io/druid/druid/index.html?example=texts_lang_text" target="_blank"><b>Example Link</b></a>
-- @module LangText
-- @within BaseComponent
-- @alias druid.lang_text

--- On change text callback
-- @tfield DruidEvent on_change @{DruidEvent}

--- The text component
-- @tfield Text text @{Text}

---

local Event = require("druid.event")
local settings = require("druid.system.settings")
local component = require("druid.component")

local LangText = component.create("lang_text")


--- The @{LangText} constructor
-- @tparam LangText self @{LangText}
-- @tparam string|node node Node name or GUI Text Node itself
-- @tparam string locale_id Default locale id or text from node as default
-- @tparam[opt=downscale] string adjust_type Adjust type for text. By default is DOWNSCALE. Look const.TEXT_ADJUST for reference
function LangText.init(self, node, locale_id, adjust_type)
	self.druid = self:get_druid()
	self.text = self.druid:new_text(node, locale_id, adjust_type)
	self.node = self.text.node
	self.last_locale_args = {}

	self.on_change = Event()

	self:translate(locale_id or gui.get_text(self.node))
	self.text.on_set_text:subscribe(self.on_change.trigger, self.on_change)

	return self
end


function LangText.on_language_change(self)
	if self.last_locale then
		self:translate(self.last_locale, unpack(self.last_locale_args))
	end
end


--- Setup raw text to lang_text component
-- @tparam LangText self @{LangText}
-- @tparam string text Text for text node
-- @treturn LangText Current instance
function LangText.set_to(self, text)
	self.last_locale = false
	self.text:set_to(text)
	self.on_change:trigger()

	return self
end


--- Translate the text by locale_id
-- @tparam LangText self @{LangText}
-- @tparam string locale_id Locale id
-- @tparam[opt] string a Optional param to string.format
-- @tparam[opt] string b Optional param to string.format
-- @tparam[opt] string c Optional param to string.format
-- @tparam[opt] string d Optional param to string.format
-- @tparam[opt] string e Optional param to string.format
-- @tparam[opt] string f Optional param to string.format
-- @tparam[opt] string g Optional param to string.format
-- @treturn LangText Current instance
function LangText.translate(self, locale_id, a, b, c, d, e, f, g)
	self.last_locale_args = { a, b, c, d, e, f, g }
	self.last_locale = locale_id or self.last_locale
	self.text:set_to(settings.get_text(self.last_locale, a, b, c, d, e, f, g) or "")

	return self
end


--- Format string with new text params on localized text
-- @tparam LangText self @{LangText}
-- @tparam[opt] string a Optional param to string.format
-- @tparam[opt] string b Optional param to string.format
-- @tparam[opt] string c Optional param to string.format
-- @tparam[opt] string d Optional param to string.format
-- @tparam[opt] string e Optional param to string.format
-- @tparam[opt] string f Optional param to string.format
-- @tparam[opt] string g Optional param to string.format
-- @treturn LangText Current instance
function LangText.format(self, a, b, c, d, e, f, g)
	self.last_locale_args = { a, b, c, d, e, f, g }
	self.text:set_to(settings.get_text(self.last_locale, a, b, c, d, e, f, g) or "")

	return self
end

return LangText
