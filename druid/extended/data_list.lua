-- Copyright (c) 2021 Maksim Tuprikov <insality@gmail.com>. This code is licensed under MIT license

--- Component to manage data for huge dataset in scroll.
-- It requires Druid Scroll and Druid Grid (Static or Dynamic) components
--
-- <a href="https://insality.github.io/druid/druid/index.html?example=general_data_list" target="_blank"><b>Example Link</b></a>
-- @module DataList
-- @within BaseComponent
-- @alias druid.data_list


--- The Druid scroll component
-- @tfield Scroll scroll @{Scroll}

--- The Druid Grid component
-- @tfield StaticGrid|DynamicGrid grid @{StaticGrid}, @{DynamicGrid}

--- The current progress of scroll posititon
-- @tfield number scroll_progress

--- The current top index of visual elements
-- @tfield number top_index

--- The current last index of visual elements
-- @tfield number last_index

--- Event triggered when scroll progress is changed; event(self, progress_value)
-- @tfield DruidEvent on_scroll_progress_change @{DruidEvent}

---On DataList visual element created Event callback(self, index, node, instance)
-- @tfield DruidEvent on_element_add @{DruidEvent}

---On DataList visual element created Event callback(self, index)
-- @tfield DruidEvent on_element_remove @{DruidEvent}

---

local const = require("druid.const")
local helper = require("druid.helper")
local component = require("druid.component")
local Event = require("druid.event")

local DataList = component.create("data_list")


--- The @{DataList} constructor
-- @tparam DataList self @{DataList}
-- @tparam Scroll scroll The @{Scroll} instance for Data List component
-- @tparam StaticGrid|DynamicGrid grid The @{StaticGrid} or @{DynamicGrid} instance for Data List component
-- @tparam function create_function The create function callback(self, data, index, data_list). Function should return (node, [component])
function DataList.init(self, scroll, grid, create_function)
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
-- @tparam DataList self @{DataList}
function DataList.on_remove(self)
	self:clear()
	self.scroll.on_scroll:unsubscribe(self._refresh, self)
end


--- Set refresh function for DataList component
-- @tparam DataList self @{DataList}
-- @tparam boolean is_use_cache Use cache version of DataList. Requires make setup of components in on_element_add callback and clean in on_element_remove
-- @treturn druid.data_list Current DataList instance
function DataList.set_use_cache(self, is_use_cache)
	self._is_use_cache = is_use_cache
	return self
end


--- Set new data set for DataList component
-- @tparam DataList self @{DataList}
-- @tparam table data The new data array
-- @treturn druid.data_list Current DataList instance
function DataList.set_data(self, data)
	self._data = data or {}
	self:_refresh()

	return self
end


--- Return current data from DataList component
-- @tparam DataList self @{DataList}
-- @treturn table The current data array
function DataList.get_data(self)
	return self._data
end


--- Add element to DataList. Currenly untested
-- @tparam DataList self @{DataList}
-- @tparam table data
-- @tparam number|nil index
-- @tparam number|nil shift_policy The constant from const.SHIFT.*
function DataList.add(self, data, index, shift_policy)
	index = index or #self._data + 1
	shift_policy = shift_policy or const.SHIFT.RIGHT

	helper.insert_with_shift(self._data, data, index, shift_policy)
	self:_refresh()
end


--- Remove element from DataList. Currenly untested
-- @tparam DataList self @{DataList}
-- @tparam number|nil index
-- @tparam number|nil shift_policy The constant from const.SHIFT.*
function DataList.remove(self, index, shift_policy)
	helper.remove_with_shift(self._data, index, shift_policy)
	self:_refresh()
end


--- Remove element from DataList by data value. Currenly untested
-- @tparam DataList self @{DataList}
-- @tparam table data
-- @tparam number|nil shift_policy The constant from const.SHIFT.*
function DataList.remove_by_data(self, data, shift_policy)
	local index = helper.contains(self._data, data)
	if index then
		helper.remove_with_shift(self._data, index, shift_policy)
		self:_refresh()
	end
end


--- Clear the DataList and refresh visuals
-- @tparam DataList self @{DataList}
function DataList.clear(self)
	self._data = {}
	self:_refresh()
end


--- Return index for data value
-- @tparam DataList self @{DataList}
-- @tparam table data
function DataList.get_index(self, data)
	for index, value in pairs(self._data) do
		if value == data then
			return index
		end
	end

	return nil
end


--- Return all currenly created nodes in DataList
-- @tparam DataList self @{DataList}
-- @treturn node[] List of created nodes
function DataList.get_created_nodes(self)
	local nodes = {}

	for index, data in pairs(self._data_visual) do
		nodes[index] = data.node
	end

	return nodes
end


--- Return all currenly created components in DataList
-- @tparam DataList self @{DataList}
-- @treturn druid.base_component[] List of created nodes
function DataList.get_created_components(self)
	local components = {}

	for index, data in pairs(self._data_visual) do
		components[index] = data.component
	end

	return components
end


--- Instant scroll to element with passed index
-- @tparam DataList self @{DataList}
-- @tparam number index
function DataList.scroll_to_index(self, index)
	local pos = self.grid:get_pos(index)
	self.scroll:scroll_to(pos)
end


--- Add element at passed index using cache or create new
-- @tparam DataList self @{DataList}
-- @tparam number index
-- @local
function DataList._add_at(self, index)
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
-- @tparam DataList self @{DataList}
-- @tparam number index
-- @local
function DataList._remove_at(self, index)
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
-- @tparam DataList self @{DataList}
-- @local
function DataList._refresh(self)
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


return DataList
