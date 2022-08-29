--- For component interest functions
--- see https://github.com/Insality/druid/blob/develop/docs_md/02-creating_custom_components.md
--- Require this component in you gui file:
--- local ButtonComponent = require("example.examples.data_list.with_component.button_component.button_component")
--- And create this component via:
--- self.button_component = self.druid:new(ButtonComponent, template, nodes)

local Event = require("druid.event")
local component = require("druid.component")

---@class button_component: druid.base_component
---@field root node
---@field text druid.text
---@field druid druid_instance
local ButtonComponent = component.create("button_component")

local SCHEME = {
	ROOT = "root",
	TEXT = "text",
	ICON = "icon",
	CHECKBOX = "checkbox"
}


---@param template string
---@param nodes table<hash, node>
function ButtonComponent:init(template, nodes)
	self:set_template(template)
	self:set_nodes(nodes)
	self.druid = self:get_druid()

	self.root = self:get_node(SCHEME.ROOT)
	self.text = self.druid:new_text(SCHEME.TEXT)
	self.checkbox = self:get_node(SCHEME.CHECKBOX)

	self.button = self.druid:new_button(self.root, self._on_click)

	self.on_click = Event()
end


function ButtonComponent:set_data(data)
	self._data = data
	self.text:set_to("Element: " .. data.value)
	self:set_checked(self._data.is_checked)
end


function ButtonComponent:get_data()
	return self._data
end


function ButtonComponent:set_checked(state)
	self._data.is_checked = state
	gui.set_enabled(self.checkbox, state)
end


function ButtonComponent:set_click_zone(node)
	self.button:set_click_zone(node)
end


function ButtonComponent:on_remove()
	self.on_click:clear()
end


function ButtonComponent:_on_click()
	self.on_click:trigger(self)
end



return ButtonComponent
