local component = require("druid.component")
local rich_text = require("druid.custom.rich_text.module.rt")

---@class druid.rich_text.settings
---@field parent node
---@field size number
---@field fonts table<string, string>
---@field scale vector3
---@field color vector4
---@field shadow vector4
---@field outline vector4
---@field position vector3
---@field image_pixel_grid_snap boolean
---@field combine_words boolean
---@field default_animation string
---@field split_by_character boolean
---@field text_prefab node
---@field adjust_scale number
---@field default_texture string
---@field is_multiline boolean
---@field text_leading number
---@field font hash
---@field width number
---@field height number

---@class druid.rich_text.word
---@field node node
---@field relative_scale number
---@field source_text string
---@field color vector4
---@field text_color vector4
---@field position vector3
---@field offset vector3
---@field scale vector3
---@field size vector3
---@field metrics druid.rich_text.metrics
---@field pivot constant
---@field text string
---@field shadow vector4
---@field outline vector4
---@field font string
---@field image druid.rich_text.word.image
---@field br boolean
---@field nobr boolean
---@field tags table<string, boolean>

---@class druid.rich_text.word.image
---@field texture string
---@field anim string
---@field width number
---@field height number

---@class druid.rich_text.style
---@field ADJUST_STEPS number
---@field ADJUST_SCALE_DELTA number

---@class druid.rich_text.lines_metrics
---@field text_width number
---@field text_height number
---@field lines table<number, druid.rich_text.metrics>

---@class druid.rich_text.metrics
---@field width number
---@field height number
---@field offset_x number|nil
---@field offset_y number|nil
---@field node_size vector3|nil

---The component that handles a rich text display, allows to custom color, size, font, etc. of the parts of the text
---@class druid.rich_text: druid.component
---@field root node The root text node of the rich text
---@field text_prefab node The text prefab node
---@field private _last_value string The last value of the rich text
---@field private _settings table The settings of the rich text
local M = component.create("rich_text")


---@param text_node node|string The text node to make Rich Text
---@param value string|nil The initial text value. Default will be gui.get_text(text_node)
function M:init(text_node, value)
	self.root = self:get_node(text_node)
	self.text_prefab = self.root

	self._last_value = value or gui.get_text(self.text_prefab)
	self._settings = self:_create_settings()

	gui.set_text(self.root, "")

	if value then
		self:set_text(value)
	end
end


---@private
function M:on_layout_change()
	if self._last_value then
		self:set_text(self._last_value)
	end
end


---@private
---@param style druid.rich_text.style
function M:on_style_change(style)
	self.style = {
		ADJUST_STEPS = style.ADJUST_STEPS or 20,
		ADJUST_SCALE_DELTA = style.ADJUST_SCALE_DELTA or 0.02,
	}
end


---Set text for Rich Text
---		-- Color
---		rich_text:set_text("＜color=red＞Foobar＜/color＞")
---		rich_text:set_text("＜color=1.0,0,0,1.0＞Foobar＜/color＞")
---		rich_text:set_text("＜color=#ff0000＞Foobar＜/color＞")
---		rich_text:set_text("＜color=#ff0000ff＞Foobar＜/color＞")
---		-- Shadow
---		rich_text:set_text("＜shadow=red＞Foobar＜/shadow＞")
---		rich_text:set_text("＜shadow=1.0,0,0,1.0＞Foobar＜/shadow＞")
---		rich_text:set_text("＜shadow=#ff0000＞Foobar＜/shadow＞")
---		rich_text:set_text("＜shadow=#ff0000ff＞Foobar＜/shadow＞")
---		-- Outline
---		rich_text:set_text("＜outline=red＞Foobar＜/outline＞")
---		rich_text:set_text("＜outline=1.0,0,0,1.0＞Foobar＜/outline＞")
---		rich_text:set_text("＜outline=#ff0000＞Foobar＜/outline＞")
---		rich_text:set_text("＜outline=#ff0000ff＞Foobar＜/outline＞")
---		-- Font
---		rich_text:set_text("＜font=MyCoolFont＞Foobar＜/font＞")
---		-- Size
---		rich_text:set_text("＜size=2＞Twice as large＜/size＞")
---		-- Line break
---		rich_text:set_text("＜br/＞Insert a line break")
---		-- No break
---		rich_text:set_text("＜nobr＞Prevent the text from breaking")
---		-- Image
---		rich_text:set_text("＜img=texture:image＞Display image")
---		rich_text:set_text("＜img=texture:image,size＞Display image with size")
---		rich_text:set_text("＜img=texture:image,width,height＞Display image with width and height")
---@param text string|nil The text to set
---@return druid.rich_text.word[] words
---@return druid.rich_text.lines_metrics line_metrics
function M:set_text(text)
	text = text or ""
	self:clear()
	self._last_value = text

	local words, settings, line_metrics = rich_text.create(text, self._settings, self.style)
	line_metrics = rich_text.adjust_to_area(words, settings, line_metrics, self.style)

	self._words = words
	self._line_metrics = line_metrics

	return words, line_metrics
end


---Get the current text of the rich text
---@return string text The current text of the rich text
function M:get_text()
	return self._last_value
end


---@private
function M:on_remove()
	gui.set_scale(self.root, self._default_scale)
	gui.set_size(self.root, self._default_size)
	self:clear()
end


---Clear all created words.
function M:clear()
	if self._words then
		rich_text.remove(self._words)
		self._words = nil
	end
	self._last_value = nil
end


---Get all words, which has a passed tag.
---@param tag string The tag to get the words for
---@return druid.rich_text.word[] words The words with the passed tag
function M:tagged(tag)
	if not self._words then
		return {}
	end

	return rich_text.tagged(self._words, tag)
end


---Set if the rich text should split to characters, not words
---@param value boolean
---@return druid.rich_text self
function M:set_split_to_characters(value)
	self._settings.split_to_characters = value
	return self
end


---Get all current created words, each word is a table that contains the information about the word
---@return druid.rich_text.word[]
function M:get_words()
	return self._words
end


---Get the current line metrics
---@return druid.rich_text.lines_metrics lines_metrics The line metrics of the rich text
function M:get_line_metric()
	return self._line_metrics
end


---@private
---@return table settings The settings of the rich text, they are created based on the root node on the GUI scene
function M:_create_settings()
	local root_size = gui.get_size(self.root)
	local scale = gui.get_scale(self.root)

	self._default_size = root_size
	self._default_scale = scale

	root_size.x = root_size.x * scale.x
	root_size.y = root_size.y * scale.y
	gui.set_size(self.root, root_size)
	gui.set_scale(self.root, vmath.vector3(1))

	return {
		-- General settings
		-- Adjust scale using to fit the text to the root node area
		adjust_scale = 1,
		parent = self.root,
		scale = scale,
		width = root_size.x,
		height = root_size.y,
		combine_words = false, -- disabled now
		text_prefab = self.text_prefab,
		pivot = gui.get_pivot(self.root),

		-- Text Settings
		shadow = gui.get_shadow(self.root),
		outline = gui.get_outline(self.root),
		text_leading = gui.get_leading(self.root),
		is_multiline = gui.get_line_break(self.root),
		split_to_characters = false,

		-- Image settings
		image_pixel_grid_snap = false, -- disabled now
	}
end


---Set the width of the rich text, not affects the size of current spawned words
---@param width number
function M:set_width(width)
	self._settings.width = width
end


---Set the height of the rich text, not affects the size of current spawned words
---@param height number
function M:set_height(height)
	self._settings.height = height
end


return M
