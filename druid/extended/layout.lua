-- Copyright (c) 2021 Maksim Tuprikov <insality@gmail.com>. This code is licensed under MIT license

--- Layout management on node
--
-- <a href="https://insality.github.io/druid/druid/index.html?example=general_layout" target="_blank"><b>Example Link</b></a>
-- @module Layout
-- @within BaseComponent
-- @alias druid.layout

--- Layout node
-- @tfield node node

--- Current layout mode
-- @tfield string mode

---On window resize callback(self, new_size)
-- @tfield DruidEvent on_size_changed @{DruidEvent}

---


local const = require("druid.const")
local helper = require("druid.helper")
local component = require("druid.component")
local Event = require("druid.event")


local Layout = component.create("layout")


--- The @{Layout} constructor
-- @tparam Layout self @{Layout}
-- @tparam node node Gui node
-- @tparam string mode The layout mode (from const.LAYOUT_MODE)
-- @tparam function|nil on_size_changed_callback The callback on window resize
function Layout.init(self, node, mode, on_size_changed_callback)
	self.node = self:get_node(node)

	self._min_size = nil
	self._max_size = nil
	self._current_size = vmath.vector3(0)
	self._inited = false
	self._max_gui_upscale = nil
	self._fit_node = nil

	self._anchors = {}

	self.mode = mode or const.LAYOUT_MODE.FIT

	self.on_size_changed = Event(on_size_changed_callback)
end


function Layout.on_late_init(self)
	self._inited = true
	self.origin_size = self.origin_size or gui.get_size(self.node)
	self.fit_size = self.fit_size or vmath.vector3(self.origin_size)
	self.pivot = helper.get_pivot_offset(gui.get_pivot(self.node))
	self.origin_position = gui.get_position(self.node)
	self.position = vmath.vector3(self.origin_position)
	gui.set_size_mode(self.node, gui.SIZE_MODE_MANUAL)
	gui.set_adjust_mode(self.node, gui.ADJUST_FIT)
	self:on_window_resized()
end


function Layout.on_window_resized(self)
	if not self._inited then
		return
	end

	local x_koef, y_koef = helper.get_screen_aspect_koef()

	local revert_scale = 1
	if self._max_gui_upscale then
		revert_scale = self._max_gui_upscale / helper.get_gui_scale()
		revert_scale = math.min(revert_scale, 1)
	end
	gui.set_scale(self.node, vmath.vector3(revert_scale))

	if self._fit_node then
		self.fit_size = gui.get_size(self._fit_node)
		self.fit_size.x = self.fit_size.x / x_koef
		self.fit_size.y = self.fit_size.y / y_koef
	end

	x_koef = self.fit_size.x / self.origin_size.x * x_koef
	y_koef = self.fit_size.y / self.origin_size.y * y_koef

	local new_size = vmath.vector3(self.origin_size)

	if self.mode == const.LAYOUT_MODE.STRETCH then
		new_size.x = new_size.x * x_koef / revert_scale
		new_size.y = new_size.y * y_koef / revert_scale
	end

	if self.mode == const.LAYOUT_MODE.STRETCH_X then
		new_size.x = new_size.x * x_koef / revert_scale
	end

	if self.mode == const.LAYOUT_MODE.STRETCH_Y then
		new_size.y = new_size.y * y_koef / revert_scale
	end

	-- Fit to the stretched container (node size or other defined)
	if self.mode == const.LAYOUT_MODE.ZOOM_MIN then
		new_size = new_size * math.min(x_koef, y_koef)
	end
	if self.mode == const.LAYOUT_MODE.ZOOM_MAX then
		new_size = new_size * math.max(x_koef, y_koef)
	end

	if self._min_size then
		new_size.x = math.max(new_size.x, self._min_size.x)
		new_size.y = math.max(new_size.y, self._min_size.y)
	end
	if self._max_size then
		new_size.x = math.min(new_size.x, self._max_size.x)
		new_size.y = math.min(new_size.y, self._max_size.y)
	end
	self._current_size = new_size
	gui.set_size(self.node, new_size)

	self.position.x = self.origin_position.x + self.origin_position.x * (x_koef - 1)
	self.position.y = self.origin_position.y + self.origin_position.y * (y_koef - 1)
	gui.set_position(self.node, self.position)

	self.on_size_changed:trigger(self:get_context(), new_size)
end


--- Set minimal size of layout node
-- @tparam Layout self @{Layout}
-- @tparam vector3 min_size
-- @treturn Layout @{Layout}
function Layout.set_min_size(self, min_size)
	self._min_size = min_size
	return self
end


--- Set maximum size of layout node
-- @tparam Layout self @{Layout}
-- @tparam vector3 max_size
-- @treturn Layout @{Layout}
function Layout.set_max_size(self, max_size)
	self._max_size = max_size
	return self
end


--- Set new origin position of layout node. You should apply this on node movement
-- @tparam Layout self @{Layout}
-- @tparam vector3 new_origin_position
-- @treturn Layout @{Layout}
function Layout.set_origin_position(self, new_origin_position)
	self.origin_position = new_origin_position or self.origin_position
	self:on_window_resized()
	return self
end


--- Set new origin size of layout node. You should apply this on node manual size change
-- @tparam Layout self @{Layout}
-- @tparam vector3 new_origin_size
-- @treturn Layout @{Layout}
function Layout.set_origin_size(self, new_origin_size)
	self.origin_size = new_origin_size or self.origin_size
	self:on_window_resized()
	return self
end


--- Set max gui upscale for FIT adjust mode (or side). It happens on bigger render gui screen
-- @tparam Layout self @{Layout}
-- @tparam number max_gui_upscale
-- @treturn Layout @{Layout}
function Layout.set_max_gui_upscale(self, max_gui_upscale)
	self._max_gui_upscale = max_gui_upscale
	self:on_window_resized()
end


--- Set size for layout node to fit inside it
-- @tparam Layout self @{Layout}
-- @tparam vector3 target_size
-- @treturn Layout @{Layout}
function Layout.fit_into_size(self, target_size)
	self.fit_size = target_size
	self:on_window_resized()
	return self
end


--- Set node for layout node to fit inside it. Pass nil to reset
-- @tparam Layout self @{Layout}
-- @tparam node|nil node
-- @treturn Layout @{Layout}
function Layout.fit_into_node(self, node)
	self._fit_node = node
	self:on_window_resized()
	return self
end


--- Set current size for layout node to fit inside it
-- @tparam Layout self @{Layout}
-- @treturn Layout @{Layout}
function Layout.fit_into_window(self)
	return self:fit_into_size(vmath.vector3(
		gui.get_width(),
		gui.get_height(),
		0))
end


return Layout
