---@class examples.whitelist_blacklist: druid.widget
---@field button_a druid.button
---@field button_b druid.button
local M = {}


function M:init()
	self.status = self:get_node("status")

	self.button_a = self.druid:new_button("button_a/root", function()
		print("Button A")
	end)
	self.button_b = self.druid:new_button("button_b/root", function()
		print("Button B")
	end)

	-- The filters are set from `self.druid`, so they affect this widget subtree only
	self.btn_whitelist = self.druid:new_button("btn_whitelist/root", self.on_whitelist_a)
	self.btn_blacklist = self.druid:new_button("btn_blacklist/root", self.on_blacklist_a)
	self.btn_clear = self.druid:new_button("btn_clear/root", self.on_clear_filter)
end


function M:on_whitelist_a()
	self.druid:set_blacklist(nil)
	-- Include filter buttons, otherwise the widget would lock itself
	self.druid:set_whitelist({
		self.button_a,
		self.btn_whitelist,
		self.btn_blacklist,
		self.btn_clear,
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
	self.btn_whitelist.on_click:subscribe(function()
		output_log:add_log_text("Whitelist A")
	end)
	self.btn_blacklist.on_click:subscribe(function()
		output_log:add_log_text("Blacklist A")
	end)
	self.btn_clear.on_click:subscribe(function()
		output_log:add_log_text("Filter Cleared")
	end)
end


return M
