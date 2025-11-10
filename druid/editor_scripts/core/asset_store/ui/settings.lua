local DEFAULT_LABELS = {
	install_label = "Installation Folder:",
	install_title = "Installation Folder:",
	install_tooltip = "The folder to install the assets to",
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



function M.create(params)
	local labels = build_labels(params and params.labels)

	return editor.ui.horizontal({
		spacing = editor.ui.SPACING.MEDIUM,
		children = {
			editor.ui.label({
				spacing = editor.ui.SPACING.MEDIUM,
				text = labels.install_label,
				color = editor.ui.COLOR.TEXT
			}),
			editor.ui.string_field({
				value = params.install_folder,
				on_value_changed = params.on_install_folder_changed,
				title = labels.install_title,
				tooltip = labels.install_tooltip,
			}),
		}
	})
end


return M

