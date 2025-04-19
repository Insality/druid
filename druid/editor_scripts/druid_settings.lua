local M = {}


function M.open_settings()
	print("Opening Druid settings")

	local dialog_component = editor.ui.component(function(props)
		local template_path, set_template_path = editor.ui.use_state(editor.prefs.get("druid.widget_template_path"))

		-- Check if the template path is valid
		local path_valid = editor.ui.use_memo(function(path)
			-- Use resource_exists to check if the resource exists
			local exists = false
			pcall(function()
				-- If we can get the text property, the resource exists
				local content = editor.get(path, "text")
				exists = content ~= nil
			end)
			return exists
		end, template_path)

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

					-- Links section title
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
					result = { template_path = template_path }
				})
			}
		})
	end)

	local result = editor.ui.show_dialog(dialog_component({}))
	if result and result.template_path then
		-- Update the preferences
		editor.prefs.set("druid.widget_template_path", result.template_path)
		print("Widget template path updated to:", result.template_path)
	end

	return result
end


return M
