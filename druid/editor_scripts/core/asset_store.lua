--- Main asset store module for Druid widgets
--- Handles fetching widget data, displaying the store interface, and managing installations

local installer = require("druid.editor_scripts.core.installer")
local ui_components = require("druid.editor_scripts.core.ui_components")
local internal = require("druid.editor_scripts.core.asset_store_internal")

local M = {}


---Build type options array
---@return table
local function build_type_options()
	return {"All", "Installed", "Not Installed"}
end


---Build author options array
---@param authors table
---@return table
local function build_author_options(authors)
	local options = {"All Authors"}
	for _, author in ipairs(authors) do
		table.insert(options, author)
	end
	return options
end


---Build tag options array
---@param tags table
---@return table
local function build_tag_options(tags)
	local options = {"All Tags"}
	for _, tag in ipairs(tags) do
		table.insert(options, tag)
	end
	return options
end


---Handle widget installation
---@param item table - Widget item to install
---@param install_folder string - Installation folder
---@param all_items table - List of all widgets for dependency resolution
---@param on_success function - Success callback
---@param on_error function - Error callback
local function handle_install(item, install_folder, all_items, on_success, on_error)
	print("Installing widget:", item.id)

	local success, message = installer.install_widget(item, install_folder, all_items)

	if success then
		print("Installation successful:", message)
		on_success(message)
	else
		print("Installation failed:", message)
		on_error(message)
	end
end


---Open the asset store dialog
function M.open_asset_store(store_url)
	print("Opening Druid Asset Store from:", store_url)

	-- Fetch data synchronously before creating the dialog
	local store_data, fetch_error = internal.download_json(store_url)
	if not store_data then
		print("Failed to load widgets:", fetch_error)
		return
	end
	print("Successfully loaded", #store_data.items, "widgets")

	local initial_items = store_data.items
	local dialog_component = editor.ui.component(function(props)
		-- State management
		local all_items = editor.ui.use_state(initial_items)
		local install_folder, set_install_folder = editor.ui.use_state(editor.prefs.get("druid.asset_install_folder") or installer.get_install_folder())
		local search_query, set_search_query = editor.ui.use_state("")
		local filter_type, set_filter_type = editor.ui.use_state("All")
		local filter_author, set_filter_author = editor.ui.use_state("All Authors")
		local filter_tag, set_filter_tag = editor.ui.use_state("All Tags")
		local install_status, set_install_status = editor.ui.use_state("")

		-- Extract unique authors and tags for dropdown options
		local authors = editor.ui.use_memo(internal.extract_authors, all_items)
		local tags = editor.ui.use_memo(internal.extract_tags, all_items)

		-- Build dropdown options (memoized to avoid recreation on each render)
		local type_options = editor.ui.use_memo(build_type_options)
		local author_options = editor.ui.use_memo(build_author_options, authors)
		local tag_options = editor.ui.use_memo(build_tag_options, tags)

		-- Debug output
		if #type_options > 0 then
			print("Type options count:", #type_options, "first:", type_options[1])
		end
		if #author_options > 0 then
			print("Author options count:", #author_options, "first:", author_options[1])
		end
		if #tag_options > 0 then
			print("Tag options count:", #tag_options, "first:", tag_options[1])
		end

		-- Filter items based on all filters
		local filtered_items = editor.ui.use_memo(
			internal.filter_items_by_filters,
			all_items,
			search_query,
			filter_type,
			filter_author,
			filter_tag,
			install_folder
		)

		-- Installation handlers
		local function on_install(item)
			handle_install(item, install_folder, all_items,
				function(message)
					set_install_status("Success: " .. message)
				end,
				function(message)
					set_install_status("Error: " .. message)
				end
			)
		end

		-- Build UI content
		local content_children = {}

		-- Settings section
		table.insert(content_children, editor.ui.horizontal({
			spacing = editor.ui.SPACING.MEDIUM,
			children = {
				editor.ui.label({
					spacing = editor.ui.SPACING.MEDIUM,
					text = "Installation Folder:",
					color = editor.ui.COLOR.TEXT
				}),

				editor.ui.string_field({
					value = install_folder,
					on_value_changed = function(new_folder)
						set_install_folder(new_folder)
						editor.prefs.set("druid.asset_install_folder", new_folder)
					end,
					title = "Installation Folder:",
					tooltip = "The folder to install the assets to",
				}),
			}
		}))

		-- Filter dropdowns section
		table.insert(content_children, editor.ui.horizontal({
			spacing = editor.ui.SPACING.MEDIUM,
			children = {
				-- Type filter dropdown
				editor.ui.horizontal({
					spacing = editor.ui.SPACING.SMALL,
					children = {
						editor.ui.label({
							text = "Type:",
							color = editor.ui.COLOR.TEXT
						}),
						editor.ui.select_box({
							value = filter_type,
							options = type_options,
							on_value_changed = set_filter_type
						})
					}
				}),
				-- Author filter dropdown
				editor.ui.horizontal({
					spacing = editor.ui.SPACING.SMALL,
					children = {
						editor.ui.label({
							text = "Author:",
							color = editor.ui.COLOR.TEXT
						}),
						editor.ui.select_box({
							value = filter_author,
							options = author_options,
							on_value_changed = set_filter_author
						})
					}
				}),
				-- Tag filter dropdown
				editor.ui.horizontal({
					spacing = editor.ui.SPACING.SMALL,
					children = {
						editor.ui.label({
							text = "Tag:",
							color = editor.ui.COLOR.TEXT
						}),
						editor.ui.select_box({
							value = filter_tag,
							options = tag_options,
							on_value_changed = set_filter_tag
						})
					}
				})
			}
		}))

		-- Search section
		table.insert(content_children, editor.ui.horizontal({
			spacing = editor.ui.SPACING.MEDIUM,
			children = {
				editor.ui.label({
					text = "Search:",
					color = editor.ui.COLOR.TEXT
				}),
				editor.ui.string_field({
					value = search_query,
					on_value_changed = set_search_query,
					title = "Search:",
					tooltip = "Search for widgets by title, author, or description",
					grow = true
				})
			},
		}))

		-- Main content area
		if #filtered_items == 0 then
			local message = search_query ~= "" and
				"No widgets found matching '" .. search_query .. "'." or
				"No widgets found matching the current filters."
			table.insert(content_children, editor.ui.label({
				text = message,
				color = editor.ui.COLOR.HINT,
				alignment = editor.ui.ALIGNMENT.CENTER
			}))
		else
			table.insert(content_children, ui_components.create_widget_list(filtered_items, on_install))
		end

		-- Install status message
		if install_status ~= "" then
			table.insert(content_children, editor.ui.label({
				text = install_status,
				color = install_status:find("Success") and editor.ui.COLOR.TEXT or editor.ui.COLOR.ERROR,
				alignment = editor.ui.ALIGNMENT.CENTER
			}))
		end

		return editor.ui.dialog({
			title = "Druid Asset Store",
			content = editor.ui.vertical({
				spacing = editor.ui.SPACING.MEDIUM,
				padding = editor.ui.PADDING.SMALL,
				grow = true,
				children = content_children
			}),
			buttons = {
				editor.ui.dialog_button({
					text = "Info",
					result = "info_assets_store",
				}),
				editor.ui.dialog_button({
					text = "Close",
					cancel = true
				})
			}
		})
	end)

	local result = editor.ui.show_dialog(dialog_component({}))

	if result and result == "info_assets_store" then
		editor.browse("https://github.com/Insality/core/blob/main/druid_widget_store.md")
	end

	return {}
end


return M
