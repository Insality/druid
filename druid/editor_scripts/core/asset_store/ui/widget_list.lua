local widget_card = require("druid.editor_scripts.core.asset_store.ui.widget_card")


local M = {}


local function noop(...)
end



local function build_context(overrides)
	return {
		on_install = overrides.on_install or noop,
		open_url = overrides.open_url or noop,
		labels = overrides.labels,
	}
end



function M.create(items, overrides)
	local card_context = build_context(overrides or {})
	local is_installed = overrides and overrides.is_installed or function(_)
		return false
	end

	local widget_items = {}
	for _, item in ipairs(items) do
		local context = {
			on_install = function()
				card_context.on_install(item)
			end,
			open_url = card_context.open_url,
			labels = card_context.labels,
			is_installed = is_installed(item),
		}

		table.insert(widget_items, widget_card.create(item, context))
	end

	return editor.ui.scroll({
		content = editor.ui.vertical({
			children = widget_items
		})
	})
end


return M

