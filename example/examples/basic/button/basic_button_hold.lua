local component = require("druid.component")
local panthera = require("panthera.panthera")

local animation = require("example.examples.basic.button.basic_button_hold_panthera")

---@class basic_button_hold: druid.base_component
---@field druid druid.instance
---@field button druid.button
local M = component.create("basic_button_hold")

---@param template string
---@param nodes table<hash, node>
function M:init(template, nodes)
	self.druid = self:get_druid(template, nodes)

	self.animation = panthera.create_gui(animation, self:get_template(), nodes)

	self.button = self.druid:new_button("button", function()
		print("Click")
	end)

	self.button:set_style({})
	self.button.style.AUTOHOLD_TRIGGER = 2
	self.button.style.LONGTAP_TIME = 0

	self.button.on_hold_callback:subscribe(function(_, _, _, time)
		local start_time = self.button.style.LONGTAP_TIME
		local max_time = self.button.style.AUTOHOLD_TRIGGER
		local progress = (time - start_time) / (max_time - start_time)
		panthera.set_time(self.animation, "hold", progress)
	end)

	self.button.on_long_click:subscribe(function()
		panthera.play(self.animation, "complete")
	end)

	self.button.hover.on_mouse_hover:subscribe(function(_, state)
		if not state then
			panthera.set_time(self.animation, "hold", 0)
		end
	end)

	self.button.on_click_outside:subscribe(function()
		panthera.set_time(self.animation, "hold", 0)
	end)
end


return M
