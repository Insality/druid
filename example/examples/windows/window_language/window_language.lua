local lang = require("lang.lang")
local druid = require("druid.druid")
local event = require("event.event")
local component = require("druid.component")
local panthera = require("panthera.panthera")

local window_animation_panthera = require("example.examples.windows.window_animation_panthera")

---@class examples.window_language: druid.component
---@field text_header druid.text
---@field button_close druid.button
---@field druid druid.instance
---@field lang_buttons table<string, druid.button>
---@field grid druid.grid
---@field on_language_change event
local M = component.create("window_language")

---Color: #F0FBFF
local DEFAULT_LANGUAGE_COLOR = vmath.vector4(240/255, 251/255, 255/255, 1.0)
---Color: #E6DF9F
local SELECTED_LANGUAGE_COLOR = vmath.vector4(230/255, 223/255, 159/255, 1.0)

---@param template string
---@param nodes table<hash, node>
function M:init(template, nodes)
	self.druid = self:get_druid(template, nodes)

	self.lang_buttons = {}
	self.created_nodes = {}
	self.prefab = self:get_node("button_prefab")
	gui.set_enabled(self.prefab, false)

	self._current_lang_id = lang.get_lang()

	self.button_close = self.druid:new_button("button_close", self.on_button_close)

	self.druid:new_lang_text("text_header", "ui_language")
	self.grid = self.druid:new_grid("content", self.prefab, 2)
	self.grid.style.IS_DYNAMIC_NODE_POSES = true

	self.animation = panthera.create_gui(window_animation_panthera, self:get_template(), self:get_nodes())
	panthera.play(self.animation, "open")

	self:load_langs()

	self.on_language_change = event.create()
end


function M:on_remove()
	for index = 1, #self.created_nodes do
		local nodes = self.created_nodes[index]
		for _, node in pairs(nodes) do
			gui.delete_node(node)
		end
	end
end


function M:load_langs()
	local languages = lang.get_langs()
	for index = 1, #languages do
		local lang_id = languages[index]

		local template = self:get_template()
		if template and template ~= "" then
			template = template .. "/"
		end
		local prefab_nodes = gui.clone_tree(self.prefab)
		local root = prefab_nodes[template .. "button_prefab"]
		local button_node = prefab_nodes[template .. "button/root"]
		local text = prefab_nodes[template .. "button/text"]

		local button = self.druid:new_button(button_node, self.on_language_button, lang_id)
		self.druid:new_lang_text(text, "ui_language_" .. lang_id)
		gui.set_enabled(root, true)
		self.grid:add(root)

		self.lang_buttons[lang_id] = button
		table.insert(self.created_nodes, prefab_nodes)
	end

	do -- Update window size to fit all languages
		local height = self.grid:get_size().y
		gui.set(self:get_node("window"), "size.y", height + 110)
		gui.set(self:get_node("panel_header"), "position.y", (height + 110)/2)
	end

	do -- Select current language button
		local current_lang_button = self.lang_buttons[self._current_lang_id]
		gui.animate(current_lang_button.node, "color", SELECTED_LANGUAGE_COLOR, gui.EASING_OUTQUAD, 0.2)
	end
end


function M:on_button_close()
	panthera.play(self.animation, "close")
end


function M:on_language_button(lang_id)
	local current_lang_button = self.lang_buttons[self._current_lang_id]
	local new_lang_button = self.lang_buttons[lang_id]

	self._current_lang_id = lang_id
	lang.set_lang(lang_id)
	druid.on_language_change()

	self.on_language_change:trigger(lang_id)

	gui.animate(current_lang_button.node, "color", DEFAULT_LANGUAGE_COLOR, gui.EASING_OUTQUAD, 0.2)
	gui.animate(new_lang_button.node, "color", SELECTED_LANGUAGE_COLOR, gui.EASING_OUTQUAD, 0.2)
end


return M
