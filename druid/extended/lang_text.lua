local event = require("event.event")
local component = require("druid.component")
local settings = require("druid.system.settings")

---The component used for displaying localized text, can automatically update text when locale is changed
---@class druid.lang_text: druid.component
---@field text druid.text The text component
---@field node node The node of the text component
---@field on_change event The event triggered when the text is changed
---@field private last_locale_args table The last locale arguments
---@field private last_locale string The last locale
local M = component.create("lang_text")


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


---Setup raw text to lang_text component
---@param text string Text for text node
---@return druid.lang_text self Current instance
function M:set_to(text)
	self.last_locale = nil
	self.text:set_text(text)
	self.on_change:trigger()

	return self
end


---Setup raw text to lang_text component
---@param text string Text for text node
---@return druid.lang_text self Current instance
function M:set_text(text)
	return self:set_to(text)
end


---Translate the text by locale_id
---@param locale_id string Locale id
---@param ... string Optional params for string.format
---@return druid.lang_text self Current instance
function M:translate(locale_id, ...)
	self.last_locale_args = { ... }
	self.last_locale = locale_id or self.last_locale
	self.text:set_text(settings.get_text(self.last_locale, ...) or "")

	return self
end


---Format string with new text params on localized text
---@param ... string Optional params for string.format
---@return druid.lang_text self Current instance
function M:format(...)
	self.last_locale_args = { ... }
	self.text:set_text(settings.get_text(self.last_locale, ...) or "")

	return self
end


return M
