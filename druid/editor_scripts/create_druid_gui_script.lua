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
---@param selection string The local GUI resource to modify
---@param widget_resource_path string The path to the GUI script to link
function M.link_gui_script(selection, widget_resource_path)
	local gui_filepath = editor.get(selection, "path")
	print("Linking ", gui_filepath, "to", widget_resource_path)
	editor.transact({
		editor.tx.set(selection, "script", widget_resource_path)
	})
end


return M
