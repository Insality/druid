--- Module for handling widget installation from zip files
--- Downloads zip files and extracts them to the specified folder

local base64 = require("druid.editor_scripts.core.asset_store.base64")
local path_replacer = require("druid.editor_scripts.core.asset_store.path_replacer")

local M = {}

---@class druid.core.item_info
---@field id string
---@field version string
---@field title string
---@field author string
---@field description string
---@field api string
---@field author_url string
---@field image string
---@field manifest_url string
---@field zip_url string
---@field json_zip_url string
---@field sha256 string
---@field size number
---@field depends string[]
---@field tags string[]


---Download a file from URL
---@param url string - The URL to download from
---@return string|nil, string|nil, table|nil - Downloaded content or nil, filename or nil, content list or nil
local function download_file_zip_json(url)
	local response = http.request(url, { as = "json" })

	if response.status ~= 200 then
		print("Failed to download file. HTTP status: " .. response.status)
		return nil
	end

	local data = response.body
	local content_list = data.content -- Array of file paths from zip

	return base64.decode(data.data), data.filename, content_list
end


---Find widget by dependency string (format: "author:widget_id@version" or "author@widget_id" or "widget_id")
---@param dep_string string - Dependency string
---@param all_items table - List of all available widgets
---@return table|nil - Found widget item or nil
local function find_widget_by_dependency(dep_string, all_items)
	if not dep_string or not all_items then
		return nil
	end

	local author, widget_id

	-- Try format: "author:widget_id@version" (e.g., "Insality:mini_graph@1")
	author, widget_id = dep_string:match("^([^:]+):([^@]+)@")
	if not author then
		-- Try format: "author@widget_id" (e.g., "insality@mini_graph")
		author, widget_id = dep_string:match("^([^@]+)@(.+)$")
		if not author then
			-- No author specified, search by widget_id only
			widget_id = dep_string
		end
	end

	for _, item in ipairs(all_items) do
		if item.id == widget_id then
			-- If author was specified, check it matches (case-insensitive)
			if not author or string.lower(item.author or "") == string.lower(author) then
				return item
			end
		end
	end

	return nil
end


---Install widget dependencies recursively
---@param item druid.core.item_info - Widget item
---@param all_items table - List of all available widgets
---@param install_folder string - Installation folder
---@param installing_set table - Set of widget IDs currently being installed (to prevent cycles)
---@return boolean, string|nil - Success status and message
local function install_dependencies(item, all_items, install_folder, installing_set)
	if not item.depends or #item.depends == 0 then
		return true, nil
	end

	installing_set = installing_set or {}

	for _, dep_string in ipairs(item.depends) do
		local dep_item = find_widget_by_dependency(dep_string, all_items)
		if not dep_item then
			print("Warning: Dependency not found:", dep_string)
			-- Continue with other dependencies
		else
			-- Check if already installed
			if M.is_widget_installed(dep_item, install_folder) then
				print("Dependency already installed:", dep_item.id)
			else
				-- Check for circular dependencies
				if installing_set[dep_item.id] then
					print("Warning: Circular dependency detected:", dep_item.id)
					-- Continue with other dependencies
				else
					print("Installing dependency:", dep_item.id)
					local success, err = M.install_widget(dep_item, install_folder, all_items, installing_set)
					if not success then
						return false, "Failed to install dependency " .. dep_item.id .. ": " .. (err or "unknown error")
					end
				end
			end
		end
	end

	return true, nil
end


---Install a widget from a zip URL
---@param item druid.core.item_info - Widget item data containing zip_url and id
---@param install_folder string - Target folder to install to
---@param all_items table|nil - Optional list of all widgets for dependency resolution
---@param installing_set table|nil - Optional set of widget IDs currently being installed (to prevent cycles)
---@return boolean, string - Success status and message
function M.install_widget(item, install_folder, all_items, installing_set)
	if not item.json_zip_url or not item.id then
		return false, "Invalid widget data: missing json_zip_url or id"
	end

	-- Install dependencies first if all_items is provided
	if all_items then
		installing_set = installing_set or {}
		if installing_set[item.id] then
			return false, "Circular dependency detected: " .. item.id
		end
		installing_set[item.id] = true
		local dep_success, dep_err = install_dependencies(item, all_items, install_folder, installing_set)
		if not dep_success then
			installing_set[item.id] = nil
			return false, dep_err or "Failed to install dependencies"
		end
	end

	-- Download the zip file
	local zip_data, filename, content_list = download_file_zip_json(item.json_zip_url)
	if not zip_data or not filename then
		if installing_set then
			installing_set[item.id] = nil
		end
		return false, "Failed to download widget: " .. (filename or "unknown error")
	end

	if content_list then
		print("Got file list from JSON:", #content_list, "files")
	else
		print("Warning: No content list in JSON data")
	end


	local zip_file_path = "." .. install_folder .. "/" .. filename
	local zip_file = io.open(zip_file_path, "wb")
	if not zip_file then
		if installing_set then
			installing_set[item.id] = nil
		end
		print("Directory does not exist: " .. install_folder)
		print("Please create the directory manually and try again.")
		return false, "Directory does not exist: " .. install_folder
	end

	zip_file:write(zip_data)
	zip_file:close()
	print("Zip written to file: " .. zip_file_path)

	-- Unzip the zip file
	local folder_path = "." .. install_folder .. "/" .. item.id

	zip.unpack(zip_file_path, folder_path)
	print("Widget unpacked successfully")

	-- Remove the zip file
	os.remove(zip_file_path)
	print("Zip file removed successfully")

	-- Process paths within the extracted widget
	if content_list and #content_list > 0 then
		local success, err = path_replacer.process_widget_paths(folder_path, install_folder, item.id, item.author, content_list)
		if not success then
			print("Warning: Path replacement failed:", err)
			-- Don't fail installation if path replacement fails, just warn
		end
	else
		print("Warning: No file list available, skipping path replacement")
	end

	if installing_set then
		installing_set[item.id] = nil
	end

	return true, "Widget installed successfully"
end


---Check if a widget is already installed
---@param item table - Widget item data containing id
---@param install_folder string - Install folder to check in
---@return boolean - True if widget is already installed
function M.is_widget_installed(item, install_folder)
	local p = editor.resource_attributes(install_folder .. "/" .. item.id)
	return p.exists
end


---Get installation folder
---@return string - Installation folder path
function M.get_install_folder()
	return editor.prefs.get("druid.asset_install_folder")
end


return M
