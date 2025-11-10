local M = {}


function M.build(params)
	return editor.ui.dialog({
		title = params.title or "Asset Store",
		content = editor.ui.vertical({
			spacing = params.spacing or editor.ui.SPACING.MEDIUM,
			padding = params.padding or editor.ui.PADDING.SMALL,
			grow = true,
			children = params.children or {}
		}),
		buttons = params.buttons or {}
	})
end


return M

