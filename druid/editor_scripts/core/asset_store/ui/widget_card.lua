local DEFAULT_LABELS = {
	install_button = "Install",
	api_button = "API",
	example_button = "Example",
	author_caption = "Author",
	installed_tag = "✓ Installed",
	tags_prefix = "Tags: ",
	depends_prefix = "Depends: ",
	size_separator = "• ",
	unknown_size = "Unknown size",
	unknown_version = "Unknown version",
}


local M = {}


local function format_size(size_bytes)
	if not size_bytes then
		return DEFAULT_LABELS.unknown_size
	end

	if size_bytes < 1024 then
		return size_bytes .. " B"
	elseif size_bytes < 1024 * 1024 then
		return math.floor(size_bytes / 1024) .. " KB"
	end

	return math.floor(size_bytes / (1024 * 1024)) .. " MB"
end



local function build_labels(overrides)
	if not overrides then
		return DEFAULT_LABELS
	end

	local labels = {}
	for key, value in pairs(DEFAULT_LABELS) do
		labels[key] = overrides[key] or value
	end

	return labels
end


function M.create(item, context)
	local labels = build_labels(context and context.labels)
	local open_url = context and context.open_url or function(_) end
	local on_install = context and context.on_install or function(...) end
	local is_installed = context and context.is_installed or false

	local size_text = format_size(item.size)
	local version_text = item.version and ("v" .. item.version) or labels.unknown_version
	local tags_text = item.tags and #item.tags > 0 and labels.tags_prefix .. table.concat(item.tags, ", ") or ""
	local deps_text = item.depends and #item.depends > 0 and labels.depends_prefix .. table.concat(item.depends, ", ") or ""

	local widget_details_children = {
		editor.ui.horizontal({
			spacing = editor.ui.SPACING.SMALL,
			children = {
				editor.ui.label({
					text = item.title or item.id,
					color = editor.ui.COLOR.OVERRIDE
				}),
				editor.ui.label({
					text = version_text,
					color = editor.ui.COLOR.WARNING
				}),
				editor.ui.label({
					text = labels.size_separator .. size_text,
					color = editor.ui.COLOR.HINT
				}),
			}
		}),
		editor.ui.paragraph({
			text = item.description or "No description available",
			color = editor.ui.COLOR.TEXT
		})
	}

	if tags_text ~= "" then
		table.insert(widget_details_children, editor.ui.label({
			text = tags_text,
			color = editor.ui.COLOR.HINT
		}))
	end

	if deps_text ~= "" then
		table.insert(widget_details_children, editor.ui.label({
			text = deps_text,
			color = editor.ui.COLOR.HINT
		}))
	end

	if is_installed then
		table.insert(widget_details_children, editor.ui.label({
			text = labels.installed_tag,
			color = editor.ui.COLOR.WARNING
		}))
	end

	local button_children = {
		editor.ui.button({
			text = labels.install_button,
			on_pressed = on_install,
			enabled = not is_installed
		})
	}

	if item.api then
		table.insert(button_children, editor.ui.button({
			text = labels.api_button,
			on_pressed = function() open_url(item.api) end,
			enabled = item.api ~= nil
		}))
	end

	if item.example_url then
		table.insert(button_children, editor.ui.button({
			text = labels.example_button,
			on_pressed = function() open_url(item.example_url) end,
			enabled = item.example_url ~= nil
		}))
	end

	table.insert(button_children, editor.ui.horizontal({ grow = true }))

	if item.author_url then
		table.insert(button_children, editor.ui.label({
			text = labels.author_caption,
			color = editor.ui.COLOR.HINT
		}))
		table.insert(button_children, editor.ui.button({
			text = item.author or labels.author_caption,
			on_pressed = function() open_url(item.author_url) end,
			enabled = item.author_url ~= nil
		}))
	end

	table.insert(widget_details_children, editor.ui.horizontal({
		spacing = editor.ui.SPACING.SMALL,
		children = button_children
	}))

	return editor.ui.horizontal({
		spacing = editor.ui.SPACING.NONE,
		padding = editor.ui.PADDING.SMALL,
		children = {
			editor.ui.label({
				text = "•••",
				color = editor.ui.COLOR.HINT
			}),
			editor.ui.vertical({
				spacing = editor.ui.SPACING.SMALL,
				grow = true,
				children = widget_details_children
			}),
		}
	})
end


return M
