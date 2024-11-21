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
-- @tfield event on_change event

--- The text component
-- @tfield Text text Text

--- Text node
-- @tfield node node

---

local event = require("event.event")
local settings = require("druid.system.settings")
local component = require("druid.component")

---@class druid.lang_text: druid.base_component
---@field text druid.text
---@field node node
---@field on_change event
---@field private last_locale_args table
---@field private last_locale string
local M = component.create("lang_text")


--- The LangText constructor
---@param node string|node The node_id or gui.get_node(node_id)
---@param locale_id string|nil Default locale id or text from node as default
---@param adjust_type string|nil Adjust type for text. By default is DOWNSCALE. Look const.TEXT_ADJUST for reference
function M:init(node, locale_id, adjust_type)
	self.druid = self:get_druid()
	self.text = self.druid:new_text(node, locale_id, adjust_type)
	self.node = self.text.node
	self.last_locale_args = {}

	self.on_change = event.create()

	self:translate(locale_id or gui.get_text(self.node))
	self.text.on_set_text:subscribe(self.on_change.trigger, self.on_change)

	return self
end


function M:on_language_change()
	if self.last_locale then
		self:translate(self.last_locale, unpack(self.last_locale_args))
	end
end


--- Setup raw text to lang_text component
---@param text string Text for text node
---@return druid.lang_text Current instance
function M:set_to(text)
	self.last_locale = false
	self.text:set_to(text)
	self.on_change:trigger()

	return self
end


--- Translate the text by locale_id
---@param locale_id string Locale id
---@param a string|nil Optional param to string.format
---@param b string|nil Optional param to string.format
---@param c string|nil Optional param to string.format
---@param d string|nil Optional param to string.format
---@param e string|nil Optional param to string.format
---@param f string|nil Optional param to string.format
---@param g string|nil Optional param to string.format
---@return druid.lang_text Current instance
function M:translate(locale_id, a, b, c, d, e, f, g)
	self.last_locale_args = { a, b, c, d, e, f, g }
	self.last_locale = locale_id or self.last_locale
	self.text:set_to(settings.get_text(self.last_locale, a, b, c, d, e, f, g) or "")

	return self
end


--- Format string with new text params on localized text
---@param a string|nil Optional param to string.format
---@param b string|nil Optional param to string.format
---@param c string|nil Optional param to string.format
---@param d string|nil Optional param to string.format
---@param e string|nil Optional param to string.format
---@param f string|nil Optional param to string.format
---@param g string|nil Optional param to string.format
---@return druid.lang_text Current instance
function M:format(a, b, c, d, e, f, g)
	self.last_locale_args = { a, b, c, d, e, f, g }
	self.text:set_to(settings.get_text(self.last_locale, a, b, c, d, e, f, g) or "")

	return self
end

return M
