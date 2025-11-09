--- Module for replacing widget paths in installed files
--- Handles path replacement from original widget structure to user's installation path

local system = require("druid.editor_scripts.defold_parser.system.parser_internal")

local M = {}


---Detect the original path structure from item data
---Builds widget/author/widget_id path
---@param author string|nil - Author name
---@param widget_id string - Widget ID
---@return string|nil - Original path prefix (e.g., "widget/Insality/fps_panel") or nil
local function detect_original_path_from_item(author, widget_id)
	if not author or not widget_id then
		return nil
	end

	local original_path = "widget/" .. author .. "/" .. widget_id
	print("Detected original path from item:", original_path)
	return original_path
end


---Replace paths in file content
---@param content string - File content
---@param original_path string - Original path to replace (e.g., "widget/Insality/fps_panel")
---@param target_path string - Target path (e.g., "widget/fps_panel")
---@return string - Modified content
local function replace_paths_in_content(content, original_path, target_path)
	if not content or not original_path or not target_path then
		return content
	end

	-- Escape special characters for literal string replacement
	local function escape_pattern(str)
		return str:gsub("[%^%$%(%)%%%.%[%]%*%+%-%?]", "%%%0")
	end

	-- Replace paths with forward slashes: widget/Insality/fps_panel -> widget/fps_panel
	local escaped_original = escape_pattern(original_path)
	content = content:gsub(escaped_original, target_path)

	-- Replace require statements with dots: widget.Insality.fps_panel -> widget.fps_panel
	local original_dots = original_path:gsub("/", ".")
	local target_dots = target_path:gsub("/", ".")
	local escaped_original_dots = escape_pattern(original_dots)
	content = content:gsub(escaped_original_dots, target_dots)

	return content
end


---Process widget paths in all files
---@param folder_path string - Path to the unpacked widget folder
---@param install_folder string - Installation folder (e.g., "widget")
---@param widget_id string - Widget ID (e.g., "fps_panel")
---@param author string|nil - Author name (e.g., "Insality")
---@param file_list table - Optional list of file paths from zip content
---@return boolean, string|nil - Success status and error message if any
function M.process_widget_paths(folder_path, install_folder, widget_id, author, file_list)
	print("Processing widget paths in:", folder_path)

	-- Detect original path structure from item data
	local original_path = detect_original_path_from_item(author, widget_id)

	if not original_path then
		print("Warning: Could not detect original path structure (missing author or widget_id), skipping path replacement")
		return true, nil
	end

	-- Construct target path
	-- Remove leading / from install_folder if present
	local clean_install_folder = install_folder
	if clean_install_folder:sub(1, 1) == "/" then
		clean_install_folder = clean_install_folder:sub(2)
	end

	local target_path = clean_install_folder
	if widget_id then
		if target_path ~= "" then
			target_path = target_path .. "/" .. widget_id
		else
			target_path = widget_id
		end
	end

	print("Replacing paths from:", original_path, "to:", target_path)

	-- Get absolute project path
	local absolute_project_path = editor.external_file_attributes(".").path
	if not absolute_project_path:match("[\\/]$") then
		absolute_project_path = absolute_project_path .. "/"
	end

	-- Clean folder_path
	local clean_folder_path = folder_path
	if clean_folder_path:sub(1, 1) == "." then
		clean_folder_path = clean_folder_path:sub(2)
	end
	if clean_folder_path:sub(1, 1) == "/" then
		clean_folder_path = clean_folder_path:sub(2)
	end

	-- Process each file from the list
	local processed_count = 0
	for _, file_path_in_zip in ipairs(file_list) do
		-- Build full path to the file after unpacking
		local file_path = clean_folder_path .. "/" .. file_path_in_zip

		-- Get absolute path
		local clean_file_path = file_path
		if clean_file_path:sub(1, 1) == "/" then
			clean_file_path = clean_file_path:sub(2)
		end
		local absolute_file_path = absolute_project_path .. clean_file_path

		-- Read file content
		local content, err = system.read_file(absolute_file_path)
		if not content then
			print("Warning: Could not read file:", file_path, err)
		else
			-- Replace paths
			local modified_content = replace_paths_in_content(content, original_path, target_path)
			if modified_content ~= content then
				-- Write modified content back
				local success, write_err = system.write_file(absolute_file_path, modified_content)
				if success then
					processed_count = processed_count + 1
					print("Processed:", file_path)
				else
					print("Warning: Could not write file:", file_path, write_err)
				end
			end
		end
	end

	print("Path replacement complete. Processed", processed_count, "files")
	return true, nil
end


return M

