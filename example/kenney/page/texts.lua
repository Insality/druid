local lang = require("example.kenney.lang")

local M = {}

local pivots = {
	gui.PIVOT_CENTER,
	gui.PIVOT_N,
	gui.PIVOT_NE,
	gui.PIVOT_E,
	gui.PIVOT_SE,
	gui.PIVOT_S,
	gui.PIVOT_SW,
	gui.PIVOT_W,
	gui.PIVOT_NW
}

local function setup_texts(self)
	self.druid:new_text("text_inline", "Simple inline text")
	self.druid:new_text("text_multiline", "Simple multiline text with smth")
	local anchoring = self.druid:new_text("text_anchoring", "Anchoring")
	self.druid:new_text("text_no_adjust", "Without adjust size", true)
	self.druid:new_locale("text_locale", "ui_text_example")

	local big_text = "Check max size"
	local width = self.druid:new_text("text_max_width", big_text)
	local height = self.druid:new_text("text_max_height", big_text)

	local pivot_index = 1
	timer.delay(0.3, true, function()
		anchoring:set_pivot(pivots[pivot_index])

		pivot_index = pivot_index + 1
		if pivot_index > #pivots then
			pivot_index = 1
		end
	end)

	timer.delay(0.2, true, function()
		big_text = big_text .. " max"
		width:set_to(big_text)
		height:set_to(big_text)

		if #big_text > 50 then
			big_text = "Check max size"
		end
	end)
end


function M.setup_page(self)
	setup_texts(self)
end


return M
