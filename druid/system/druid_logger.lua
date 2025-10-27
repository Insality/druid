local helper = require("druid.helper")

---@class druid.logger
---@field trace fun(_, msg: string, data: any)
---@field debug fun(_, msg: string, data: any)
---@field info fun(_, msg: string, data: any)
---@field warn fun(_, msg: string, data: any)
---@field error fun(_, msg: string, data: any)
local M = {}

local EMPTY_FUNCTION = function(_, message, context) end

---@type druid.logger
local empty_logger = {
	trace = EMPTY_FUNCTION,
	debug = EMPTY_FUNCTION,
	info = EMPTY_FUNCTION,
	warn = EMPTY_FUNCTION,
	error = EMPTY_FUNCTION,
}

---@type druid.logger
local default_logger = {
	trace = function(_, msg, data) print("TRACE: " .. msg, helper.table_to_string(data)) end,
	debug = function(_, msg, data) print("DEBUG: " .. msg, helper.table_to_string(data)) end,
	info = function(_, msg, data) print("INFO: " .. msg, helper.table_to_string(data)) end,
	warn = function(_, msg, data) print("WARN: " .. msg, helper.table_to_string(data)) end,
	error = function(_, msg, data) print("ERROR: " .. msg, helper.table_to_string(data)) end
}

local METATABLE = { __index = default_logger }

---@param logger druid.logger|table|nil
function M.set_logger(logger)
	METATABLE.__index = logger or empty_logger
end


return setmetatable(M, METATABLE)
