local config = require("druid.editor_scripts.defold_parser.system.config")

local M = {}

-- Example: "name: value"
M.REGEX_KEY_COLUM_VALUE = "^%s*([%w_]+):%s*(.+)$"
-- Example: "name {"
M.REGEX_START_TABLE = "^%s*([%w_]*)%s*{%s*$"
-- Example: "}"
M.REGEX_END_TABLE = "^%s*}%s*$"


---@param value string
---@return string
function M.unescape_text_field(value)
	-- Splitting the value by new lines and processing each line
	local lines = {}
	for line in value:gmatch("[^\r\n]+") do
		line = line:gsub('\\"', '"') -- Unescaping quotes
		line = line:gsub("\\n", "")  -- Removing newline escapes
		line = line:gsub("\\", "")   -- Unescaping backslashes
		table.insert(lines, line)
	end

	-- Reconstructing the value
	value = table.concat(lines, "\n")
	return value
end


function M.is_multiline_value(value)
	return value:find("\\n\"") ~= nil
end


---@param value any
---@param property_name string|nil
---@return any
function M.decode_value(value, property_name)
	if value:match('^".*"$') then
		-- Removing the quotes from the string
		value = value:sub(2, -2)

		-- Check if value is escaped
		-- If ends with \n
		if value:sub(-2) == "\\n" then
			value = value:gsub('\\"', '"') -- Unescaping quotes
			value = value:gsub("\\n", "")
			value = value:gsub("\\", "")
		end

	elseif value:match('^%-?[0-9.E%-]+$') then
		-- Converting to number
		value = tonumber(value)
	end

	-- Specific handling for the "text" property
	if property_name == "text" then
		value = tostring(value)
	else
		if value == "true" then
			value = true
		elseif value == "false" then
			value = false
		end
	end

	if property_name == "text" and M.is_multiline_value(value) and type(value) == "string" then
		value = M.unescape_text_field(value)
	end

	return value
end


---@param parent_object table
---@param name string
---@param stack table
function M.new_inner_struct(parent_object, name, stack)
	local new_object = {}
	M.apply_value(parent_object, name, new_object)

	local is_object_always_list = config.ALWAYS_LIST[name]
	if is_object_always_list and not M.is_array(parent_object[name]) then
		parent_object[name] = { parent_object[name] }
	end

	table.insert(stack, new_object)
end


---Apply value to the object, if the value is already present, convert it to an array
---@param object table
---@param name string
---@param value any
---@return table object
function M.apply_value(object, name, value)
	local is_object_always_list = config.ALWAYS_LIST[name]
	if object[name] == nil then
		object[name] = value
		if is_object_always_list then
			object[name] = { object[name] }
		end
		return object
	end

	-- Convert to array if not already
	if not M.is_array(object[name]) then
		object[name] = { object[name] }
	end

	table.insert(object[name], value)
	return object
end


---@param object table
---@param value string
---@return table @object
function M.apply_multiline_value(object, name, value)
	if object[name] == nil then
		object[name] = value
	else
		object[name] = object[name] .. "\n" .. value
	end

	return object
end


--- Check if table is array
---@param t table
---@return boolean
function M.is_array(t)
	return type(t) == "table" and t[1] ~= nil
end


return M
