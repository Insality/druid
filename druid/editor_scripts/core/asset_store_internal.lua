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
		if item.title and string.find(string.lower(item.title), lower_query, 1, true) then
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


---Open a URL in the default browser
---@param url string - The URL to open
function M.open_url(url)
	if not url then
		print("No URL available for:", url)
	end
	editor.browse(url)
end


return M
