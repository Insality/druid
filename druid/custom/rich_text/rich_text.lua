local component = require("druid.component")
local rich_text = require("druid.custom.rich_text.rich_text.richtext")

---@class druid.rich_text
local RichText = component.create("rich_text")

local SCHEME = {
	ROOT = "root",
	TEXT_PREFAB = "text_prefab",
	ICON_PREFAB = "icon_prefab"
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

	self._settings = self:_get_settings()
end


---@return rich_text.word[], rich_text.lines_metrics
function RichText:set_text(text)
	self:clean()

	local words, settings, line_metrics = rich_text.create(text, self._settings)
	line_metrics = rich_text.adjust_to_area(words, settings, line_metrics)

	self._words = words
	self._line_metrics = line_metrics

	return words, line_metrics
end


function RichText:on_remove()
	self:clean()
end


function RichText:tagged(tag)
	if not self._words then
		return
	end

	return rich_text.tagged(self._words, tag)
end


---@return druid.rich_text_word[]
function RichText:get_words()
	return self._words
end


function RichText:_get_settings()
	return {
		width = self.root_size.x,
		parent = self.root,
		text_prefab = self.text_prefab,
		node_prefab = self.icon_prefab,
		shadow = gui.get_shadow(self.text_prefab),
		outline = gui.get_outline(self.text_prefab),
		size = gui.get_scale(self.text_prefab).x,
		image_scale = gui.get_scale(self.icon_prefab),
		default_animation = gui.get_flipbook(self.icon_prefab),
	}
end


function RichText:clean()
	if not self._words then
		return
	end

	rich_text.remove(self._words)
	self._words = nil
end


return RichText
