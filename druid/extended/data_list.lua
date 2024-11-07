-- Copyright (c) 2021 Maksim Tuprikov <insality@gmail.com>. This code is licensed under MIT license

--- Component to manage data for huge dataset in scroll.
-- It requires Druid Scroll and Druid Grid (Static or Dynamic) components
--
-- <a href="https://insality.github.io/druid/druid/index.html?example=general_data_list" target="_blank"><b>Example Link</b></a>
-- @module DataList
-- @within BaseComponent
-- @alias druid.data_list


--- The Druid scroll component
-- @tfield Scroll scroll Scroll

--- The Druid Grid component
-- @tfield StaticGrid grid StaticGrid}, @{DynamicGrid

--- The current progress of scroll posititon
-- @tfield number scroll_progress

--- The current top index of visual elements
-- @tfield number top_index

--- The current last index of visual elements
-- @tfield number last_index

--- Event triggered when scroll progress is changed; event(self, progress_value)
-- @tfield druid.event on_scroll_progress_change druid.event

---On DataList visual element created Event callback(self, index, node, instance)
-- @tfield druid.event on_element_add druid.event

---On DataList visual element created Event callback(self, index)
-- @tfield druid.event on_element_remove druid.event

---

local const = require("druid.const")
local helper = require("druid.helper")
local component = require("druid.component")
local Event = require("druid.event")

---@class druid.data_list: druid.base_component
---@field scroll druid.scroll
---@field grid druid.grid
---@field on_scroll_progress_change druid.event
---@field on_element_add druid.event
---@field on_element_remove druid.event
---@field private _create_function function
---@field private _is_use_cache boolean
---@field private _cache table
---@field private _data table
---@field private _data_visual table
---@field private top_index number
local M = component.create("data_list")


--- The DataList constructor
---@param self DataList DataList
---@param scroll Scroll The Scroll instance for Data List component
---@param grid StaticGrid The StaticGrid} or @{DynamicGrid instance for Data List component
---@param create_function function The create function callback(self, data, index, data_list). Function should return (node, [component])
function M:init(scroll, grid, create_function)
	self.scroll = scroll
	self.grid = grid
	if self.grid.style then
		self.grid.style.IS_DYNAMIC_NODE_POSES = false
	end

	-- Current visual elements indexes
	self.top_index = 1
	self.last_index = 1
	self.scroll_progress = 0

	self._create_function = create_function
	self._is_use_cache = false
	self._cache = {}
	self._data = {}
	self._data_visual = {}

	self.scroll.on_scroll:subscribe(self._refresh, self)

	self.on_scroll_progress_change = Event()
	self.on_element_add = Event()
	self.on_element_remove = Event()
end


--- Druid System on_remove function
---@param self DataList DataList
function M:on_remove()
	self:clear()
	self.scroll.on_scroll:unsubscribe(self._refresh, self)
end


--- Set refresh function for DataList component
---@param self DataList DataList
---@param is_use_cache boolean Use cache version of DataList. Requires make setup of components in on_element_add callback and clean in on_element_remove
-- @treturn druid.data_list Current DataList instance
function M:set_use_cache(is_use_cache)
	self._is_use_cache = is_use_cache
	return self
end


--- Set new data set for DataList component
---@param self DataList DataList
---@param data table The new data array
-- @treturn druid.data_list Current DataList instance
function M:set_data(data)
	self._data = data or {}
	self:_refresh()

	return self
end


--- Return current data from DataList component
---@param self DataList DataList
-- @treturn table The current data array
function M:get_data()
	return self._data
end


--- Add element to DataList. Currenly untested
---@param self DataList DataList
---@param data table
---@param index number|nil
---@param shift_policy number|nil The constant from const.SHIFT.*
function M:add(data, index, shift_policy)
	index = index or #self._data + 1
	shift_policy = shift_policy or const.SHIFT.RIGHT

	helper.insert_with_shift(self._data, data, index, shift_policy)
	self:_refresh()
end


--- Remove element from DataList. Currenly untested
---@param self DataList DataList
---@param index number|nil
---@param shift_policy number|nil The constant from const.SHIFT.*
function M:remove(index, shift_policy)
	helper.remove_with_shift(self._data, index, shift_policy)
	self:_refresh()
end


--- Remove element from DataList by data value. Currenly untested
---@param self DataList DataList
---@param data table
---@param shift_policy number|nil The constant from const.SHIFT.*
function M:remove_by_data(data, shift_policy)
	local index = helper.contains(self._data, data)
	if index then
		helper.remove_with_shift(self._data, index, shift_policy)
		self:_refresh()
	end
end


--- Clear the DataList and refresh visuals
---@param self DataList DataList
function M:clear()
	self._data = {}
	self:_refresh()
end


--- Return index for data value
---@param self DataList DataList
---@param data table
function M:get_index(data)
	for index, value in pairs(self._data) do
		if value == data then
			return index
		end
	end

	return nil
end


--- Return all currenly created nodes in DataList
---@param self DataList DataList
-- @treturn node[] List of created nodes
function M:get_created_nodes()
	local nodes = {}

	for index, data in pairs(self._data_visual) do
		nodes[index] = data.node
	end

	return nodes
end


--- Return all currenly created components in DataList
---@param self DataList DataList
-- @treturn druid.base_component[] List of created nodes
function M:get_created_components()
	local components = {}

	for index, data in pairs(self._data_visual) do
		components[index] = data.component
	end

	return components
end


--- Instant scroll to element with passed index
---@param self DataList DataList
---@param index number
function M:scroll_to_index(index)
	local pos = self.grid:get_pos(index)
	self.scroll:scroll_to(pos)
end


--- Add element at passed index using cache or create new
---@param self DataList DataList
---@param index number
---@private
function M:_add_at(index)
	if self._data_visual[index] then
		self:_remove_at(index)
	end

	local data = self._data[index]
	local node, instance

	-- Use cache if available and is_use_cache is set
	if #self._cache > 0 and self._is_use_cache then
		local cached = table.remove(self._cache)
		node = cached.node
		instance = cached.component
		gui.set_enabled(node, true)
	else
		-- Create a new element if no cache or refresh function is not set
		node, instance = self._create_function(self:get_context(), data, index, self)
	end

	self._data_visual[index] = {
		data = data,
		node = node,
		component = instance,
	}
	self.grid:add(node, index, const.SHIFT.NO_SHIFT)

	self.on_element_add:trigger(self:get_context(), index, node, instance, data)
end


--- Remove element from passed index and add it to cache if applicable
---@param self DataList DataList
---@param index number
---@private
function M:_remove_at(index)
	self.grid:remove(index, const.SHIFT.NO_SHIFT)

	local visual_data = self._data_visual[index]
	local node = visual_data.node
	local instance = visual_data.component
	local data = visual_data.data

	self.on_element_remove:trigger(self:get_context(), index, node, instance, data)

	if self._is_use_cache then
		-- Disable the node and add it to the cache instead of deleting it
		gui.set_enabled(node, false)
		table.insert(self._cache, visual_data)  -- Cache the removed element
	else
		-- If no refresh function, delete the node and component as usual
		gui.delete_node(node)
		if instance then
			instance._meta.druid:remove(instance)
		end
	end

	self._data_visual[index] = nil
end



--- Refresh all elements in DataList
---@param self DataList DataList
---@private
function M:_refresh()
	self.scroll:set_size(self.grid:get_size_for(#self._data))

	local start_pos = -self.scroll.position --[[@as vector3]]
	local start_index = self.grid:get_index(start_pos)
	start_index = math.max(1, start_index)

	local pivot = helper.get_pivot_offset(gui.get_pivot(self.scroll.view_node))
	local offset_x = self.scroll.view_size.x * (0.5 - pivot.x)
	local offset_y = self.scroll.view_size.y * (0.5 + pivot.y)
	local end_pos = vmath.vector3(start_pos.x + offset_x, start_pos.y - offset_y, 0)
	local end_index = self.grid:get_index(end_pos)
	end_index = math.min(#self._data, end_index)

	self.top_index = start_index
	self.last_index = end_index

	-- Clear from non range elements
	for index, data in pairs(self._data_visual) do
		if index < start_index or index > end_index then
			self:_remove_at(index)
		elseif self._data[index] ~= data.data then
			-- TODO We want to find currently created data instances and move them to new positions
			-- Now it will re-create them
			self:_remove_at(index)
		end
	end

	-- Add new elements
	for index = start_index, end_index do
		if not self._data_visual[index] and self._data[index] then
			self:_add_at(index)
		end
	end
end


return M
