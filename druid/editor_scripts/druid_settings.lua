local editor_scripts_internal = require("druid.editor_scripts.editor_scripts_internal")

local M = {}


function M.open_settings()
	print("Opening Druid settings")

	local dialog_component = editor.ui.component(function(props)
		local template_path, set_template_path = editor.ui.use_state(editor.prefs.get("druid.widget_template_path"))
		local path_valid = editor.ui.use_memo(function(path)
			local exists = false
			pcall(function()
				local content = editor.get(path, "text")
				exists = content ~= nil
			end)
			return exists
		end, template_path)

		local gui_script_template_path, set_gui_script_template_path = editor.ui.use_state(editor.prefs.get("druid.gui_script_template_path"))
		local gui_script_template_path_valid = editor.ui.use_memo(function(path)
			local exists = false
			pcall(function()
				local content = editor.get(path, "text")
				exists = content ~= nil
			end)
			return exists
		end, gui_script_template_path)

		local editor_script_set_layers_enabled, set_editor_script_set_layers_enabled = editor.ui.use_state(editor.prefs.get("druid.command_assign_layers_enabled"))
		local editor_script_create_widget_enabled, set_editor_script_create_widget_enabled = editor.ui.use_state(editor.prefs.get("druid.command_create_widget_enabled"))
		local editor_script_create_gui_script_enabled, set_editor_script_create_gui_script_enabled = editor.ui.use_state(editor.prefs.get("druid.command_create_gui_script_enabled"))
		local editor_script_create_collection_enabled, set_editor_script_create_collection_enabled = editor.ui.use_state(editor.prefs.get("druid.command_create_collection_enabled"))

		return editor.ui.dialog({
			title = "Druid Settings",
			content = editor.ui.vertical({
				spacing = editor.ui.SPACING.MEDIUM,
				padding = editor.ui.PADDING.MEDIUM,
				children = {
					editor.ui.label({
						text = "Widget Template Path:"
					}),
					editor.ui.resource_field({
						value = template_path,
						on_value_changed = set_template_path,
						extensions = {"lua", "template"},
						padding = editor.ui.PADDING.SMALL
					}),
					not path_valid and editor.ui.label({
						text = "Warning: Path not found!",
						color = editor.ui.COLOR.WARNING
					}) or nil,

					editor.ui.label({
						text = "GUI Script Template Path:"
					}),
					editor.ui.resource_field({
						value = gui_script_template_path,
						on_value_changed = set_gui_script_template_path,
						extensions = {"lua", "template"},
						padding = editor.ui.PADDING.SMALL
					}),
					not gui_script_template_path_valid and editor.ui.label({
						text = "Warning: Path not found!",
						color = editor.ui.COLOR.WARNING
					}) or nil,

					editor.ui.label({
						text = "Editor Commands:",
						color = editor.ui.COLOR.TEXT
					}),

					editor.ui.grid({
						columns = {{}, {grow = true}},
						children = {
							editor.bundle.grid_row(
								nil,
								editor.ui.check_box({
									value = editor_script_set_layers_enabled,
									on_value_changed = set_editor_script_set_layers_enabled,
									text = "Assign Layers"
								})
							),
							editor.bundle.grid_row(
								nil,
								editor.ui.check_box({
									value = editor_script_create_widget_enabled,
									on_value_changed = set_editor_script_create_widget_enabled,
									text = "Create Druid Widget"
								})
							),
							editor.bundle.grid_row(
								nil,
								editor.ui.check_box({
									value = editor_script_create_gui_script_enabled,
									on_value_changed = set_editor_script_create_gui_script_enabled,
									text = "Create Druid GUI Script"
								})
							),
							editor.bundle.grid_row(
								nil,
								editor.ui.check_box({
									value = editor_script_create_collection_enabled,
									on_value_changed = set_editor_script_create_collection_enabled,
									text = "Create Druid Collection"
								})
							)
						}
					}),

					editor.ui.label({
						text = "Documentation:",
						color = editor.ui.COLOR.TEXT
					}),

					-- Documentation buttons
					editor.ui.horizontal({
						spacing = editor.ui.SPACING.SMALL,
						children = {
							editor.ui.button({
								text = "Project Repository",
								on_pressed = function()
									editor.browse("https://github.com/Insality/druid")
								end
							}),
							editor.ui.button({
								text = "Open Quick API Reference",
								on_pressed = function()
									editor.browse("https://github.com/Insality/druid/blob/develop/api/quick_api_reference.md")
								end
							}),
						}
					}),

					-- Sponsor section
					editor.ui.label({
						text = "Support the project:",
						color = editor.ui.COLOR.TEXT
					}),
					editor.ui.horizontal({
						spacing = editor.ui.SPACING.SMALL,
						children = {
							editor.ui.button({
								text = "❤️ Sponsor on GitHub",
								on_pressed = function()
									editor.browse("https://github.com/sponsors/Insality")
								end
							}),
							editor.ui.button({
								text = "☕ Ko-fi",
								on_pressed = function()
									editor.browse("https://ko-fi.com/insality")
								end
							}),
							editor.ui.button({
								text = "☕ Buy Me A Coffee",
								on_pressed = function()
									editor.browse("https://buymeacoffee.com/insality")
								end
							})
						}
					})
				}
			}),
			buttons = {
				editor.ui.dialog_button({
					text = "Cancel",
					cancel = true
				}),
				editor.ui.dialog_button({
					text = "Save",
					default = true,
					result = {
						template_path = template_path,
						gui_script_template_path = gui_script_template_path,
						editor_script_set_layers_enabled = editor_script_set_layers_enabled,
						editor_script_create_widget_enabled = editor_script_create_widget_enabled,
						editor_script_create_gui_script_enabled = editor_script_create_gui_script_enabled,
						editor_script_create_collection_enabled = editor_script_create_collection_enabled,
					}
				})
			}
		})
	end)

	local result = editor.ui.show_dialog(dialog_component({}))
	if result then
		if result.template_path then
			editor.prefs.set("druid.widget_template_path", result.template_path)
			print("Widget template path updated to:", result.template_path)
		end
		if result.gui_script_template_path then
			editor.prefs.set("druid.gui_script_template_path", result.gui_script_template_path)
			print("GUI script template path updated to:", result.gui_script_template_path)
		end
		if result.editor_script_set_layers_enabled ~= nil then
			editor.prefs.set("druid.command_assign_layers_enabled", result.editor_script_set_layers_enabled)
			print("Assign layers enabled:", result.editor_script_set_layers_enabled)
		end
		if result.editor_script_create_widget_enabled ~= nil then
			editor.prefs.set("druid.command_create_widget_enabled", result.editor_script_create_widget_enabled)
			print("Create widget enabled:", result.editor_script_create_widget_enabled)
		end
		if result.editor_script_create_gui_script_enabled ~= nil then
			editor.prefs.set("druid.command_create_gui_script_enabled", result.editor_script_create_gui_script_enabled)
			print("Create GUI script enabled:", result.editor_script_create_gui_script_enabled)
		end
		if result.editor_script_create_collection_enabled ~= nil then
			editor.prefs.set("druid.command_create_collection_enabled", result.editor_script_create_collection_enabled)
			print("Create collection enabled:", result.editor_script_create_collection_enabled)
		end

		editor_scripts_internal.call_editor_command("reload-extensions")
	end

	return result
end


return M
