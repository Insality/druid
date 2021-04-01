--- Manage data for huge dataset in scroll
--- It requires basic druid scroll and druid grid components
local const = require("druid.const")
local helper = require("druid.helper")
local component = require("druid.component")

local DataList = component.create("data_list")


function DataList.init(self, data, scroll, grid, create_function)
	self.view_size = gui.get_size(scroll.view_node)
	self.prefab_size = grid.node_size
	self.druid = self:get_druid()
	self.scroll = scroll
	self.grid = grid
	self.scroll:bind_grid(grid)

	--- Current visual elements indexes
	self.top_index = 1
	self.last_index = 1
	self.create_function = create_function

	self._data = {}
	self._data_first_index = false
	self._data_last_index = false
	self._data_length = 0
	self._data_visual = {}

	self.scroll.on_scroll:subscribe(self._check_elements, self)

	self:set_data(data)
end


function DataList.on_remove(self)
	self.scroll.on_scroll:unsubscribe(self._check_elements, self)
end


function DataList.set_data(self, data)
	self._data = data
	self:_update_data_info()
	self:_refresh()
end


function DataList.add(self, data, index, shift_policy)
	index = index or self._data_last_index + 1
	shift_policy = shift_policy or const.SHIFT.RIGHT

	if self._data[index] then
		if shift_policy == const.SHIFT.RIGHT then
			for i = self._data_last_index, index, -1 do
				self._data[i + 1] = self._data[i]
			end
		end
		if shift_policy == const.SHIFT.LEFT then
			for i = self._data_first_index, index do
				self._data[i - 1] = self._data[i]
			end
		end
	end
	self._data[index] = data
	self:_update_data_info()
	self:_check_elements()
end


function DataList.remove(self, index, shift_policy)
	table.remove(self._data, index)
	self:_refresh()
end


function DataList.remove_by_data(self, data, shift_policy)
	local index = helper.contains(self._data, data)
	if index then
		table.remove(self._data, index)
		self:_refresh()
	end
end


function DataList.clear(self)
	self._data = {}
	self:_refresh()
end


function DataList.get_first_index(self)
	return self._data_first_index
end


function DataList.get_last_index(self)
	return self._data_last_index
end


function DataList.get_length(self)
	return self._data_length
end


function DataList.get_index(self, data)
	for index, value in pairs(self._data) do
		if value == data then
			return index
		end
	end

	return nil
end


function DataList.scroll_to_index(self, index)
	self.top_index = helper.clamp(index, 1, #self._data)
	self:_refresh()
	self.scroll.on_scroll:trigger(self:get_context(), self)
end


function DataList._add_at(self, index)
	if self._data_visual[index] then
		self:_remove_at(index)
	end

	local node, instance = self.create_function(self._data[index], index)
	self.grid:add(node, index, const.SHIFT.NO_SHIFT)
	self._data_visual[index] = {
		node = node,
		component = instance
	}
end


function DataList._remove_at(self, index)
	self.grid:remove(index, const.SHIFT.NO_SHIFT)

	local node = self._data_visual[index].node
	gui.delete_node(node)

	if self._data_visual[index].component then
		self.druid:remove(self._data_visual[index].component)
	end
	self._data_visual[index] = nil
end


function DataList._refresh(self)
	for index, _ in pairs(self._data_visual) do
		self:_remove_at(index)
	end
	self:_check_elements()
end


function DataList._check_elements(self)
	for index, data in pairs(self._data_visual) do
		if self.scroll:is_node_in_view(data.node) then
			self.top_index = index
			self.last_index = index
		end
	end

	self:_check_elements_from(self.top_index, -1)
	self:_check_elements_from(self.top_index + 1, 1)

	for index, data in pairs(self._data_visual) do
		self.top_index = math.min(self.top_index or index, index)
		self.last_index = math.max(self.last_index or index, index)
	end
end


function DataList._check_elements_from(self, index, step)
	local is_outside = false
	while not is_outside do
		if not self._data[index] then
			break
		end

		if not self._data_visual[index] then
			self:_add_at(index)
		end

		if not self.scroll:is_node_in_view(self._data_visual[index].node) then
			is_outside = true

			-- remove nexts:
			-- We add one more element, which is not in view to
			-- check what it's always outside to stop spawning
			local remove_index = index + step
			while self._data_visual[remove_index] do
				self:_remove_at(remove_index)
				remove_index = remove_index + step
			end
		end

		index = index + step
	end
end


function DataList._update_data_info(self)
	self._data_first_index = false
	self._data_last_index = false
	self._data_length = 0

	for index, data in pairs(self._data) do
		self._data_first_index = math.min(self._data_first_index or index, index)
		self._data_last_index = math.max(self._data_last_index or index, index)
		self._data_length = self._data_length + 1
	end

	if self._data_length == 0 then
		self._data_first_index = 1
		self._data_last_index = 1
	end
end


return DataList
