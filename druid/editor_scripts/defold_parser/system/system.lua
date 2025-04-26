local parser = require("druid.editor_scripts.defold_parser.system.parser")

local M = {}


--- Check if table-array contains element
---@param table table
---@param element any
---@return number|boolean index of element or false
function M.contains(table, element)
	for index, value in pairs(table) do
		if value == element then
			return index
		end
	end

	return false
end


---@param file_path string
---@return string|nil, string|nil @success, reason
function M.read_file(file_path)
	local file = io.open(file_path, "r")
	if file == nil then
		return nil, "Could not open file: " .. file_path
	end

	local content = file:read("*a")
	file:close()

	return content, nil
end


---@param file_path string
---@param content string
---@return boolean, string|nil @success, reason
function M.write_file(file_path, content)
	local file = io.open(file_path, "w")
	if file == nil then
		return false, "Could not open file: " .. file_path
	end

	file:write(content)
	file:close()

	return true, nil
end


---@param line string
function M.unescape_line(line)
	-- Trim whitespaces
	line = line:match("^%s*(.-)%s*$")

	-- Remove first and last quote symbols only if exists
	if line:sub(1, 1) == '"' and line:sub(-1) == '"' then
		line = line:sub(2, -2)
	end

	-- Trim whitespaces
	line = line:match("^%s*(.-)%s*$")

	-- Splitting the value by new lines and processing each line
	line = line:gsub('\\"', '"') -- Unescaping quotes
	line = line:gsub("\\n", "")  -- Removing newline escapes
	line = line:gsub("\\", "")   -- Unescaping backslashes

	return line
end


---@param line string
---@return string, string, string, boolean @new_object_name, name, value, end_struct_flag
function M.split_line(line)
	local new_object_name = line:match(parser.REGEX_START_TABLE)
	local name, value = line:match(parser.REGEX_KEY_COLUM_VALUE)
	local end_struct_flag = line:match(parser.REGEX_END_TABLE)

	-- We hit a line what is contains only value, like multiline strings
	if not name and not value then
		value = line
	end

	return new_object_name, name, value, end_struct_flag
end


-- what a crap...
local LAST_USED_NAME = nil

---@param unescaped_line string @line to parse
---@param stack table @stack of objects
---@return boolean
function M.parse_line(unescaped_line, stack)
	unescaped_line = unescaped_line:match("^%s*(.-)%s*$")

	-- Use last object to insert data
	local object = stack[#stack]
	local line = M.unescape_line(unescaped_line)
	local inner_object_name, name, value, end_struct_flag = M.split_line(line)

	local is_just_new_line = (unescaped_line == "\"\\n\"")
	if not end_struct_flag and (line == "\"" or line == "") and (not is_just_new_line) then
		if LAST_USED_NAME ~= "text" then
			end_struct_flag = true
		end
	end

	if inner_object_name then
		parser.new_inner_struct(object, inner_object_name, stack)
		object = stack[#stack]
	end

	if name and value ~= nil then
		-- If value is nested object...
		if value:sub(1, 1) == '"' then
			value = value:sub(2, -1)
		end
		if value:sub(-1) == '"' then
			value = value:sub(1, -2)
		end

		local unescape_line = M.unescape_line(value)
		local new_object_name, field_name, _, end_flag = M.split_line(unescape_line)

		if (new_object_name or field_name or end_flag) and name ~= "text" then
			parser.new_inner_struct(object, name, stack)
			object = stack[#stack]

			M.parse_line(value, stack)
		else
			-- Just a hack honestly
			-- If first character is a quote, then remove it
			if value:sub(1, 1) == '"' then
				value = value:sub(2, -1)
			end
			if value:sub(-1) == '"' then
				value = value:sub(1, -2)
			end

			value = parser.decode_value(value, name)
			LAST_USED_NAME = name
			parser.apply_value(object, name, value)
		end
	end

	if not name and value and not inner_object_name and not end_struct_flag then
		-- We should to add value to the last as a multiline data
		parser.apply_multiline_value(object, LAST_USED_NAME, value)
	end

	if end_struct_flag then
		-- Go back to the parent object
		table.remove(stack)
	end

	return true
end


return M
