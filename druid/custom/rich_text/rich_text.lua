local component = require("druid.component")
local rich_text = require("druid.custom.rich_text.rich_text.richtext")

local RichText = component.create("rich_text")

local SCHEME = {
	ROOT = "root",
	TEXT_PREFAB = "text_prefab",
	ICON_PREFAB = "icon_prefab"
}


local ALIGN_MAP = {
	[gui.PIVOT_CENTER] = { rich_text.ALIGN_CENTER, rich_text.VALIGN_MIDDLE },
	[gui.PIVOT_N] =  { rich_text.ALIGN_CENTER, rich_text.VALIGN_TOP },
	[gui.PIVOT_S] =  { rich_text.ALIGN_CENTER, rich_text.VALIGN_BOTTOM },
	[gui.PIVOT_NE] =  { rich_text.ALIGN_RIGHT, rich_text.VALIGN_TOP },
	[gui.PIVOT_E] =  { rich_text.ALIGN_RIGHT, rich_text.VALIGN_MIDDLE },
	[gui.PIVOT_SE] =  { rich_text.ALIGN_RIGHT, rich_text.VALIGN_BOTTOM },
	[gui.PIVOT_SW] =  { rich_text.ALIGN_LEFT, rich_text.VALIGN_BOTTOM },
	[gui.PIVOT_W] =  { rich_text.ALIGN_LEFT, rich_text.VALIGN_MIDDLE },
	[gui.PIVOT_NW] =  { rich_text.ALIGN_LEFT, rich_text.VALIGN_TOP },
}


function RichText:init(template, nodes)
	self:set_template(template)
	self:set_nodes(nodes)
	self.root = self:get_node(SCHEME.ROOT)
	self.druid = self:get_druid()

	self.text_prefab = self:get_node(SCHEME.TEXT_PREFAB)
	self.icon_prefab = self:get_node(SCHEME.ICON_PREFAB)

	gui.set_enabled(self.text_prefab, false)
	gui.set_enabled(self.icon_prefab, false)

	self._text_font = gui.get_font(self.text_prefab)
	self._settings = self:_get_settings()
end


function RichText:set_text(text)
	self:_clean_words()
	pprint(self._settings)
	local words, metrics = rich_text.create(text, self._text_font, self._settings)

	self._words = words
	self._metrics = metrics
end


function RichText:on_remove()
	self:_clean_words()
end


function RichText:_get_settings()
	local root_size = gui.get_size(self.root)
	local anchor = gui.get_pivot(self.root)
	pprint(ALIGN_MAP[anchor])
	return {
		width = root_size.x,
		parent = self.root,
		color = gui.get_color(self.text_prefab),
		shadow = gui.get_shadow(self.text_prefab),
		outline = gui.get_outline(self.text_prefab),
		align = ALIGN_MAP[anchor][1],
		valign = ALIGN_MAP[anchor][2],
	}
end


function RichText:_clean_words()
	if not self._words then
		return
	end

	rich_text.remove(self._words)
	self._words = nil
	self._metrics = nil
end


return RichText
