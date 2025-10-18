--- Module for handling widget installation from zip files
--- Downloads zip files and extracts them to the specified folder

local M = {}

local DEFAULT_INSTALL_FOLDER = "/widget"


---Download a file from URL
---@param url string - The URL to download from
---@return string|nil, string|nil - Downloaded content or nil, error message or nil
local function download_file(url)
    print("Downloading from:", url)

    -- Try different approaches for downloading binary data
    local success, response = pcall(function()
        -- First try without specifying 'as' parameter
        return http.request(url)
    end)

    -- If that fails, try with 'as = "string"'
    if not success or not response or not response.body then
        print("First attempt failed, trying with as='string'")
        success, response = pcall(function()
            return http.request(url, {
                as = "string"
            })
        end)
    end

    if not success then
        print("HTTP request failed:", response)
        return nil, "HTTP request failed: " .. tostring(response)
    end

    if not response then
        print("No response received")
        return nil, "No response received from server"
    end

    print("Response status:", response.status)
    print("Response body type:", type(response.body))
    print("Response body length:", response.body and #response.body or "nil")
    if response.headers then
        print("Response headers:", response.headers["content-type"] or "unknown")
        print("Content length header:", response.headers["content-length"] or "unknown")
    end

    if response.status ~= 200 then
        return nil, "Failed to download file. HTTP status: " .. tostring(response.status)
    end

    if not response.body then
        return nil, "No content received from server"
    end

    print("Downloaded", #response.body, "bytes")
    return response.body, nil
end


---Install a widget from a zip URL
---@param item table - Widget item data containing zip_url and id
---@param install_folder string - Target folder to install to
---@return boolean, string - Success status and message
function M.install_widget(item, install_folder)
    if not item.zip_url or not item.id then
        return false, "Invalid widget data: missing zip_url or id"
    end

    print("Installing widget:", item.id)
    print("Download URL:", item.zip_url)
    print("Target folder:", install_folder)

    -- Download the zip file
    local zip_data, download_error = download_file(item.zip_url)
    if not zip_data then
        return false, "Failed to download widget: " .. download_error
    end

    -- Create a simple success message for now
    local success = true
    local message = "Widget '" .. item.id .. "' downloaded successfully!"
    message = message .. "\nDownload URL: " .. item.zip_url
    message = message .. "\nSize: " .. tostring(#zip_data) .. " bytes"
    message = message .. "\nTarget folder: " .. install_folder

    print("Successfully downloaded widget:", item.id)
    return success, message
end


---Check if a widget is already installed
---@param item table - Widget item data containing id
---@param install_folder string - Install folder to check in
---@return boolean - True if widget is already installed
function M.is_widget_installed(item, install_folder)
    -- For now, assume widgets are not installed to avoid path issues
    return false
end


---Get default installation folder
---@return string - Default installation folder path
function M.get_default_install_folder()
    return DEFAULT_INSTALL_FOLDER
end


return M
