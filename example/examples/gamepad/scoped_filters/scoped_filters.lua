local filter_panel = require("example.examples.gamepad.scoped_filters.filter_panel")

---Two filter levels on one Druid instance.
---
---The example widget filters its own subtree, which is both panels, and each panel
---filters itself. The filters are applied on top of each other and never leak outside
---of the component they were set on.
---@class examples.scoped_filters: druid.widget
---@field panel_left examples.filter_panel
---@field panel_right examples.filter_panel
---@field button_lock_all druid.button
local M = {}


function M:init()
	-- The lock button is in the whitelist as well, otherwise the example would lock itself
	self.button_lock_all = self.druid:new_button("button_lock_all/root", self.toggle_lock_all)
	self.is_locked_all = false

	self.panel_left = self.druid:new_widget(filter_panel, "panel_left"):set_title("Panel Left")
	self.panel_right = self.druid:new_widget(filter_panel, "panel_right"):set_title("Panel Right")
end


function M:toggle_lock_all()
	self.is_locked_all = not self.is_locked_all

	if self.is_locked_all then
		-- Set on the example `self.druid`, so it covers both panels, but nothing outside
		self.druid:set_whitelist({ self.panel_left, self.button_lock_all })
	else
		self.druid:set_whitelist(nil)
	end

	local text = self.is_locked_all and "Unlock the example" or "Lock to Left panel"
	gui.set_text(self:get_node("button_lock_all/text"), text)
end


---@param output_log output_list
function M:on_example_created(output_log)
	self.panel_left.on_button_click:subscribe(function(button_name)
		output_log:add_log_text("Left: Button " .. button_name)
	end)
	self.panel_right.on_button_click:subscribe(function(button_name)
		output_log:add_log_text("Right: Button " .. button_name)
	end)
	self.button_lock_all.on_click:subscribe(function()
		output_log:add_log_text(self.is_locked_all and "Example locked to Left" or "Example unlocked")
	end)
end


return M
