--- Module for reusable UI components in the asset store
--- Contains component builders for filters, widget items, and lists

local M = {}


---Create a settings section with installation folder input
---@param install_path string - Current installation path
---@param on_change function - Callback when path changes
---@return userdata - UI component
function M.create_settings_section(install_path, on_change)
    return editor.ui.vertical({
        spacing = editor.ui.SPACING.SMALL,
        children = {
            editor.ui.label({
                text = "Installation Folder:",
                color = editor.ui.COLOR.TEXT
            }),
            editor.ui.label({
                text = install_path,
                color = editor.ui.COLOR.TEXT,
                grow = true
            })
        }
    })
end


---Extract unique authors from items list
---@param items table - List of widget items
---@return table - Sorted list of unique authors
local function extract_authors(items)
    local authors = {}
    local author_set = {}

    for _, item in ipairs(items) do
        if item.author and not author_set[item.author] then
            author_set[item.author] = true
            table.insert(authors, item.author)
        end
    end

    table.sort(authors)
    return authors
end


---Extract unique tags from items list
---@param items table - List of widget items
---@return table - Sorted list of unique tags
local function extract_tags(items)
    local tags = {}
    local tag_set = {}

    for _, item in ipairs(items) do
        if item.tags then
            for _, tag in ipairs(item.tags) do
                if not tag_set[tag] then
                    tag_set[tag] = true
                    table.insert(tags, tag)
                end
            end
        end
    end

    table.sort(tags)
    return tags
end


---Create filter section with author and tag dropdowns
---@param items table - List of all widget items
---@param author_filter string - Current author filter
---@param tag_filter string - Current tag filter
---@param on_author_change function - Callback for author filter change
---@param on_tag_change function - Callback for tag filter change
---@return userdata - UI component
function M.create_filter_section(items, author_filter, tag_filter, on_author_change, on_tag_change)
    local authors = extract_authors(items)
    local tags = extract_tags(items)

    -- Build author options
    local author_options = {"All Authors"}
    for _, author in ipairs(authors) do
        table.insert(author_options, author)
    end

    -- Build tag options
    local tag_options = {"All Categories"}
    for _, tag in ipairs(tags) do
        table.insert(tag_options, tag)
    end

    return editor.ui.horizontal({
        spacing = editor.ui.SPACING.MEDIUM,
        children = {
            editor.ui.vertical({
                spacing = editor.ui.SPACING.SMALL,
                children = {
                    editor.ui.label({
                        text = "Author:",
                        color = editor.ui.COLOR.TEXT
                    }),
                    editor.ui.label({
                        text = author_filter,
                        color = editor.ui.COLOR.TEXT
                    })
                }
            }),
            editor.ui.vertical({
                spacing = editor.ui.SPACING.SMALL,
                children = {
                    editor.ui.label({
                        text = "Category:",
                        color = editor.ui.COLOR.TEXT
                    }),
                    editor.ui.label({
                        text = tag_filter,
                        color = editor.ui.COLOR.TEXT
                    })
                }
            })
        }
    })
end


---Format file size for display
---@param size_bytes number - Size in bytes
---@return string - Formatted size string
local function format_size(size_bytes)
    if size_bytes < 1024 then
        return size_bytes .. " B"
    elseif size_bytes < 1024 * 1024 then
        return math.floor(size_bytes / 1024) .. " KB"
    else
        return math.floor(size_bytes / (1024 * 1024)) .. " MB"
    end
end


---Create a widget item card
---@param item table - Widget item data
---@param is_installed boolean - Whether widget is already installed
---@param on_install function - Callback for install button
---@param on_open_api function - Callback for API docs button
---@return userdata - UI component
function M.create_widget_item(item, is_installed, on_install, on_open_api)
    local size_text = item.size and format_size(item.size) or "Unknown size"
    local version_text = item.version and "v" .. item.version or "Unknown version"

    -- Create tags display
    local tags_text = ""
    if item.tags and #item.tags > 0 then
        tags_text = "Tags: " .. table.concat(item.tags, ", ")
    end

    -- Create dependencies display
    local deps_text = ""
    if item.depends and #item.depends > 0 then
        deps_text = "Depends on: " .. table.concat(item.depends, ", ")
    end

    return editor.ui.horizontal({
        spacing = editor.ui.SPACING.MEDIUM,
        padding = editor.ui.PADDING.MEDIUM,
        children = {
            -- Widget icon placeholder
            editor.ui.label({
                text = "📦",
                color = editor.ui.COLOR.HINT
            }),

            -- Widget details
            editor.ui.vertical({
                spacing = editor.ui.SPACING.SMALL,
                grow = true,
                children = {
                    -- Title and author
                    editor.ui.horizontal({
                        spacing = editor.ui.SPACING.SMALL,
                        children = {
                            editor.ui.label({
                                text = item.title or item.id,
                                color = editor.ui.COLOR.TEXT
                            }),
                            editor.ui.label({
                                text = "by " .. (item.author or "Unknown"),
                                color = editor.ui.COLOR.HINT
                            })
                        }
                    }),

                    -- Version and size
                    editor.ui.label({
                        text = version_text .. " • " .. size_text,
                        color = editor.ui.COLOR.HINT
                    }),

                    -- Description
                    editor.ui.label({
                        text = item.description or "No description available",
                        color = editor.ui.COLOR.TEXT
                    }),

                    -- Tags
                    tags_text ~= "" and editor.ui.label({
                        text = tags_text,
                        color = editor.ui.COLOR.HINT
                    }) or nil,

                    -- Dependencies
                    deps_text ~= "" and editor.ui.label({
                        text = deps_text,
                        color = editor.ui.COLOR.WARNING
                    }) or nil,

                    -- Installation status
                    is_installed and editor.ui.label({
                        text = "✓ Already installed",
                        color = editor.ui.COLOR.HINT
                    }) or nil
                }
            }),

            -- Action buttons
            editor.ui.vertical({
                spacing = editor.ui.SPACING.SMALL,
                children = {
                    editor.ui.button({
                        text = is_installed and "Reinstall" or "Install",
                        on_pressed = on_install,
                        enabled = true
                    }),
                    editor.ui.button({
                        text = "API Docs",
                        on_pressed = on_open_api,
                        enabled = item.api ~= nil
                    })
                }
            })
        }
    })
end


---Create a scrollable list of widget items
---@param items table - List of widget items to display
---@param is_installed_func function - Function to check if widget is installed
---@param on_install function - Callback for install button
---@param on_open_api function - Callback for API docs button
---@return userdata - UI component
function M.create_widget_list(items, is_installed_func, on_install, on_open_api)
    local widget_items = {}

    for _, item in ipairs(items) do
        local is_installed = is_installed_func and is_installed_func(item) or false

        table.insert(widget_items, M.create_widget_item(item, is_installed,
            function() on_install(item) end,
            function() on_open_api(item) end
        ))

        -- Add separator between items (except for the last one)
        if _ < #items then
            table.insert(widget_items, editor.ui.label({
                text = "---",
                color = editor.ui.COLOR.HINT
            }))
        end
    end

    return editor.ui.vertical({
        spacing = editor.ui.SPACING.SMALL,
        children = widget_items
    })
end


---Create a loading indicator
---@param message string - Loading message
---@return userdata - UI component
function M.create_loading_indicator(message)
    return editor.ui.vertical({
        spacing = editor.ui.SPACING.MEDIUM,
        alignment = editor.ui.ALIGNMENT.CENTER,
        children = {
            editor.ui.label({
                text = message or "Loading...",
                color = editor.ui.COLOR.TEXT,
                alignment = editor.ui.ALIGNMENT.CENTER
            })
        }
    })
end


---Create an error message display
---@param message string - Error message
---@return userdata - UI component
function M.create_error_message(message)
    return editor.ui.vertical({
        spacing = editor.ui.SPACING.MEDIUM,
        alignment = editor.ui.ALIGNMENT.CENTER,
        children = {
            editor.ui.label({
                text = "Error: " .. message,
                color = editor.ui.COLOR.ERROR,
                alignment = editor.ui.ALIGNMENT.CENTER
            })
        }
    })
end


return M
