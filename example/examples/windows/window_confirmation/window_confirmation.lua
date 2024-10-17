local component = require("druid.component")
local lang_text = require("druid.extended.lang_text")
local panthera = require("panthera.panthera")

local window_animation_panthera = require("example.examples.windows.window_animation_panthera")

---@class window_confirmation: druid.base_component
---@field druid druid_instance
---@field text_header druid.lang_text
---@field text_button_accept druid.lang_text
---@field text_button_decline druid.lang_text
---@field text_description druid.lang_text
---@field button_close druid.button
local M = component.create("window_confirmation")


---@param template string
---@param nodes table<hash, node>
function M:init(template, nodes)
	self.druid = self:get_druid(template, nodes)

	self.text_header = self.druid:new(lang_text, "text_header", "ui_confirmation") --[[@as druid.lang_text]]
	self.text_button_accept = self.druid:new(lang_text, "button_accept/text", "ui_accept") --[[@as druid.lang_text]]
	self.text_button_decline = self.druid:new(lang_text, "button_decline/text", "ui_decline") --[[@as druid.lang_text]]
	self.text_description = self.druid:new(lang_text, "text") --[[@as druid.lang_text]]

	self.button_close = self.druid:new_button("button_close", self.on_button_close)
	self.button_accept = self.druid:new_button("button_accept/root")
	self.button_decline = self.druid:new_button("button_decline/root")

	self.animation = panthera.create_gui(window_animation_panthera, self:get_template(), nodes)
	panthera.play(self.animation, "open")
end


function M:on_button_close()
	panthera.play(self.animation, "close")
end


return M
