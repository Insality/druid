---@class examples.rich_text_split_animated: druid.widget
---@field rich_text druid.rich_text
local M = {}

local OFFSET = 20

function M:init()
	self.rich_text = self.druid:new_rich_text("text")
	self.rich_text:set_split_to_characters(true)
	self.rich_text:set_text("<color=#E48155>Hello</color> <color=#A1D7F5>World</color>!")

	self:_animate_letters()
end


function M:_animate_letters()
	local words = self.rich_text:get_words()
	if not words then
		return
	end

	for i = 1, #words do
		local word = words[i]
		if word.node and not word.image then
			gui.animate(word.node, "position.y", word.position.y + OFFSET, gui.EASING_INOUTQUAD, 1, (i - 1) * 0.09, nil, gui.PLAYBACK_LOOP_PINGPONG)
		end
	end
end


return M
