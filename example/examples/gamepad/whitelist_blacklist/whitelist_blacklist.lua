---@class examples.whitelist_blacklist: druid.widget
---@field button_a druid.button
---@field button_b druid.button
---@field button_whitelist druid.button
---@field button_blacklist druid.button
---@field button_clear druid.button
---@field status node
local M = {}


function M:init()
	self.status = self:get_node("status")

	self.button_a = self.druid:new_button("button_a/root")
	self.button_b = self.druid:new_button("button_b/root")

	-- The filters are set from `self.druid`, so they affect this widget subtree only
	self.button_whitelist = self.druid:new_button("button_whitelist/root", self.on_whitelist_a)
	self.button_blacklist = self.druid:new_button("button_blacklist/root", self.on_blacklist_a)
	self.button_clear = self.druid:new_button("button_clear/root", self.on_clear_filter)

	self.druid:new_lang_text("button_whitelist/text", "ui_whitelist_a")
	self.druid:new_lang_text("button_blacklist/text", "ui_blacklist_a")
	self.druid:new_lang_text("button_clear/text", "ui_clear_filters")
end


function M:on_whitelist_a()
	self.druid:set_blacklist(nil)
	-- Include filter buttons, otherwise they cannot change the filter while it is on
	self.druid:set_whitelist({
		self.button_a,
		self.button_whitelist,
		self.button_blacklist,
		self.button_clear,
	})
	gui.set_text(self.status, "Filter: whitelist A (+ controls)")
end


function M:on_blacklist_a()
	self.druid:set_whitelist(nil)
	self.druid:set_blacklist({ self.button_a })
	gui.set_text(self.status, "Filter: blacklist A")
end


function M:on_clear_filter()
	self.druid:set_whitelist(nil)
	self.druid:set_blacklist(nil)
	gui.set_text(self.status, "Filter: none")
end


---@param output_log output_list
function M:on_example_created(output_log)
	self.button_a.on_click:subscribe(function()
		output_log:add_log_text("Button A Clicked")
	end)
	self.button_b.on_click:subscribe(function()
		output_log:add_log_text("Button B Clicked")
	end)
	self.button_whitelist.on_click:subscribe(function()
		output_log:add_log_text("Whitelist A")
	end)
	self.button_blacklist.on_click:subscribe(function()
		output_log:add_log_text("Blacklist A")
	end)
	self.button_clear.on_click:subscribe(function()
		output_log:add_log_text("Filter Cleared")
	end)
end


return M
