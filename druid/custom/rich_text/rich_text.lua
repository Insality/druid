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
	[gui.PIVOT_N] = { rich_text.ALIGN_CENTER, rich_text.VALIGN_TOP },
	[gui.PIVOT_S] = { rich_text.ALIGN_CENTER, rich_text.VALIGN_BOTTOM },
	[gui.PIVOT_NE] = { rich_text.ALIGN_RIGHT, rich_text.VALIGN_TOP },
	[gui.PIVOT_E] = { rich_text.ALIGN_RIGHT, rich_text.VALIGN_MIDDLE },
	[gui.PIVOT_SE] = { rich_text.ALIGN_RIGHT, rich_text.VALIGN_BOTTOM },
	[gui.PIVOT_SW] = { rich_text.ALIGN_LEFT, rich_text.VALIGN_BOTTOM },
	[gui.PIVOT_W] = { rich_text.ALIGN_LEFT, rich_text.VALIGN_MIDDLE },
	[gui.PIVOT_NW] = { rich_text.ALIGN_LEFT, rich_text.VALIGN_TOP },
}


function RichText:init(template, nodes)
	self:set_template(template)
	self:set_nodes(nodes)
	self.root = self:get_node(SCHEME.ROOT)
	self.druid = self:get_druid()
	self.root_size = gui.get_size(self.root)

	self.text_prefab = self:get_node(SCHEME.TEXT_PREFAB)
	self.icon_prefab = self:get_node(SCHEME.ICON_PREFAB)

	gui.set_enabled(self.text_prefab, false)
	gui.set_enabled(self.icon_prefab, false)

	self._text_font = gui.get_font(self.text_prefab)
	self._settings = self:_get_settings()
end


function RichText:set_text(text)
	self:_clean_words()
	local is_already_adjusted = self._settings.adjust_scale ~= 1

	-- Make text singleline if prefab without line break
	local is_multiline = gui.get_line_break(self.text_prefab)
	if not is_multiline then
		text = string.format("<nobr>%s</nobr>", text)
	end

	local words, metrics = rich_text.create(text, self._text_font, self._settings)

	self._words = words
	self._metrics = metrics

	for _, word in ipairs(words) do
		print(word.text)
	end

	if not is_multiline then
		local scale_koef = self.root_size.x / self._metrics.width
		self._settings.adjust_scale = math.min(scale_koef, 1)
	else
		local scale_koef = math.sqrt(self.root_size.y / self._metrics.height)
		if self._metrics.width * scale_koef > self.root_size.x then
			scale_koef = math.sqrt(self.root_size.x / self._metrics.width)
		end
		self._settings.adjust_scale = math.min(scale_koef, 1)
	end

	if not is_already_adjusted and self._settings.adjust_scale < 1 then
		print("Again set text with adjusted scale", self._settings.adjust_scale)
		self:set_text(text)
		return
	end

	-- Align vertically, different behaviour from rich text
	self:_align_vertically()

	pprint(self._metrics)
end


function RichText:on_remove()
	self:_clean_words()
end


function RichText:_get_settings()
	local anchor = gui.get_pivot(self.root)
	local align = ALIGN_MAP[anchor][1]
	local valign = ALIGN_MAP[anchor][2]

	return {
		width = self.root_size.x,
		parent = self.root,
		color = gui.get_color(self.text_prefab),
		shadow = gui.get_shadow(self.text_prefab),
		outline = gui.get_outline(self.text_prefab),
		text_scale = gui.get_scale(self.text_prefab),
		default_texture = gui.get_texture(self.icon_prefab),
		default_anim = gui.get_flipbook(self.icon_prefab),
		combine_words = true,
		adjust_scale = 1,
		align = align,
		valign = valign,
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


function RichText:_align_vertically()
	local text_height = self._metrics.height
	local offset = 0
	if self._settings.valign == rich_text.VALIGN_MIDDLE then
		offset = text_height * 0.5
	end
	if self._settings.valign == rich_text.VALIGN_BOTTOM then
		offset = text_height
	end

	for _, word in ipairs(self._words) do
		word.position.y = word.position.y + offset
		gui.set_position(word.node, word.position)
	end
end


return RichText
