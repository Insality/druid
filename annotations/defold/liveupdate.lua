--[[
  Generated with github.com/astrochili/defold-annotations
  Defold 1.8.0

  LiveUpdate API documentation

  Functions and constants to access resources.
--]]

---@diagnostic disable: lowercase-global
---@diagnostic disable: missing-return
---@diagnostic disable: duplicate-doc-param
---@diagnostic disable: duplicate-set-field

---@class defold_api.liveupdate
liveupdate = {}

---Mismatch between between expected bundled resources and actual bundled resources. The manifest expects a resource to be in the bundle, but it was not found in the bundle. This is typically the case when a non-excluded resource was modified between publishing the bundle and publishing the manifest.
liveupdate.LIVEUPDATE_BUNDLED_RESOURCE_MISMATCH = nil

---Mismatch between running engine version and engine versions supported by manifest.
liveupdate.LIVEUPDATE_ENGINE_VERSION_MISMATCH = nil

---Failed to parse manifest data buffer. The manifest was probably produced by a different engine version.
liveupdate.LIVEUPDATE_FORMAT_ERROR = nil

---Argument was invalid
liveupdate.LIVEUPDATE_INVAL = nil

---The handled resource is invalid.
liveupdate.LIVEUPDATE_INVALID_HEADER = nil

---The header of the resource is invalid.
liveupdate.LIVEUPDATE_INVALID_RESOURCE = nil

---I/O operation failed
liveupdate.LIVEUPDATE_IO_ERROR = nil

---Memory wasn't allocated
liveupdate.LIVEUPDATE_MEM_ERROR = nil

---LIVEUPDATE_OK
liveupdate.LIVEUPDATE_OK = nil

---Mismatch between scheme used to load resources. Resources are loaded with a different scheme than from manifest, for example over HTTP or directly from file. This is typically the case when running the game directly from the editor instead of from a bundle.
liveupdate.LIVEUPDATE_SCHEME_MISMATCH = nil

---Mismatch between manifest expected signature and actual signature.
liveupdate.LIVEUPDATE_SIGNATURE_MISMATCH = nil

---Unspecified error
liveupdate.LIVEUPDATE_UNKNOWN = nil

---Mismatch between manifest expected version and actual version.
liveupdate.LIVEUPDATE_VERSION_MISMATCH = nil

---Adds a resource mount to the resource system.
---The mounts are persisted between sessions.
---After the mount succeeded, the resources are available to load. (i.e. no reboot required)
---@param name string Unique name of the mount
---@param uri string The uri of the mount, including the scheme. Currently supported schemes are 'zip' and 'archive'.
---@param priority integer Priority of mount. Larger priority takes prescedence
---@param callback function Callback after the asynchronous request completed
---@return number result The result of the request
function liveupdate.add_mount(name, uri, priority, callback) end

---Return a reference to the Manifest that is currently loaded.
---@return number manifest_reference reference to the Manifest that is currently loaded
function liveupdate.get_current_manifest() end

---Get an array of the current mounts
---This can be used to determine if a new mount is needed or not
---@return array mounts Array of mounts
function liveupdate.get_mounts() end

---Is any liveupdate data mounted and currently in use?
---This can be used to determine if a new manifest or zip file should be downloaded.
---@return bool bool true if a liveupdate archive (any format) has been loaded
function liveupdate.is_using_liveupdate_data() end

---Remove a mount the resource system.
---The remaining mounts are persisted between sessions.
---Removing a mount does not affect any loaded resources.
---@param name string Unique name of the mount
---@return number result The result of the call
function liveupdate.remove_mount(name) end

---Stores a zip file and uses it for live update content. The contents of the
---zip file will be verified against the manifest to ensure file integrity.
---It is possible to opt out of the resource verification using an option passed
---to this function.
---The path is stored in the (internal) live update location.
---@param path string the path to the original file on disc
---@param callback fun(self, status) the callback function
---executed after the storage has completed
---
---self
---object The current object.
---status
---constant the status of the store operation (See liveupdate.store_manifest)
---
---@param options table|nil optional table with extra parameters. Supported entries:
---
---boolean verify: if archive should be verified as well as stored (defaults to true)
---
function liveupdate.store_archive(path, callback, options) end

---Create a new manifest from a buffer. The created manifest is verified
---by ensuring that the manifest was signed using the bundled public/private
---key-pair during the bundle process and that the manifest supports the current
---running engine version. Once the manifest is verified it is stored on device.
---The next time the engine starts (or is rebooted) it will look for the stored
---manifest before loading resources. Storing a new manifest allows the
---developer to update the game, modify existing resources, or add new
---resources to the game through LiveUpdate.
---@param manifest_buffer string the binary data that represents the manifest
---@param callback fun(self, status) the callback function
---executed once the engine has attempted to store the manifest.
---
---self
---object The current object.
---status
---constant the status of the store operation:
---
---
---liveupdate.LIVEUPDATE_OK
---liveupdate.LIVEUPDATE_INVALID_RESOURCE
---liveupdate.LIVEUPDATE_VERSION_MISMATCH
---liveupdate.LIVEUPDATE_ENGINE_VERSION_MISMATCH
---liveupdate.LIVEUPDATE_SIGNATURE_MISMATCH
---liveupdate.LIVEUPDATE_BUNDLED_RESOURCE_MISMATCH
---liveupdate.LIVEUPDATE_FORMAT_ERROR
---
function liveupdate.store_manifest(manifest_buffer, callback) end

---add a resource to the data archive and runtime index. The resource will be verified
---internally before being added to the data archive.
---@param manifest_reference number The manifest to check against.
---@param data string The resource data that should be stored.
---@param hexdigest string The expected hash for the resource,
---retrieved through collectionproxy.missing_resources.
---@param callback fun(self, hexdigest, status) The callback
---function that is executed once the engine has been attempted to store
---the resource.
---
---self
---object The current object.
---hexdigest
---string The hexdigest of the resource.
---status
---boolean Whether or not the resource was successfully stored.
---
function liveupdate.store_resource(manifest_reference, data, hexdigest, callback) end

return liveupdate