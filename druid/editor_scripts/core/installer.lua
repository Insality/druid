--- Module for handling widget installation from zip files
--- Downloads zip files and extracts them to the specified folder

local base64 = require("druid.editor_scripts.core.base64")

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
---@return string|nil, string|nil - Downloaded content or nil, filename or nil
local function download_file_zip_json(url)
	local response = http.request(url, { as = "json" })

	if response.status ~= 200 then
		print("Failed to download file. HTTP status: " .. response.status)
		return nil
	end

	local data = response.body

	return base64.decode(data.data), data.filename
end


---Install a widget from a zip URL
---@param item druid.core.item_info - Widget item data containing zip_url and id
---@param install_folder string - Target folder to install to
---@return boolean, string - Success status and message
function M.install_widget(item, install_folder)
	if not item.json_zip_url or not item.id then
		return false, "Invalid widget data: missing zip_url or id"
	end

	-- Download the zip file
	local zip_data, filename = download_file_zip_json(item.json_zip_url)
	if not zip_data or not filename then
		return false, "Failed to download widget: " .. filename
	end


	local zip_file_path = "." .. install_folder .. "/" .. filename
	local zip_file = io.open(zip_file_path, "wb")
	if not zip_file then
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
	--local files_in_folder = path_replacer.get_all_files(folder_path)
	--pprint(files_in_folder)

	--if not path_replacer.process_widget_paths(install_folder .. "/" .. folder_name, new_base_path) then
	--	return false, "Failed to process widget paths"
	--end

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
