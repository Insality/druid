local component = require("druid.component")
local helper = require("druid.helper")
local event = require("event.event")

---@class rich_text_tags_custom: druid.component
---@field druid druid.instance
---@field rich_text druid.rich_text
local M = component.create("rich_text_tags_custom")


---@param template string
---@param nodes table<hash, node>
function M:init(template, nodes)
	self.druid = self:get_druid(template, nodes)

	do -- Init rich text with links example
		self.rich_text_link = self.druid:new_rich_text("rich_text_link") --[[@as druid.rich_text]]
		self.rich_text_link:set_text("Hello, I'm a <custom_link><color=A1D7F5>Custom Link</color></custom_link>")

		local tagged = self.rich_text_link:tagged("custom_link")
		for index = 1, #tagged do
			local word = tagged[index]
			self.druid:new_button(word.node, function()
				self.on_link_click:trigger(word.text)
			end)
		end
	end

	self.rich_text_characters = self.druid:new_rich_text("rich_text_characters") --[[@as druid.rich_text]]
	self.rich_text_characters:set_text("Hello, I'm a have a splitted characters")

	self.rich_text_custom = self.druid:new_rich_text("rich_text_custom") --[[@as druid.rich_text]]
	self.rich_text_custom:set_text("Hello, I'm have <size=1.25><font=text_bold>South Text Pivot</font></size> to adjust <size=0.75><font=text_bold>different text scale</font></size>")

	self.position = {
		[self.rich_text_link] = gui.get_position(self.rich_text_link.root),
		[self.rich_text_characters] = gui.get_position(self.rich_text_characters.root),
		[self.rich_text_custom] = gui.get_position(self.rich_text_custom.root),
	}

	self.on_link_click = event.create()
end


function M:set_pivot(pivot)
	local pivot_offset = helper.get_pivot_offset(pivot)
	local rich_texts = {
		self.rich_text_link,
		self.rich_text_characters,
		self.rich_text_custom,
	}

	for _, rich_text in ipairs(rich_texts) do
		gui.set_pivot(rich_text.root, pivot)
		local pos = self.position[rich_text]
		local size_x = gui.get(rich_text.root, "size.x")
		local size_y = gui.get(rich_text.root, "size.y")
		local offset_x = size_x * pivot_offset.x
		local offset_y = size_y * pivot_offset.y
		gui.set_position(rich_text.root, vmath.vector3(pos.x + offset_x, pos.y + offset_y, pos.z))
		rich_text:set_text(rich_text:get_text())
	end
end


return M
