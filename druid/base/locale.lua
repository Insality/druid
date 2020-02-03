--- Component to handle all GUI texts
-- Good working with localization system
-- @module base.text

local const = require("druid.const")
local settings = require("druid.system.settings")
local component = require("druid.system.component")

local M = component.create("locale", { const.ON_CHANGE_LANGUAGE })


function M.init(self, node, lang_id, no_adjust)
	self.druid = self:get_druid()
	self.text = self.druid:new_text(node, lang_id, no_adjust)
	self:translate(lang_id)

	return self
end


function M.set_to(self, text)
	self.last_locale = false
	self.text:set_to(text)
end


--- Translate the text by locale_id
-- @function text:translate
-- @tparam table self Component instance
-- @tparam string locale_id Locale id
function M.translate(self, locale_id)
	self.last_locale = locale_id or self.last_locale
	self.text:set_to(settings.get_text(self.last_locale))
end


function M.on_change_language(self)
	if self.last_locale then
		M.translate(self)
	end
end


return M
