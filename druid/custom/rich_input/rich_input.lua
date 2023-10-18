-- Copyright (c) 2022 Maksim Tuprikov <insality@gmail.com>. This code is licensed under MIT license

--- Druid Rich Input custom component.
-- It's wrapper on Input component with cursor and placeholder text
-- @module RichInput
-- @within Input
-- @alias druid.rich_input

--- The component druid instance
-- @tfield DruidInstance druid @{DruidInstance}

--- Root node
-- @tfield node root

--- On input field text change callback(self, input_text)
-- @tfield Input input @{Input}

--- On input field text change to empty string callback(self, input_text)
-- @tfield node cursor

--- On input field text change to max length string callback(self, input_text)
-- @tfield druid.text placeholder @{Text}

---

local component = require("druid.component")

local RichInput = component.create("druid.rich_input")

local SCHEME = {
	ROOT = "root",
	BUTTON = "button",
	PLACEHOLDER = "placeholder_text",
	INPUT = "input_text",
	CURSOR = "cursor_node",
}


local function animate_cursor(self)
	gui.cancel_animation(self.cursor, gui.PROP_COLOR)
	gui.set_color(self.cursor, vmath.vector4(1))
	gui.animate(self.cursor, gui.PROP_COLOR, vmath.vector4(1,1,1,0), gui.EASING_INSINE, 0.8, 0, nil, gui.PLAYBACK_LOOP_PINGPONG)
end


local function update_text(self, text)
	local text_width = self.input.total_width
	animate_cursor(self)
	gui.set_position(self.cursor, vmath.vector3(text_width/2, 0, 0))
	gui.set_scale(self.cursor, self.input.text.scale)
end


local function on_select(self)
	gui.set_enabled(self.cursor, true)
	gui.set_enabled(self.placeholder.node, false)
	animate_cursor(self)
end


local function on_unselect(self)
	gui.set_enabled(self.cursor, false)
	gui.set_enabled(self.placeholder.node, true and #self.input:get_text() == 0)
end


--- The @{RichInput} constructor
-- @tparam RichInput self @{RichInput}
-- @tparam string template The template string name
-- @tparam table nodes Nodes table from gui.clone_tree
function RichInput.init(self, template, nodes)
	self:set_template(template)
	self:set_nodes(nodes)
	self.druid = self:get_druid()
	self.root = self:get_node(SCHEME.ROOT)

	self.input = self.druid:new_input(self:get_node(SCHEME.BUTTON), self:get_node(SCHEME.INPUT))
	self.cursor = self:get_node(SCHEME.CURSOR)

	self.input:set_text("")
	self.placeholder = self.druid:new_text(self:get_node(SCHEME.PLACEHOLDER))

	self.input.on_input_text:subscribe(update_text)
	self.input.on_input_select:subscribe(on_select)
	self.input.on_input_unselect:subscribe(on_unselect)
	on_unselect(self)
	update_text(self, "")
end


--- Set placeholder text
-- @tparam RichInput self @{RichInput}
-- @tparam string|nil placeholder_text The placeholder text
-- @treturn RichInput Current instance
function RichInput.set_placeholder(self, placeholder_text)
	self.placeholder:set_to(placeholder_text)
	return self
end


---GSet input field text
-- @tparam RichInput self @{RichInput}
-- @treturn string Current input text
function RichInput.get_text(self)
	return self.input:get_text()
end


--- Set allowed charaters for input field.
-- See: https://defold.com/ref/stable/string/
-- ex: [%a%d] for alpha and numeric
-- @tparam RichInput self @{RichInput}
-- @tparam string characters Regulax exp. for validate user input
-- @treturn RichInput Current instance
function RichInput.set_allowed_characters(self, characters)
	self.input:set_allowed_characters(characters)

	return self
end


return RichInput
