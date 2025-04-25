local M = {}

local function to_camel_case(snake_str)
	local components = {}
	for component in snake_str:gmatch("[^_]+") do
		table.insert(components, component:sub(1, 1):upper() .. component:sub(2))
	end
	return table.concat(components, "")
end


function M.create_druid_gui_script(selection)
	local gui_filepath = editor.get(selection, "path")
	local filename = gui_filepath:match("([^/]+)%.gui$")
	print("Create Druid GUI Script for", gui_filepath)

	local absolute_project_path = editor.external_file_attributes(".").path
	local widget_resource_path = gui_filepath:gsub("%.gui$", ".gui_script")
	local new_widget_absolute_path = absolute_project_path .. widget_resource_path

	local widget_name = to_camel_case(filename)
	local widget_type = filename

	-- Check if file already exists
	local f = io.open(new_widget_absolute_path, "r")
	if f then
		f:close()
		print("Widget file already exists at " .. new_widget_absolute_path)
		print("Creation aborted to prevent overwriting")
		return
	end

	-- Get template path from preferences
	local template_path = editor.prefs.get("druid.gui_script_template_path")

	-- Get template content using the path from preferences
	local template_content = editor.get(template_path, "text")
	if not template_content then
		print("Error: Could not load template from", template_path)
		print("Check the template path in [Druid] Settings")
		return
	end

	-- Replace template variables
	template_content = template_content:gsub("{COMPONENT_NAME}", widget_name)
	template_content = template_content:gsub("{COMPONENT_TYPE}", widget_type)

	-- Write file
	local file, err = io.open(new_widget_absolute_path, "w")
	if not file then
		print("Error creating widget file:", err)
		return
	end
	file:write(template_content)
	file:close()

	print("Widget created at " .. widget_resource_path)

	M.link_gui_script(selection, widget_resource_path)
end


---Links a GUI script to a GUI file by updating the script property
---@param selection string The GUI resource to modify
---@param widget_resource_path string The path to the GUI script to link
function M.link_gui_script(selection, widget_resource_path)
	local defold_parser = require("druid.editor_scripts.defold_parser.defold_parser")
	local system = require("druid.editor_scripts.defold_parser.system.system")

	local gui_filepath = editor.get(selection, "path")
	print("Linking GUI script to", gui_filepath)

	-- Get the absolute path to the file
	local absolute_project_path = editor.external_file_attributes(".").path
	if not absolute_project_path:match("[\\/]$") then
		absolute_project_path = absolute_project_path .. "/"
	end
	local clean_gui_path = gui_filepath
	if clean_gui_path:sub(1, 1) == "/" then
		clean_gui_path = clean_gui_path:sub(2)
	end
	local gui_absolute_path = absolute_project_path .. clean_gui_path

	-- Create a backup
	local backup_path = gui_absolute_path .. ".backup"
	print("Creating backup at:", backup_path)

	-- Read and write backup
	local content, err_read = system.read_file(gui_absolute_path)
	if not content then
		print("Error reading original file for backup:", err_read)
		return
	end

	local success, err_write = system.write_file(backup_path, content)
	if not success then
		print("Error creating backup file:", err_write)
		return
	end

	-- Parse the GUI file
	print("Parsing GUI file...")
	local gui_data = defold_parser.load_from_file(gui_absolute_path)
	if not gui_data then
		print("Error: Failed to parse GUI file")
		return
	end

	-- Update the script property
	print("Setting script property to:", widget_resource_path)
	gui_data.script = widget_resource_path

	-- Write the updated GUI file
	print("Writing updated GUI file...")
	local save_success = defold_parser.save_to_file(gui_absolute_path, gui_data)

	if not save_success then
		print("Error: Failed to save GUI file")
		print("Attempting to restore from backup...")

		-- Restore from backup on failure
		local backup_content, backup_err_read = system.read_file(backup_path)
		if not backup_content then
			print("Error reading backup file:", backup_err_read)
			return
		end

		local restore_success, restore_err_write = system.write_file(gui_absolute_path, backup_content)
		if not restore_success then
			print("Critical: Failed to restore from backup:", restore_err_write)
			return
		end

		print("Restored successfully from backup")
		return
	end

	-- Remove backup on success
	os.remove(backup_path)
	print("Successfully linked GUI script to:", gui_filepath)
end


return M
