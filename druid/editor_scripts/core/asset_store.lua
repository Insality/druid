--- Main asset store module for Druid widgets
--- Handles fetching widget data, displaying the store interface, and managing installations

local installer = require("druid.editor_scripts.core.installer")
local ui_components = require("druid.editor_scripts.core.ui_components")

local M = {}

local STORE_URL = "https://insality.github.io/core/druid_widget_store.json"


---Fetch widget data from the remote store
---@return table|nil, string|nil - Store data or nil, error message or nil
local function fetch_store_data()
    print("Fetching widget data from:", STORE_URL)

    local response = http.request(STORE_URL, {
        as = "json"
    })

    if response.status ~= 200 then
        return nil, "Failed to fetch store data. HTTP status: " .. response.status
    end

    if not response.body or not response.body.items then
        return nil, "Invalid store data format"
    end

    print("Successfully fetched", #response.body.items, "widgets")
    return response.body, nil
end


---Filter items based on author and tag filters
---@param items table - List of widget items
---@param author_filter string - Author filter value
---@param tag_filter string - Tag filter value
---@return table - Filtered list of items
local function filter_items(items, author_filter, tag_filter)
    local filtered = {}

    for _, item in ipairs(items) do
        local author_match = author_filter == "All Authors" or item.author == author_filter
        local tag_match = tag_filter == "All Categories" or (item.tags and table.concat(item.tags, ","):find(tag_filter))

        if author_match and tag_match then
            table.insert(filtered, item)
        end
    end

    return filtered
end


---Handle widget installation
---@param item table - Widget item to install
---@param install_folder string - Installation folder
---@param on_success function - Success callback
---@param on_error function - Error callback
local function handle_install(item, install_folder, on_success, on_error)
    print("Installing widget:", item.id)

    local success, message = installer.install_widget(item, install_folder)

    if success then
        print("Installation successful:", message)
        on_success(message)
    else
        print("Installation failed:", message)
        on_error(message)
    end
end


---Handle opening API documentation
---@param item table - Widget item
local function handle_open_api(item)
    if item.api then
        print("Opening API documentation:", item.api)
        editor.browse(item.api)
    else
        print("No API documentation available for:", item.id)
    end
end


---Show installation status dialog
---@param success boolean - Whether installation was successful
---@param message string - Status message
local function show_install_status(success, message)
    local dialog_component = editor.ui.component(function()
        return editor.ui.dialog({
            title = success and "Installation Successful" or "Installation Failed",
            content = editor.ui.vertical({
                spacing = editor.ui.SPACING.MEDIUM,
                padding = editor.ui.PADDING.MEDIUM,
                children = {
                    editor.ui.label({
                        text = message,
                        color = success and editor.ui.COLOR.TEXT or editor.ui.COLOR.ERROR,
                        alignment = editor.ui.ALIGNMENT.LEFT
                    })
                }
            }),
            buttons = {
                editor.ui.dialog_button({
                    text = "OK",
                    default = true
                })
            }
        })
    end)

    editor.ui.show_dialog(dialog_component({}))
end


---Open the asset store dialog
function M.open_asset_store()
    print("Opening Druid Asset Store")

    -- Fetch data synchronously before creating the dialog
    local store_data, fetch_error = fetch_store_data()
    local initial_items = {}
    local initial_loading = false
    local initial_error = nil

    if store_data then
        initial_items = store_data.items
        print("Successfully loaded", #initial_items, "widgets")
    else
        initial_error = fetch_error
        print("Failed to load widgets:", fetch_error)
    end

    local dialog_component = editor.ui.component(function(props)
		editor.prefs.set("druid.asset_install_folder", "./widget")
        -- State management
        local items, set_items = editor.ui.use_state(initial_items)
        local loading, set_loading = editor.ui.use_state(initial_loading)
        local error_message, set_error_message = editor.ui.use_state(initial_error)
        local install_folder, set_install_folder = editor.ui.use_state(editor.prefs.get("druid.asset_install_folder") or installer.get_default_install_folder())
        local author_filter, set_author_filter = editor.ui.use_state("All Authors")
        local tag_filter, set_tag_filter = editor.ui.use_state("All Categories")
        local install_status, set_install_status = editor.ui.use_state("")

        -- Filter items
        local filtered_items = editor.ui.use_memo(filter_items, items, author_filter, tag_filter)

        -- Installation status check function
        local function is_widget_installed(item)
            return installer.is_widget_installed(item, install_folder)
        end

        -- Installation handlers
        local function on_install(item)
            handle_install(item, install_folder,
                function(message)
                    set_install_status("Success: " .. message)
                    show_install_status(true, message)
                end,
                function(message)
                    set_install_status("Error: " .. message)
                    show_install_status(false, message)
                end
            )
        end

        local function on_open_api(item)
            handle_open_api(item)
        end

        -- Build UI content
        local content_children = {}

        -- Settings section
        table.insert(content_children, editor.ui.label({
            text = "Installation Folder: " .. install_folder,
            color = editor.ui.COLOR.TEXT
        }))

        -- Filter section (only show if we have items)
        if #items > 0 then
            table.insert(content_children, editor.ui.label({
                text = "Filters: Author: " .. author_filter .. ", Category: " .. tag_filter,
                color = editor.ui.COLOR.TEXT
            }))
        end

        -- Main content area
        if loading then
            table.insert(content_children, ui_components.create_loading_indicator("Loading widget store..."))
        elseif error_message then
            table.insert(content_children, ui_components.create_error_message(error_message))
        elseif #filtered_items == 0 then
            table.insert(content_children, editor.ui.label({
                text = "No widgets found matching the current filters.",
                color = editor.ui.COLOR.HINT,
                alignment = editor.ui.ALIGNMENT.CENTER
            }))
        else
            table.insert(content_children, ui_components.create_widget_list(
                filtered_items, is_widget_installed, on_install, on_open_api
            ))
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
                padding = editor.ui.PADDING.MEDIUM,
                children = content_children
            }),
            buttons = {
                editor.ui.dialog_button({
                    text = "Close",
                    cancel = true
                })
            }
        })
    end)

    local result = editor.ui.show_dialog(dialog_component({}))

    -- Save the install folder preference (this will be handled by the state management in the dialog)

    return result
end


return M
