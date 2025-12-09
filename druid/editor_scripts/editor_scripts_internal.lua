local M = {}


---Read editor port from .internal/editor.port file
---@return number|nil port Editor port number or nil if not found
local function get_editor_port()
	local port_file_path = ".internal/editor.port"
	local port_file = io.open(port_file_path, "r")
	if not port_file then
		return nil
	end

	local port_str = port_file:read("*a")
	port_file:close()

	if not port_str then
		return nil
	end

	-- Trim whitespace
	port_str = string.match(port_str, "%s*(.-)%s*$")
	local port = tonumber(port_str)
	return port
end


---Call editor HTTP API command
---@param command string Command name (e.g., "fetch-libraries")
---@return boolean success True if request was sent successfully
function M.call_editor_command(command)
	if not command or command == "" then
		return false
	end

	local port = get_editor_port()
	if not port then
		print("Asset Store: Could not read editor port from .internal/editor.port")
		return false
	end

	local url = string.format("http://localhost:%d/command/%s", port, command)

	-- Fire and forget - send POST request to editor API
	pcall(function()
		local response = http.request(url, {
			method = "POST",
			headers = { ["Accept"] = "application/json" }
		})
	end)

	return true
end


return M
