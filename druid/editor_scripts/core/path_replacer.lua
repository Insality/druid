--- Module for replacing paths in extracted widget files
--- Handles updating require statements and file paths to match the installation location

local M = {}


---Recursively get all files in a directory
---@param dir_path string - Directory path to scan
---@param extension string|nil - Optional file extension filter (e.g., ".lua")
---@return string[] - List of file paths
function M.get_all_files(dir_path, extension)
	local attributes = editor.resource_attributes(dir_path)
	local files = io.popen("ls -R " .. dir_path)
	for line in files:lines() do
		print(line)
	end
	pprint(files)
	return files
end


return M
