--- Defold Text Proto format encoder/decoder to lua table

local config = require("druid.editor_scripts.defold_parser.system.config")
local parser_internal = require("druid.editor_scripts.defold_parser.system.parser_internal")

local M = {}


--- Decode a Defold object from a string
---@param text string
---@return table
function M.decode_defold_object(text)
	-- Create a root object, which will contain all the file data
	local root = {}
	-- Stack to keep track of nested objects. Always insert data to the last object in the stack
	local stack = { root }

	-- For each line in the text, we go through the following steps:
	for raw_line in text:gmatch("[^\r\n]+") do
		parser_internal.parse_line(raw_line, stack)
	end

	return root
end


-- Encoding Functions
function M.encode_defold_object(obj, spaces, data_level, extension)
	spaces = spaces or 0
	data_level = data_level or 0
	local key_order = extension and config.KEY_ORDER[extension] or {}

	local result = ''
	local tabString = string.rep(' ', spaces)

	local keys = {}
	for key in pairs(obj) do
		table.insert(keys, key)
	end

	table.sort(keys, function(a, b)
		local index_a = parser_internal.contains(key_order, a) or 0
		local index_b = parser_internal.contains(key_order, b) or 0
		return index_a < index_b
	end)

	-- Iterate over the sorted keys
	for _, key in ipairs(keys) do
		local value = obj[key]
		local value_type = type(value)

		-- Handle different types of values
		if value_type == "table" then
			-- Check if it's an array-like table
			if #value > 0 then
				-- It's an array-like table, process each element
				for _, array_item in ipairs(value) do
					local item_type = type(array_item)

					if key == "data" and item_type == "table" then
						-- Handle nested data
						local encodedChild = M.encode_defold_object(array_item, spaces + 2, data_level + 1, extension)
						result = result .. tabString .. key .. ': "' .. encodedChild .. '"\n'
					elseif item_type == "number" or item_type == "boolean" then
						local is_contains_dot = string.find(key, "%.")
						if item_type == "number" and (parser_internal.contains(config.with_dot_params, key) and not is_contains_dot) then
							result = result .. tabString .. key .. ': ' .. string.format("%.1f", array_item) .. '\n'
						else
							result = result .. tabString .. key .. ': ' .. tostring(array_item) .. '\n'
						end
					elseif item_type == "string" then
						-- Handle multiline text
						if key == "text" then
							result = result .. tabString .. key .. ': "' .. array_item:gsub("\n", '\\n"\n' .. tabString .. '"') .. '"\n'
						else
							-- Check if the key should not have quotes
							local is_uppercase = (array_item == string.upper(array_item))
							local is_boolean = (array_item == "true" or array_item == "false")
							if (is_uppercase and not config.string_keys[key]) or is_boolean then
								result = result .. tabString .. key .. ': ' .. array_item .. '\n'
							else
								result = result .. tabString .. key .. ': "' .. array_item .. '"\n'
							end
						end
					elseif item_type == "table" then
						result = result .. tabString .. key .. ' {\n' .. M.encode_defold_object(array_item, spaces + 2, data_level, extension) .. tabString .. '}\n'
					end
				end
			else
				-- It's a dictionary-like table
				result = result .. tabString .. key .. ' {\n' .. M.encode_defold_object(value, spaces + 2, data_level, extension) .. tabString .. '}\n'
			end
		else
			-- Handle scalar values (string, number, boolean)
			if value_type == "number" or value_type == "boolean" then
				local is_contains_dot = string.find(key, "%.")
				if value_type == "number" and (parser_internal.contains(config.with_dot_params, key) and not is_contains_dot) then
					result = result .. tabString .. key .. ': ' .. string.format("%.1f", value) .. '\n'
				else
					result = result .. tabString .. key .. ': ' .. tostring(value) .. '\n'
				end
			elseif value_type == "string" then
				-- Handle multiline text
				if key == "text" then
					result = result .. tabString .. key .. ': "' .. value:gsub("\n", '\\n"\n' .. tabString .. '"') .. '"\n'
				else
					-- Check if the key should not have quotes
					local is_uppercase = (value == string.upper(value))
					local is_boolean = (value == "true" or value == "false")
					if (is_uppercase and not config.string_keys[key]) or is_boolean then
						result = result .. tabString .. key .. ': ' .. value .. '\n'
					else
						result = result .. tabString .. key .. ': "' .. value .. '"\n'
					end
				end
			end
		end
	end

	return result
end


---Load lua table from file in Defold Text Proto format
---@param file_path string
---@return table|nil, string|nil
function M.load_from_file(file_path)
	local content, reason = parser_internal.read_file(file_path)
	if not content then
		return nil, reason
	end

	return M.decode_defold_object(content), nil
end


---Write lua table to file in Defold Text Proto format
---The path file extension will be used to determine the Defold format (*.atlas, *.gui, *.font, etc)
---@param file_path string
---@param lua_table table
---@return boolean, string|nil
function M.save_to_file(file_path, lua_table)
	-- Get extension without the dot
	local defold_format_name = file_path:match("^.+%.(.+)$")
	print("File extension:", defold_format_name)

	local encoded_object = M.encode_defold_object(lua_table, nil, nil, defold_format_name)

	return parser_internal.write_file(file_path, encoded_object)
end


return M
