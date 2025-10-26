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


return M
