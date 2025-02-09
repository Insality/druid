local lang = require("lang.lang")
local component = require("druid.component")

---@class panel_information: druid.base_component
---@field root druid.container
---@field text_header druid.lang_text
---@field rich_text druid.rich_text
---@field druid druid_instance
local PanelInformation = component.create("panel_information")

---@param template string
---@param nodes table<hash, node>
function PanelInformation:init(template, nodes)
	self.druid = self:get_druid(template, nodes)

	self.root = self.druid:new_container("root") --[[@as druid.container]]
	self.root:add_container("text_header")
	self.root:add_container("scroll_view")
	self.root:add_container("S_Anchor")
	self.root:add_container("NE_Anchor")

	self.druid:new_lang_text("text_header", "ui_information")
	self.druid:new_lang_text("button_profiler/text", "ui_profiler")

	--self.text_description = self.druid:new_lang_text("text_description", "") --[[@as druid.lang_text]]
	self.rich_text = self.druid:new_rich_text("text_description")
	self.button_profiler = self.druid:new_button("button_profiler/root", self.on_profiler_click)
	self.button_profiler:set_key_trigger("key_p")
	self.button_view_code = self.druid:new_button("button_view_code/root")

	-- Disable profiler button for HTML5
	gui.set_enabled(self.button_profiler.node, not html5)
end


function PanelInformation:set_text(text_id)
	local text = lang.txt(text_id)
	self.rich_text:set_text(text)
end


function PanelInformation:on_profiler_click()
	if self._profiler_mode == nil then
		self._profiler_mode = profiler.VIEW_MODE_MINIMIZED
		profiler.enable_ui(true)
		profiler.set_ui_view_mode(self._profiler_mode)
	elseif self._profiler_mode == profiler.VIEW_MODE_MINIMIZED then
		self._profiler_mode = profiler.VIEW_MODE_FULL
		profiler.enable_ui(true)
		profiler.set_ui_view_mode(self._profiler_mode)
	else
		self._profiler_mode = nil
		profiler.enable_ui(false)
	end
end


return PanelInformation
