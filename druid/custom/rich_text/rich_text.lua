-- Copyright (c) 2022 Maksim Tuprikov <insality@gmail.com>. This code is licensed under MIT license

--- Druid Rich Text custom component.
-- <b># Overview #</b>
--
-- Heavily inspired by <a href="https://github.com/britzl/defold-richtext" target="_blank">https://github.com/britzl/defold-richtext</a>.
--
-- Uses the same syntax for tags, but currently have less tags support.
--
-- All Rich Text params are adjusted in GUI scene
--
-- The Rich Text template should have next scheme:
--
-- root
--
-- 	- text_prefab
--
-- 	- icon_prefab
--
-- <b># Rich Text Setup #</b>
-- • Root node size - maximum width and height of the text
-- • Root anchor - Aligment of the Rich Text inside root node size area
-- • Text prefab - all text params for the text node
-- • Text prefab anchor - Anchor for each text node (you should adjust this only if animate text)
-- • Icon prefab - all node params for the icon node
-- • Icon prefab anchor - Anchor for each icon node (you should adjust this only if animate icon)
--
-- <b># Notes #</b>
--
-- • Nested tags are supported
--
-- @usage
-- local RichText = require("druid.custom.rich_text.rich_text")
-- ...
-- self.rich_text = self.druid:new(RichText, "rich_text")
-- self.rich_text:set_text("Hello, Druid Rich Text!")
--
-- @module RichText
-- @within BaseComponent
-- @alias druid.rich_text

--- The component druid instance
-- @tfield DruidInstance druid @{DruidInstance}


local component = require("druid.component")
local rich_text = require("druid.custom.rich_text.module.rt")

local RichText = component.create("rich_text")

local SCHEME = {
	ROOT = "root",
	TEXT_PREFAB = "text_prefab",
	ICON_PREFAB = "icon_prefab"
}


--- Rich Text component constructor
-- @tparam RichText self @{RichText}
-- @tparam string template The Rich Text template name
-- @tparam table nodes The node table, if prefab was copied by gui.clone_tree()
function RichText.init(self, template, nodes)
	self:set_template(template)
	self:set_nodes(nodes)

	self.root = self:get_node(SCHEME.ROOT)
	self.druid = self:get_druid()

	self.text_prefab = self:get_node(SCHEME.TEXT_PREFAB)
	self.icon_prefab = self:get_node(SCHEME.ICON_PREFAB)

	gui.set_enabled(self.text_prefab, false)
	gui.set_enabled(self.icon_prefab, false)

	self._settings = self:_create_settings()
end


--- Set text for Rich Text
-- @tparam RichText self @{RichText}
-- @tparam string text The text to set
-- @treturn table words
-- @treturn table line_metrics
-- @usage
-- • color: Change text color
--
-- <color=red>Foobar</color>
-- <color=1.0,0,0,1.0>Foobar</color>
-- <color=#ff0000>Foobar</color>
-- <color=#ff0000ff>Foobar</color>
--
-- • shadow: Change text shadow
--
-- <shadow=red>Foobar</shadow>
-- <shadow=1.0,0,0,1.0>Foobar</shadow>
-- <shadow=#ff0000>Foobar</shadow>
-- <shadow=#ff0000ff>Foobar</shadow>
--
-- • outline: Change text shadow
--
-- <outline=red>Foobar</outline>
-- <outline=1.0,0,0,1.0>Foobar</outline>
-- <outline=#ff0000>Foobar</outline>
-- <outline=#ff0000ff>Foobar</outline>
--
-- • font: Change font
--
-- <font=MyCoolFont>Foobar</font>
--
-- • size: Change text size, relative to default size
--
-- <size=2>Twice as large</size>
--
-- • br: Insert a line break
--
-- <br/>
--
-- • nobr: Prevent the text from breaking
--
-- Words <nobr>inside tag</nobr> won't break
--
-- • img: Display image
--
-- <img=texture:image/>
-- <img=texture:image,size/>
-- <img=texture:image,width,height/>
function RichText.set_text(self, text)
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


--- Get all words, which has a passed tag
-- @tparam string tag
-- @treturn table Words
function RichText:tagged(tag)
	if not self._words then
		return
	end

	return rich_text.tagged(self._words, tag)
end


--- Get all current words.
-- @treturn table Words
function RichText:get_words()
	return self._words
end


function RichText:_create_settings()
	local root_size = gui.get_size(self.root)
	return {
		-- General settings
		-- Adjust scale using to fit the text to the root node area
		adjust_scale = 1,
		parent = self.root,
		width = root_size.x,
		height = root_size.y,
		combine_words = false,
		text_prefab = self.text_prefab,
		node_prefab = self.icon_prefab,

		-- Text Settings
		shadow = gui.get_shadow(self.text_prefab),
		outline = gui.get_outline(self.text_prefab),
		text_scale = gui.get_scale(self.text_prefab),
		text_leading = gui.get_leading(self.text_prefab),
		is_multiline = gui.get_line_break(self.text_prefab),

		-- Image settings
		image_pixel_grid_snap = false,
		node_scale = gui.get_scale(self.icon_prefab),
		image_scale = gui.get_scale(self.icon_prefab),
		default_animation = gui.get_flipbook(self.icon_prefab),
	}
end


--- Clear all created words.
function RichText:clean()
	if self._words then
		rich_text.remove(self._words)
		self._words = nil
	end
end


return RichText
