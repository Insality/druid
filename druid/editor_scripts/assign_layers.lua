--- Module for assigning layers to GUI nodes based on textures and fonts

local defold_parser = require("druid.editor_scripts.defold_parser.defold_parser")
local system = require("druid.editor_scripts.defold_parser.system.parser_internal")

local M = {}


---Create a backup of a file
---@param file_path string - The path of the file to backup
---@return string|nil - The backup file path, or nil if backup failed
local function create_backup(file_path)
	local backup_path = file_path .. ".backup"
	print("Creating backup at:", backup_path)

	-- Read and write using system module
	local content, err_read = system.read_file(file_path)
	if not content then
		print("Error reading original file for backup:", err_read)
		return nil
	end

	local success, err_write = system.write_file(backup_path, content)
	if not success then
		print("Error creating backup file:", err_write)
		return nil
	end

	print("Backup created successfully")
	return backup_path
end


---Restore from a backup file
---@param backup_path string - The path of the backup file
---@param original_path string - The path to restore to
---@return boolean - True if restore was successful
local function restore_from_backup(backup_path, original_path)
	print("Restoring from backup:", backup_path)

	-- Read backup file
	local content, err = system.read_file(backup_path)
	if not content then
		print("Error reading backup file:", err)
		return false
	end

	-- Write to original file
	local success, err = system.write_file(original_path, content)
	if not success then
		print("Error restoring from backup:", err)
		return false
	end

	print("Restored successfully from backup")
	return true
end


---Remove a backup file
---@param backup_path string - The path of the backup file to remove
local function remove_backup(backup_path)
	-- Check file exists and remove it
	local file = io.open(backup_path, "r")
	if file then
		file:close()
		os.remove(backup_path)
		print("Backup file removed successfully")
	end
end

---Assign layers to GUI nodes based on textures and fonts
---@param gui_resource string - The GUI resource to process
---@return table - Editor command to reload the resource
function M.assign_layers(gui_resource)
	local gui_path = editor.get(gui_resource, "path")
	print("Setting up layers for", gui_path)

	-- Get the absolute path to the file
	local absolute_project_path = editor.external_file_attributes(".").path
	if not absolute_project_path:match("[\\/]$") then
		absolute_project_path = absolute_project_path .. "/"
	end
	local clean_gui_path = gui_path
	if clean_gui_path:sub(1, 1) == "/" then
		clean_gui_path = clean_gui_path:sub(2)
	end
	local gui_absolute_path = absolute_project_path .. clean_gui_path

	-- Create a backup before modifying the file
	local backup_path = create_backup(gui_absolute_path)
	if not backup_path then
		print("Failed to create backup, aborting...")
		return {}
	end

	-- Parse the GUI file using defold_parser
	print("Parsing GUI file...")
	local gui_data = defold_parser.load_from_file(gui_absolute_path)
	if not gui_data then
		print("Error: Failed to parse GUI file")
		return {}
	end

	-- Collect all textures and fonts
	print("Collecting all available textures and fonts...")
	local all_textures = {}
	local all_fonts = {}

	-- Get textures
	if gui_data.textures then
		for _, texture in ipairs(gui_data.textures) do
			print("Found texture:", texture.name)
			all_textures[texture.name] = true
		end
	end

	-- Get fonts
	if gui_data.fonts then
		for _, font in ipairs(gui_data.fonts) do
			print("Found font:", font.name)
			all_fonts[font.name] = true
		end
	end

	-- Track which textures and fonts are actually used by nodes
	print("Finding used textures and fonts...")
	local used_layers = {}

	-- First pass: find all used textures and fonts
	if gui_data.nodes then
		for _, node in ipairs(gui_data.nodes) do
			if node.texture then
				local layer_name = node.texture:match("([^/]+)")
				if layer_name and all_textures[layer_name] then
					used_layers[layer_name] = true
					print("Node", node.id, "uses texture:", layer_name)
				end
			elseif node.font then
				local layer_name = node.font
				if all_fonts[layer_name] then
					used_layers[layer_name] = true
					print("Node", node.id, "uses font:", layer_name)
				end
			end
		end
	end

	-- Create a set of existing layer names for faster lookup
	print("Checking existing layers...")
	local existing_layers = {}
	if gui_data.layers then
		for _, layer in ipairs(gui_data.layers) do
			if layer.name then
				existing_layers[layer.name] = true
				print("Found existing layer:", layer.name)
			end
		end
	end

	-- Convert set to array of used layers
	local layers = {}
	for layer_name in pairs(used_layers) do
		if not existing_layers[layer_name] then
			table.insert(layers, layer_name)
			print("Adding new layer:", layer_name)
		else
			print("Layer already exists:", layer_name)
		end
	end

	-- Sort new layers for consistent output
	table.sort(layers)

	print("Found", #layers, "new layers to add")

	-- Add new layers (preserving existing ones)
	print("Adding new layers...")
	gui_data.layers = gui_data.layers or {}
	for _, layer_name in ipairs(layers) do
		table.insert(gui_data.layers, {
			name = layer_name,
		})
	end
	if #gui_data.layers == 0 then
		gui_data.layers = nil
	end

	-- Create a lookup table for faster matching - include both existing and new layers
	local layer_lookup = {}
	for layer_name in pairs(existing_layers) do
		layer_lookup[layer_name] = true
	end
	for _, layer_name in ipairs(layers) do
		layer_lookup[layer_name] = true
	end

	-- Update nodes to use the correct layer
	print("Updating node layers...")
	if gui_data.nodes then
		for _, node in ipairs(gui_data.nodes) do
			if node.texture then
				local layer_name = node.texture:match("([^/]+)")
				if layer_name and layer_lookup[layer_name] then
					print("Assigning node", node.id, "to layer:", layer_name)
					node.layer = layer_name
				end
			elseif node.font then
				local layer_name = node.font
				if layer_lookup[layer_name] then
					print("Assigning node", node.id, "to layer:", layer_name)
					node.layer = layer_name
				end
			end
		end
	end

	-- Write the updated GUI file
	print("Writing updated GUI file...")
	local success = defold_parser.save_to_file(gui_absolute_path, gui_data)

	if not success then
		print("Error: Failed to save GUI file")
		print("Attempting to restore from backup...")
		local restored = restore_from_backup(backup_path, gui_absolute_path)
		if not restored then
			print("Critical: Failed to restore from backup. Manual intervention may be required.")
		end
		return {}
	end

	-- Everything worked, remove the backup
	remove_backup(backup_path)

	print("Successfully assigned layers for GUI:", gui_path)

	return {}
end


return M
