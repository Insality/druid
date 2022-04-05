-- Copyright (c) 2021 Maksim Tuprikov <insality@gmail.com>. This code is licensed under MIT license

--- Layout management on node
-- @module Layout
-- @within BaseComponent
-- @alias druid.layout

---


local const = require("druid.const")
local helper = require("druid.helper")
local component = require("druid.component")
local Event = require("druid.event")

---@class layout : druid.base_component
local Layout = component.create("layout")


function Layout:init(node, mode, on_size_changed_callback)
    self.node = self:get_node(node)
    self.origin_size = gui.get_size(self.node)
    self.pivot = helper.get_pivot_offset(gui.get_pivot(self.node))
    self.origin_position = gui.get_position(self.node)
    self.position = vmath.vector3(self.origin_position)

    gui.set_size_mode(self.node, gui.SIZE_MODE_MANUAL)
    gui.set_adjust_mode(self.node, gui.ADJUST_FIT)

    self._min_size = nil
    self._max_size = nil

    self.window_size = vmath.vector3(gui.get_width(), gui.get_height(), 0)
    self.mode = mode or const.LAYOUT_MODE.FIT

    self.on_size_changed = Event(on_size_changed_callback)

    self:on_window_resized()
end


function Layout:on_window_resized()
    local window_x, window_y = window.get_size()
    local stretch_x = window_x / self.window_size.x
    local stretch_y = window_y / self.window_size.y

    local x_koef = stretch_x / math.min(stretch_x, stretch_y)
    local y_koef = stretch_y / math.min(stretch_x, stretch_y)

    local new_size = vmath.vector3(self.origin_size)
    if self.mode == const.LAYOUT_MODE.STRETCH_X or self.mode == const.LAYOUT_MODE.STRETCH then
        new_size.x = new_size.x * x_koef
    end
    if self.mode == const.LAYOUT_MODE.STRETCH_Y or self.mode == const.LAYOUT_MODE.STRETCH then
        new_size.y = new_size.y * y_koef
    end
    if self._min_size then
        new_size.x = math.max(new_size.x, self._min_size.x)
        new_size.y = math.max(new_size.y, self._min_size.y)
    end
    if self._max_size then
        new_size.x = math.min(new_size.x, self._max_size.x)
        new_size.y = math.min(new_size.y, self._max_size.y)
    end

    gui.set_size(self.node, new_size)

    self.position.x = self.origin_position.x * x_koef + self.origin_position.x * (1 - x_koef) * self.pivot.x * 2
    self.position.y = self.origin_position.y * y_koef + self.origin_position.y * (1 - y_koef) * self.pivot.y * 2
    gui.set_position(self.node, self.position)

    self.on_size_changed:trigger(self:get_context(), new_size)
end


function Layout:set_min_size(min_size)
    self._min_size = min_size
    return self
end


function Layout:set_max_size(max_size)
    self._max_size = max_size
    return self
end


function Layout:set_origin_position(new_origin_position)
    self.origin_position = new_origin_position or self.origin_position
    return self
end


function Layout:set_origin_size(new_origin_size)
    self.origin_size = new_origin_size or self.origin_size
    return self
end


return Layout
