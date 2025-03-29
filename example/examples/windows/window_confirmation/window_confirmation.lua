local panthera = require("panthera.panthera")

local window_animation_panthera = require("example.examples.windows.window_animation_panthera")

---@class examples.window_confirmation: druid.widget
---@field text_header druid.lang_text
---@field text_button_accept druid.lang_text
---@field text_button_decline druid.lang_text
---@field text_description druid.lang_text
---@field button_close druid.button
---@field button_accept druid.button
---@field button_decline druid.button
---@field animation panthera.animation
local M = {}


function M:init()
	self.text_header = self.druid:new_lang_text("text_header", "ui_confirmation") --[[@as druid.lang_text]]
	self.text_button_accept = self.druid:new_lang_text("button_accept/text", "ui_accept") --[[@as druid.lang_text]]
	self.text_button_decline = self.druid:new_lang_text("button_decline/text", "ui_decline") --[[@as druid.lang_text]]
	self.text_description = self.druid:new_lang_text("text") --[[@as druid.lang_text]]

	self.button_close = self.druid:new_button("button_close", self.on_button_close)
	self.button_accept = self.druid:new_button("button_accept/root")
	self.button_decline = self.druid:new_button("button_decline/root")

	self.animation = panthera.create_gui(window_animation_panthera, self:get_template(), self:get_nodes())
	panthera.play(self.animation, "open")
end


function M:on_button_close()
	panthera.play(self.animation, "close")
end


return M
