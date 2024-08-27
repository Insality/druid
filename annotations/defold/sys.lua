--[[
  Generated with github.com/astrochili/defold-annotations
  Defold 1.8.0

  System API documentation

  Functions and messages for using system resources, controlling the engine,
  error handling and debugging.
--]]

---@diagnostic disable: lowercase-global
---@diagnostic disable: missing-return
---@diagnostic disable: duplicate-doc-param
---@diagnostic disable: duplicate-set-field

---@class defold_api.sys
sys = {}

---network connected through other, non cellular, connection
sys.NETWORK_CONNECTED = nil

---network connected through mobile cellular
sys.NETWORK_CONNECTED_CELLULAR = nil

---no network connection found
sys.NETWORK_DISCONNECTED = nil

---an asyncronous request is unable to read the resource
sys.REQUEST_STATUS_ERROR_IO_ERROR = nil

---an asyncronous request is unable to locate the resource
sys.REQUEST_STATUS_ERROR_NOT_FOUND = nil

---an asyncronous request has finished successfully
sys.REQUEST_STATUS_FINISHED = nil

---deserializes buffer into a lua table
---@param buffer string buffer to deserialize from
---@return table table lua table with deserialized data
function sys.deserialize(buffer) end

---Check if a path exists
---Good for checking if a file exists before loading a large file
---@param path string path to check
---@return bool result true if the path exists, false otherwise
function sys.exists(path) end

---Terminates the game application and reports the specified code to the OS.
---@param code number exit code to report to the OS, 0 means clean exit
function sys.exit(code) end

---Returns a table with application information for the requested app.
--- On iOS, the app_string is an url scheme for the app that is queried. Your
---game needs to list the schemes that are queried in an LSApplicationQueriesSchemes array
---in a custom "Info.plist".
--- On Android, the app_string is the package identifier for the app.
---@param app_string string platform specific string with application package or query, see above for details.
---@return { installed:boolean } app_info table with application information in the following fields:
---
---installed
---boolean true if the application is installed, false otherwise.
---
function sys.get_application_info(app_string) end

---The path from which the application is run.
---@return string path path to application executable
function sys.get_application_path() end

---Get integer config value from the game.project configuration file with optional default value
---@param key string key to get value for. The syntax is SECTION.KEY
---@param default_value integer|nil (optional) default value to return if the value does not exist
---@return integer value config value as an integer. default_value if the config key does not exist. 0 if no default value was supplied.
function sys.get_config_int(key, default_value) end

---Get number config value from the game.project configuration file with optional default value
---@param key string key to get value for. The syntax is SECTION.KEY
---@param default_value number|nil (optional) default value to return if the value does not exist
---@return number value config value as an number. default_value if the config key does not exist. 0 if no default value was supplied.
function sys.get_config_number(key, default_value) end

---Get string config value from the game.project configuration file with optional default value
---@param key string key to get value for. The syntax is SECTION.KEY
---@param default_value string|nil (optional) default value to return if the value does not exist
---@return string value config value as a string. default_value if the config key does not exist. nil if no default value was supplied.
function sys.get_config_string(key, default_value) end

---  Returns the current network connectivity status
---on mobile platforms.
---On desktop, this function always return sys.NETWORK_CONNECTED.
---@return constant status network connectivity status:
---
---sys.NETWORK_DISCONNECTED (no network connection is found)
---sys.NETWORK_CONNECTED_CELLULAR (connected through mobile cellular)
---sys.NETWORK_CONNECTED (otherwise, Wifi)
---
function sys.get_connectivity() end

---Returns a table with engine information.
---@return { version:string, version_sha1:string, is_debug:boolean } engine_info table with engine information in the following fields:
---
---version
---string The current Defold engine version, i.e. "1.2.96"
---version_sha1
---string The SHA1 for the current engine build, i.e. "0060183cce2e29dbd09c85ece83cbb72068ee050"
---is_debug
---boolean If the engine is a debug or release version
---
function sys.get_engine_info() end

---Create a path to the host device for unit testing
---Useful for saving logs etc during development
---@param filename string file to read from
---@return string host_path the path prefixed with the proper host mount
function sys.get_host_path(filename) end

---Returns an array of tables with information on network interfaces.
---@return { name:string, address:string|nil, mac:string|nil, up:boolean, running:boolean } ifaddrs an array of tables. Each table entry contain the following fields:
---
---name
---string Interface name
---address
---string IP address.  might be nil if not available.
---mac
---string Hardware MAC address.  might be nil if not available.
---up
---boolean true if the interface is up (available to transmit and receive data), false otherwise.
---running
---boolean true if the interface is running, false otherwise.
---
function sys.get_ifaddrs() end

---The save-file path is operating system specific and is typically located under the user's home directory.
---@param application_id string user defined id of the application, which helps define the location of the save-file
---@param file_name string file-name to get path for
---@return string path path to save-file
function sys.get_save_file(application_id, file_name) end

---Returns a table with system information.
---@param options { ignore_secure:boolean|nil }|nil optional options table
---- ignore_secure boolean this flag ignores values might be secured by OS e.g. device_ident
---@return { device_model:string|nil, manufacturer:string|nil, system_name:string, system_version:string, api_version:string, language:string, device_language:string, territory:string, gmt_offset:number, device_ident:string|nil, user_agent:string|nil } sys_info table with system information in the following fields:
---
---device_model
---string  Only available on iOS and Android.
---manufacturer
---string  Only available on iOS and Android.
---system_name
---string The system name: "Darwin", "Linux", "Windows", "HTML5", "Android" or "iPhone OS"
---system_version
---string The system OS version.
---api_version
---string The API version on the system.
---language
---string Two character ISO-639 format, i.e. "en".
---device_language
---string Two character ISO-639 format (i.e. "sr") and, if applicable, followed by a dash (-) and an ISO 15924 script code (i.e. "sr-Cyrl" or "sr-Latn"). Reflects the device preferred language.
---territory
---string Two character ISO-3166 format, i.e. "US".
---gmt_offset
---number The current offset from GMT (Greenwich Mean Time), in minutes.
---device_ident
---string This value secured by OS.  "identifierForVendor" on iOS.  "android_id" on Android. On Android, you need to add READ_PHONE_STATE permission to be able to get this data. We don't use this permission in Defold.
---user_agent
---string  The HTTP user agent, i.e. "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_3) AppleWebKit/602.4.8 (KHTML, like Gecko) Version/10.0.3 Safari/602.4.8"
---
function sys.get_sys_info(options) end

---If the file exists, it must have been created by sys.save to be loaded.
---@param filename string file to read from
---@return table loaded lua table, which is empty if the file could not be found
function sys.load(filename) end

---The sys.load_buffer function will first try to load the resource
---from any of the mounted resource locations and return the data if
---any matching entries found. If not, the path will be tried
---as is from the primary disk on the device.
---In order for the engine to include custom resources in the build process, you need
---to specify them in the "custom_resources" key in your "game.project" settings file.
---You can specify single resource files or directories. If a directory is included
---in the resource list, all files and directories in that directory is recursively
---included:
---For example "main/data/,assets/level_data.json".
---@param path string the path to load the buffer from
---@return buffer_data buffer the buffer with data
function sys.load_buffer(path) end

---The sys.load_buffer function will first try to load the resource
---from any of the mounted resource locations and return the data if
---any matching entries found. If not, the path will be tried
---as is from the primary disk on the device.
---In order for the engine to include custom resources in the build process, you need
---to specify them in the "custom_resources" key in your "game.project" settings file.
---You can specify single resource files or directories. If a directory is included
---in the resource list, all files and directories in that directory is recursively
---included:
---For example "main/data/,assets/level_data.json".
---Note that issuing multiple requests of the same resource will yield
---individual buffers per request. There is no implic caching of the buffers
---based on request path.
---@param path string the path to load the buffer from
---@param status_callback fun(self, request_id, result) A status callback that will be invoked when a request has been handled, or an error occured. The result is a table containing:
---
---status
---number The status of the request, supported values are:
---
---
---resource.REQUEST_STATUS_FINISHED
---resource.REQUEST_STATUS_ERROR_IO_ERROR
---resource.REQUEST_STATUS_ERROR_NOT_FOUND
---
---
---buffer
---buffer If the request was successfull, this will contain the request payload in a buffer object, and nil otherwise. Make sure to check the status before doing anything with the buffer value!
---
---@return resource_handle handle a handle to the request
function sys.load_buffer_async(path, status_callback) end

---Loads a custom resource. Specify the full filename of the resource that you want
---to load. When loaded, the file data is returned as a string.
---If loading fails, the function returns nil plus the error message.
---In order for the engine to include custom resources in the build process, you need
---to specify them in the "custom_resources" key in your "game.project" settings file.
---You can specify single resource files or directories. If a directory is included
---in the resource list, all files and directories in that directory is recursively
---included:
---For example "main/data/,assets/level_data.json".
---@param filename string resource to load, full path
---@return string|nil data loaded data, or nil if the resource could not be loaded
---@return string|nil error the error message, or nil if no error occurred
function sys.load_resource(filename) end

---Open URL in default application, typically a browser
---@param url string url to open
---@param attributes { target:string|nil, name:string|nil }|nil table with attributes
---target
---- string : Optional. Specifies the target attribute or the name of the window. The following values are supported:
---- _self - (default value) URL replaces the current page.
---- _blank - URL is loaded into a new window, or tab.
---- _parent - URL is loaded into the parent frame.
---- _top - URL replaces any framesets that may be loaded.
---- name - The name of the window (Note: the name does not specify the title of the new window).
---@return boolean success a boolean indicating if the url could be opened or not
function sys.open_url(url, attributes) end

---Reboots the game engine with a specified set of arguments.
---Arguments will be translated into command line arguments. Calling reboot
---function is equivalent to starting the engine with the same arguments.
---On startup the engine reads configuration from "game.project" in the
---project root.
---@param arg1 string|nil argument 1
---@param arg2 string|nil argument 2
---@param arg3 string|nil argument 3
---@param arg4 string|nil argument 4
---@param arg5 string|nil argument 5
---@param arg6 string|nil argument 6
function sys.reboot(arg1, arg2, arg3, arg4, arg5, arg6) end

---The table can later be loaded by sys.load.
---Use sys.get_save_file to obtain a valid location for the file.
---Internally, this function uses a workspace buffer sized output file sized 512kb.
---This size reflects the output file size which must not exceed this limit.
---Additionally, the total number of rows that any one table may contain is limited to 65536
---(i.e. a 16 bit range). When tables are used to represent arrays, the values of
---keys are permitted to fall within a 32 bit range, supporting sparse arrays, however
---the limit on the total number of rows remains in effect.
---@param filename string file to write to
---@param table table lua table to save
---@return boolean success a boolean indicating if the table could be saved or not
function sys.save(filename, table) end

---The buffer can later deserialized by sys.deserialize.
---This method has all the same limitations as sys.save.
---@param table table lua table to serialize
---@return string buffer serialized data buffer
function sys.serialize(table) end

---Sets the host that is used to check for network connectivity against.
---@param host string hostname to check against
function sys.set_connectivity_host(host) end

---Set the Lua error handler function.
---The error handler is a function which is called whenever a lua runtime error occurs.
---@param error_handler fun(source, message, traceback) the function to be called on error
---
---source
---string The runtime context of the error. Currently, this is always "lua".
---message
---string The source file, line number and error message.
---traceback
---string The stack traceback.
---
function sys.set_error_handler(error_handler) end

---Set game update-frequency (frame cap). This option is equivalent to display.update_frequency in
---the "game.project" settings but set in run-time. If Vsync checked in "game.project", the rate will
---be clamped to a swap interval that matches any detected main monitor refresh rate. If Vsync is
---unchecked the engine will try to respect the rate in software using timers. There is no
---guarantee that the frame cap will be achieved depending on platform specifics and hardware settings.
---@param frequency number target frequency. 60 for 60 fps
function sys.set_update_frequency(frequency) end

---Set the vsync swap interval. The interval with which to swap the front and back buffers
---in sync with vertical blanks (v-blank), the hardware event where the screen image is updated
---with data from the front buffer. A value of 1 swaps the buffers at every v-blank, a value of
---2 swaps the buffers every other v-blank and so on. A value of 0 disables waiting for v-blank
---before swapping the buffers. Default value is 1.
---When setting the swap interval to 0 and having vsync disabled in
---"game.project", the engine will try to respect the set frame cap value from
---"game.project" in software instead.
---This setting may be overridden by driver settings.
---@param swap_interval number target swap interval.
function sys.set_vsync_swap_interval(swap_interval) end

return sys