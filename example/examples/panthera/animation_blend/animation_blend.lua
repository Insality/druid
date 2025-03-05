local panthera = require("panthera.panthera")
local component = require("druid.component")
local helper = require("druid.helper")
local event = require("event.event")

local character_animation_blend = require("example.examples.panthera.animation_blend.character_animation_blend")

---@class animation_blend: druid.component
---@field root node
---@field druid druid.instance
local M = component.create("animation_blend")


---@param template string
---@param nodes table<hash, node>
function M:init(template, nodes)
	self.druid = self:get_druid(template, nodes)

	self.root = self:get_node("root")
	self.root_size = gui.get_size(self.root)
	self.druid:new_lang_text("text_hint", "ui_example_panthera_animation_blend_hint")

	self.animation_idle = panthera.create_gui(character_animation_blend, self:get_template(), nodes)
	self.animation_vertical = panthera.create_gui(character_animation_blend, self:get_template(), nodes)
	self.animation_horizontal = panthera.create_gui(character_animation_blend, self:get_template(), nodes)

	panthera.play(self.animation_idle, "idle", {
		is_loop = true,
	})

	self:setup_rich_text()
	self.on_update = event.create()
end


---@param action_id hash
---@param action action
function M:on_input(action_id, action)
	if action_id == nil and gui.pick_node(self.root, action.x, action.y) then
		local root_screen_pos = gui.get_screen_position(self.root)
		local gui_scale = helper.get_gui_scale()

		local dx = (action.screen_x - root_screen_pos.x) / gui_scale -- -root_size.x / 2 .. root_size.x / 2
		local animation_progress_x = (dx + self.root_size.x / 2) / self.root_size.x -- 0 .. 1
		panthera.set_time(self.animation_horizontal, "horizontal", animation_progress_x)

		local dy = (action.screen_y - root_screen_pos.y) / gui_scale -- -root_size.y / 2 .. root_size.y / 2
		local animation_progress_y = (dy + self.root_size.y / 2) / self.root_size.y -- 0 .. 1
		panthera.set_time(self.animation_vertical, "vertical", animation_progress_y)
	end
end


function M:update()
	self.on_update:trigger()
end


function M:setup_rich_text()
	self.rich_text = self.druid:new_rich_text("rich_text_kenney", "Character assets by <color=865BD9><link>Kenney</link></color>")

	local tagged = self.rich_text:tagged("link")
	for index = 1, #tagged do
		---@type druid.rich_text.word
		local word = tagged[index]
		self.druid:new_button(word.node, function()
			sys.open_url("https://kenney.nl/")
		end)
	end
end


return M
