local component = require("druid.component")

---@class druid.image: druid.component
---@field root node
---@field private size vector3
---@field private texture_id string
---@field private adjust_mode number
local M = component.create("druid.image")

local REFERENCE_COUNTER = {}
local TEXTURE_DATA = {}

local SOCKET_IDS = {}
local SOCKET_IDS_COUNT = 0


---@param node_or_node_id node|string
function M:init(node_or_node_id)
	self.root = self:get_node(node_or_node_id)
	self.size = gui.get_size(self.root)
	self.adjust_mode = gui.get_adjust_mode(self.root)
end


function M:on_remove()
	self:_release_texture(self.texture_id)
end


function M:load_from_resource_path(resource_path)
	local texture_data = sys.load_resource(resource_path)
	if not texture_data then
		return
	end

	local texture_id = self:_process_texture_id(resource_path)
	self:_create_texture(texture_id, texture_data)
	self:_set_texture(texture_id)
end


function M:load_from_absolute_path(absolute_path)
	local file = io.open(absolute_path, "rb")
	if not file then
		return nil
	end

	local texture_data = file:read("*all")
	file:close()

	local texture_id = self:_process_texture_id(absolute_path)
	self:_create_texture(texture_id, texture_data)
	self:_set_texture(texture_id)
end


function M:load_from_url(url)
	local headers = nil
	local cache_path = self:_convert_url_to_absolute_path(url)

	local is_loaded_from_cache = self:load_from_absolute_path(cache_path)
	if is_loaded_from_cache then
		return
	end

	http.request(url, "GET", function(_, _, response)
		if response.status == 200 then
			self:load_from_absolute_path(cache_path)
		end
	end, headers, nil, { path = cache_path })
end


---@param texture_id string
---@param bytes string
---@return boolean
function M:_create_texture(texture_id, bytes)
	if self.texture_id then
		self:_release_texture(self.texture_id)
	end

	if REFERENCE_COUNTER[texture_id] then
		REFERENCE_COUNTER[texture_id] = REFERENCE_COUNTER[texture_id] + 1
		self.texture_id = texture_id
		return true
	end

	local texture_data = image.load(bytes)
	if not texture_data then
		TEXTURE_DATA[texture_id] = nil
		return false
	end

	local texture_created = gui.new_texture(texture_id, texture_data.width, texture_data.height, texture_data.type, texture_data.buffer, false)
	TEXTURE_DATA[texture_id] = texture_data
	if not texture_created then
		return false
	end

	REFERENCE_COUNTER[texture_id] = 1
	self.texture_id = texture_id

	return true
end


function M:_release_texture(texture_id)
	if not REFERENCE_COUNTER[texture_id] then
		return false
	end

	REFERENCE_COUNTER[texture_id] = REFERENCE_COUNTER[texture_id] - 1
	if REFERENCE_COUNTER[texture_id] <= 0 and TEXTURE_DATA[texture_id] then
		REFERENCE_COUNTER[texture_id] = nil
		TEXTURE_DATA[texture_id] = nil
		gui.delete_texture(texture_id)
	end

	return true
end


---@param texture_id string
function M:_set_texture(texture_id)
	gui.set_texture(self.root, texture_id)

	if self.adjust_mode == gui.ADJUST_FIT then
		local texture_data = TEXTURE_DATA[texture_id]
		local texture_width = texture_data.width
		local texture_height = texture_data.height

		-- Calculate scale to fit texture inside self.size while maintaining aspect ratio
		local scale_x = self.size.x / texture_width
		local scale_y = self.size.y / texture_height
		local scale = math.min(scale_x, scale_y)

		-- Set the new size maintaining aspect ratio
		local new_width = texture_width * scale
		local new_height = texture_height * scale

		gui.set_size(self.root, vmath.vector3(new_width, new_height, 0))
	end
end


---@param textures_refs table<string, number>
---@param texture_id string
---@return boolean
function M:_delete_texture(textures_refs, texture_id)
	if not textures_refs[texture_id] then
		return false
	end

	textures_refs[texture_id] = nil
	gui.delete_texture(texture_id)
	return true
end


---@param texture_id string
---@return string
function M:_process_texture_id(texture_id)
	local current_url = msg.url()
	local socket = current_url.socket
	local path = current_url.path

	SOCKET_IDS[socket] = SOCKET_IDS[socket] or {}
	if not SOCKET_IDS[socket][path] then
		 SOCKET_IDS[socket][path] = SOCKET_IDS_COUNT
		 SOCKET_IDS_COUNT = SOCKET_IDS_COUNT + 1
	end

	return SOCKET_IDS[socket][path] .. "#" .. texture_id
end


---@param url string
---@return string
function M:_convert_url_to_absolute_path(url)
	-- Use sys.get save path to generate a filename from url, replace all special characters with _
	local filename = url:gsub("[^a-zA-Z0-9_.-]", "_")
	return sys.get_save_file(sys.get_config_string("project.title"), filename)
end


return M
