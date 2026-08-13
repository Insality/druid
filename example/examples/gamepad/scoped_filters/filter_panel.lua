local event = require("event.event")

---A panel with two buttons and its own input filter.
---The filter is set on `self.druid`, so it covers this panel subtree only
---and never touches the buttons of the neighbor panel.
---@class examples.filter_panel: druid.widget
---@field button_a druid.button
---@field button_b druid.button
---@field button_lock druid.button
---@field on_button_click event fun(button_name: string)
local M = {}


function M:init()
	self.title = self:get_node("title")
	self.status = self:get_node("status")
	self.on_button_click = event.create()

	self.button_a = self.druid:new_button("button_a/root", function()
		self.on_button_click:trigger("A")
	end)
	self.button_b = self.druid:new_button("button_b/root", function()
		self.on_button_click:trigger("B")
	end)

	-- Keep the lock button in the whitelist, otherwise it cannot unlock the panel
	self.button_lock = self.druid:new_button("button_lock/root", self.toggle_lock)

	self.is_locked = false
end


---@param title string
function M:set_title(title)
	gui.set_text(self.title, title)
	return self
end


function M:toggle_lock()
	self.is_locked = not self.is_locked

	if self.is_locked then
		self.druid:set_whitelist({ self.button_a, self.button_lock })
	else
		self.druid:set_whitelist(nil)
	end

	gui.set_text(self:get_node("button_lock/text"), self.is_locked and "Unlock" or "Lock to A")
	gui.set_text(self.status, self.is_locked and "Filter: only A" or "Filter: none")
end


return M
