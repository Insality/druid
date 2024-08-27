--[[
  Generated with github.com/astrochili/defold-annotations
  Defold 1.8.0

  Crash API documentation

  Native crash logging functions and constants.
--]]

---@diagnostic disable: lowercase-global
---@diagnostic disable: missing-return
---@diagnostic disable: duplicate-doc-param
---@diagnostic disable: duplicate-set-field

---@class defold_api.crash
crash = {}

---android build fingerprint
crash.SYSFIELD_ANDROID_BUILD_FINGERPRINT = nil

---system device language as reported by sys.get_sys_info
crash.SYSFIELD_DEVICE_LANGUAGE = nil

---device model as reported by sys.get_sys_info
crash.SYSFIELD_DEVICE_MODEL = nil

---engine version as hash
crash.SYSFIELD_ENGINE_HASH = nil

---engine version as release number
crash.SYSFIELD_ENGINE_VERSION = nil

---system language as reported by sys.get_sys_info
crash.SYSFIELD_LANGUAGE = nil

---device manufacturer as reported by sys.get_sys_info
crash.SYSFIELD_MANUFACTURER = nil

---The max number of sysfields.
crash.SYSFIELD_MAX = nil

---system name as reported by sys.get_sys_info
crash.SYSFIELD_SYSTEM_NAME = nil

---system version as reported by sys.get_sys_info
crash.SYSFIELD_SYSTEM_VERSION = nil

---system territory as reported by sys.get_sys_info
crash.SYSFIELD_TERRITORY = nil

---The max number of user fields.
crash.USERFIELD_MAX = nil

---The max size of a single user field.
crash.USERFIELD_SIZE = nil

---A table is returned containing the addresses of the call stack.
---@param handle number crash dump handle
---@return table backtrace table containing the backtrace
function crash.get_backtrace(handle) end

---The format of read text blob is platform specific
---and not guaranteed
---but can be useful for manual inspection.
---@param handle number crash dump handle
---@return string blob string with the platform specific data
function crash.get_extra_data(handle) end

---The function returns a table containing entries with sub-tables that
---have fields 'name' and 'address' set for all loaded modules.
---@param handle number crash dump handle
---@return { name:string, address:string }[] modules module table
function crash.get_modules(handle) end

---read signal number from a crash report
---@param handle number crash dump handle
---@return number signal signal number
function crash.get_signum(handle) end

---reads a system field from a loaded crash dump
---@param handle number crash dump handle
---@param index number system field enum. Must be less than crash.SYSFIELD_MAX
---@return string|nil value value recorded in the crash dump, or nil if it didn't exist
function crash.get_sys_field(handle, index) end

---reads user field from a loaded crash dump
---@param handle number crash dump handle
---@param index number user data slot index
---@return string value user data value recorded in the crash dump
function crash.get_user_field(handle, index) end

---The crash dump will be removed from disk upon a successful
---load, so loading is one-shot.
---@return number|nil handle handle to the loaded dump, or nil if no dump was found
function crash.load_previous() end

---releases a previously loaded crash dump
---@param handle number handle to loaded crash dump
function crash.release(handle) end

---Crashes occuring before the path is set will be stored to a default engine location.
---@param path string file path to use
function crash.set_file_path(path) end

---Store a user value that will get written to a crash dump when
---a crash occurs. This can be user id:s, breadcrumb data etc.
---There are 32 slots indexed from 0. Each slot stores at most 255 characters.
---@param index number slot index. 0-indexed
---@param value string string value to store
function crash.set_user_field(index, value) end

---Performs the same steps as if a crash had just occured but
---allows the program to continue.
---The generated dump can be read by crash.load_previous
function crash.write_dump() end

return crash