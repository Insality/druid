local data = require("druid.editor_scripts.core.asset_store.data")


local M = {}


function M.download_json(json_url)
	return data.download_json(json_url)
end


function M.filter_items(items, query)
	return data.filter_items(items, query)
end


function M.extract_authors(items)
	return data.extract_authors(items)
end


function M.extract_tags(items)
	return data.extract_tags(items)
end


function M.filter_items_by_filters(items, search_query, filter_type, filter_author, filter_tag, install_folder)
	return data.filter_items_by_filters(items, search_query, filter_type, filter_author, filter_tag, install_folder)
end


function M.open_url(url)
	if not url then
		print("No URL available for:", url)
	end

	editor.browse(url)
end


return M
