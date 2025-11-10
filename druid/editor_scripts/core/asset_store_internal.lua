local installer = require("druid.editor_scripts.core.installer")

local M = {}

---Download a JSON file from a URL
---@param json_url string - The URL to download the JSON from
---@return table|nil, string|nil - The JSON data or nil, error message or nil
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


local function is_unlisted_visible(item, lower_query)
	if not item.unlisted then
		return true
	end

	if not lower_query or lower_query == "" or not item.id then
		return false
	end

	return string.lower(item.id) == lower_query
end


---Filter items based on search query
---Filter items based on search query
---@param items table - List of widget items
---@param query string - Search query
---@return table - Filtered items
function M.filter_items(items, query)
	if query == "" then
		return items
	end

	local filtered = {}
	local lower_query = string.lower(query)

	for _, item in ipairs(items) do
		-- Search in title, author, description
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

		-- Search in tags
		if not matches and item.tags then
			for _, tag in ipairs(item.tags) do
				if string.find(string.lower(tag), lower_query, 1, true) then
					matches = true
					break
				end
			end
		end

		-- Search in dependencies
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


---Extract unique authors from items list
---@param items table - List of widget items
---@return table - Sorted list of unique authors
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


---Extract unique tags from items list
---@param items table - List of widget items
---@return table - Sorted list of unique tags
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


---Filter items based on all filters (search, type, author, tag)
---@param items table - List of widget items
---@param search_query string - Search query
---@param filter_type string - Type filter: "All", "Installed", "Not Installed"
---@param filter_author string - Author filter: "All Authors" or specific author
---@param filter_tag string - Tag filter: "All Tags" or specific tag
---@param install_folder string - Installation folder to check installed status
---@return table - Filtered items
function M.filter_items_by_filters(items, search_query, filter_type, filter_author, filter_tag, install_folder)
	local lower_query = nil
	if search_query and search_query ~= "" then
		lower_query = string.lower(search_query)
	end

	local visible_items = {}
	for _, item in ipairs(items) do
		if is_unlisted_visible(item, lower_query) then
			table.insert(visible_items, item)
		end
	end

	local filtered = visible_items

	-- Filter by search query
	if search_query and search_query ~= "" then
		filtered = M.filter_items(filtered, search_query)
	end

	-- Filter by type (Installed/Not Installed)
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

	-- Filter by author
	if filter_author and filter_author ~= "All Authors" then
		local author_filtered = {}
		for _, item in ipairs(filtered) do
			if item.author == filter_author then
				table.insert(author_filtered, item)
			end
		end
		filtered = author_filtered
	end

	-- Filter by tag
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


---Open a URL in the default browser
---@param url string - The URL to open
function M.open_url(url)
	if not url then
		print("No URL available for:", url)
	end
	editor.browse(url)
end


return M
