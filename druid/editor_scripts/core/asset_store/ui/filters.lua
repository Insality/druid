local DEFAULT_LABELS = {
	type_label = "Type:",
	author_label = "Author:",
	tag_label = "Tag:",
	all_types = "All",
	installed = "Installed",
	not_installed = "Not Installed",
	all_authors = "All Authors",
	all_tags = "All Tags",
}


local M = {}


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


function M.build_type_options(overrides)
	local labels = build_labels(overrides and overrides.labels)

	return {
		labels.all_types,
		labels.installed,
		labels.not_installed,
	}
end


function M.build_author_options(authors, overrides)
	local labels = build_labels(overrides and overrides.labels)
	local options = {labels.all_authors}

	for _, author in ipairs(authors or {}) do
		table.insert(options, author)
	end

	return options
end


function M.build_tag_options(tags, overrides)
	local labels = build_labels(overrides and overrides.labels)
	local options = {labels.all_tags}

	for _, tag in ipairs(tags or {}) do
		table.insert(options, tag)
	end

	return options
end


function M.create(params)
	local labels = build_labels(params and params.labels)

	return editor.ui.horizontal({
		spacing = editor.ui.SPACING.MEDIUM,
		children = {
			editor.ui.horizontal({
				spacing = editor.ui.SPACING.SMALL,
				children = {
					editor.ui.label({
						text = labels.type_label,
						color = editor.ui.COLOR.TEXT
					}),
					editor.ui.select_box({
						value = params.filter_type,
						options = params.type_options,
						on_value_changed = params.on_type_change
					})
				}
			}),
			editor.ui.horizontal({
				spacing = editor.ui.SPACING.SMALL,
				children = {
					editor.ui.label({
						text = labels.author_label,
						color = editor.ui.COLOR.TEXT
					}),
					editor.ui.select_box({
						value = params.filter_author,
						options = params.author_options,
						on_value_changed = params.on_author_change
					})
				}
			}),
			editor.ui.horizontal({
				spacing = editor.ui.SPACING.SMALL,
				children = {
					editor.ui.label({
						text = labels.tag_label,
						color = editor.ui.COLOR.TEXT
					}),
					editor.ui.select_box({
						value = params.filter_tag,
						options = params.tag_options,
						on_value_changed = params.on_tag_change
					})
				}
			})
		}
	})
end


return M

