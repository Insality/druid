local installer = require("druid.editor_scripts.core.installer")


local M = {}


local function normalize_query(query)
	if not query or query == "" then
		return nil
	end

	return string.lower(query)
end


local function is_unlisted_visible(item, lower_query)
	if not item.unlisted then
		return true
	end

	if not lower_query or not item.id then
		return false
	end

	return string.lower(item.id) == lower_query
end


function M.download_json(json_url)
	local response = http.request(json_url, { as = "json" })

	if response.status ~= 200 then
		return nil, "Failed to fetch store data. HTTP status: " .. response.status
	end

	if not response.body or not response.body.items then
		return nil, "Invalid store data format"
	end

	return response.body, nil
end


function M.filter_items(items, query)
	if query == "" or query == nil then
		return items
	end

	local filtered = {}
	local lower_query = string.lower(query)

	for _, item in ipairs(items) do
		local matches = false
		if item.id and string.find(string.lower(item.id), lower_query, 1, true) then
			matches = true
		elseif item.title and string.find(string.lower(item.title), lower_query, 1, true) then
			matches = true
		elseif item.author and string.find(string.lower(item.author), lower_query, 1, true) then
			matches = true
		elseif item.description and string.find(string.lower(item.description), lower_query, 1, true) then
			matches = true
		end

		if not matches and item.tags then
			for _, tag in ipairs(item.tags) do
				if string.find(string.lower(tag), lower_query, 1, true) then
					matches = true
					break
				end
			end
		end

		if not matches and item.depends then
			for _, dep in ipairs(item.depends) do
				if string.find(string.lower(dep), lower_query, 1, true) then
					matches = true
					break
				end
			end
		end

		if matches then
			table.insert(filtered, item)
		end
	end

	return filtered
end


function M.extract_authors(items)
	local authors = {}
	local author_set = {}

	for _, item in ipairs(items) do
		if not item.unlisted and item.author and not author_set[item.author] then
			author_set[item.author] = true
			table.insert(authors, item.author)
		end
	end

	table.sort(authors)

	return authors
end


function M.extract_tags(items)
	local tags = {}
	local tag_set = {}

	for _, item in ipairs(items) do
		if not item.unlisted and item.tags then
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


function M.filter_items_by_filters(items, search_query, filter_type, filter_author, filter_tag, install_folder)
	local lower_query = normalize_query(search_query)
	local visible_items = {}

	for _, item in ipairs(items) do
		if is_unlisted_visible(item, lower_query) then
			table.insert(visible_items, item)
		end
	end

	local filtered = visible_items

	if lower_query then
		filtered = M.filter_items(filtered, search_query)
	end

	if filter_type and filter_type ~= "All" then
		local type_filtered = {}
		for _, item in ipairs(filtered) do
			local is_installed = installer.is_widget_installed(item, install_folder)
			if (filter_type == "Installed" and is_installed) or
				(filter_type == "Not Installed" and not is_installed) then
				table.insert(type_filtered, item)
			end
		end
		filtered = type_filtered
	end

	if filter_author and filter_author ~= "All Authors" then
		local author_filtered = {}
		for _, item in ipairs(filtered) do
			if item.author == filter_author then
				table.insert(author_filtered, item)
			end
		end
		filtered = author_filtered
	end

	if filter_tag and filter_tag ~= "All Tags" then
		local tag_filtered = {}
		for _, item in ipairs(filtered) do
			if item.tags then
				for _, tag in ipairs(item.tags) do
					if tag == filter_tag then
						table.insert(tag_filtered, item)
						break
					end
				end
			end
		end
		filtered = tag_filtered
	end

	return filtered
end


function M.open_url(url)
	if not url then
		print("No URL available for:", url)
	end

	editor.browse(url)
end


return M

