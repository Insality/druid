local event = require("event.event")
local helper = require("druid.helper")
local component = require("druid.component")

---@class druid.hotkey.style
---@field MODIFICATORS string[]|hash[] The list of action_id as hotkey modificators

---Druid component to manage hotkeys and trigger callbacks when hotkeys are pressed.
---
---### Setup
---Create hotkey component with druid: `hotkey = druid:new_hotkey(keys, callback, callback_argument)`
---
---### Notes
---- Hotkey can be triggered by pressing a single key or a combination of keys
---- Hotkey supports modificator keys (e.g. Ctrl, Shift, Alt)
---- Hotkey can be triggered on key press, release or repeat
---- Hotkey can be added or removed at runtime
---- Hotkey can be enabled or disabled
---- Hotkey can be set to repeat on key hold
---@class druid.hotkey: druid.component
---@field on_hotkey_pressed event fun(self, context, callback_argument) The event triggered when a hotkey is pressed
---@field on_hotkey_released event fun(self, context, callback_argument) The event triggered when a hotkey is released
---@field style druid.hotkey.style The style of the hotkey component
---@field private _hotkeys table The list of hotkeys
---@field private _modificators table The list of modificators
---@field private _node node|nil The node to bind the hotkey to
local M = component.create("hotkey")


---The Hotkey constructor
---@param keys string[]|string The keys to be pressed for trigger callback. Should contains one key and any modificator keys
---@param callback function The callback function
---@param callback_argument any|nil The argument to pass into the callback function
function M:init(keys, callback, callback_argument)
	self.druid = self:get_druid()

	self._hotkeys = {}
	self._modificators = {}
	self._node = nil
	self.on_hotkey_pressed = event.create()
	self.on_hotkey_released = event.create(callback)

	if keys then
		self:add_hotkey(keys, callback_argument)
	end
end


---@private
---@param style druid.hotkey.style
function M:on_style_change(style)
	self.style = {
		MODIFICATORS = style.MODIFICATORS or {},
	}

	for index = 1, #style.MODIFICATORS do
		local modificator = style.MODIFICATORS[index]
		if type(modificator) == "string" then
			self.style.MODIFICATORS[index] = hash(modificator)
		end
	end
end


---Add hotkey for component callback
---@param keys string[]|hash[]|string|hash that have to be pressed before key pressed to activate
---@param callback_argument any|nil The argument to pass into the callback function
---@return druid.hotkey self Current instance
function M:add_hotkey(keys, callback_argument)
	keys = keys or {}
	if type(keys) == "string" then
		keys = { keys }
	end

	local modificators = {}
	local key = nil

	---@cast keys string[]
	for index = 1, #keys do
		local key_hash = hash(keys[index])
		if #keys > 1 and helper.contains(self.style.MODIFICATORS, key_hash) then
			table.insert(modificators, key_hash)
		else
			if not key then
				key = key_hash
			else
				error("The hotkey keys should contains only one key (except modificator keys)")
			end
		end
	end

	table.insert(self._hotkeys, {
		modificators = modificators,
		key = key,
		is_processing = false,
		callback_argument = callback_argument,
	})

	-- Current hotkey status
	local mods = self.style.MODIFICATORS ---@type string[]
	for index = 1, #mods do
		local modificator = hash(mods[index])
		self._modificators[modificator] = self._modificators[modificator] or false
	end

	return self
end


function M:is_processing()
	for index = 1, #self._hotkeys do
		if self._hotkeys[index].is_processing then
			return true
		end
	end

	return false
end


---@private
function M:on_focus_gained()
	for k, v in pairs(self._modificators) do
		self._modificators[k] = false
	end
end


---@private
---@param action_id hash|nil The action id
---@param action action The action
---@return boolean is_consume True if the action is consumed
function M:on_input(action_id, action)
	if not action_id then
		return false
	end

	if self._node and not gui.is_enabled(self._node, true) then
		return false
	end

	if self._modificators[action_id] ~= nil and action.pressed then
		self._modificators[action_id] = true
	end

	for index = 1, #self._hotkeys do
		local hotkey = self._hotkeys[index]
		local is_relative_key = helper.contains(self.style.MODIFICATORS, action_id) or action_id == hotkey.key

		if is_relative_key and (action_id == hotkey.key or not hotkey.key) then
			local is_modificator_ok = true
			local is_consume = not not (hotkey.key)

			-- Check only required modificators pressed
			if hotkey.key and #hotkey.modificators > 0 then
				for i = 1, #self.style.MODIFICATORS do
					local mod = self.style.MODIFICATORS[i]
					if helper.contains(hotkey.modificators, mod) and self._modificators[mod] == false then
						is_modificator_ok = false
					end
					if not helper.contains(hotkey.modificators, mod) and self._modificators[mod] == true then
						is_modificator_ok = false
					end
				end
			end

			if action.pressed and is_modificator_ok then
				hotkey.is_processing = true
				self.on_hotkey_pressed:trigger(self:get_context(), hotkey.callback_argument)
			end
			if not action.pressed and self._is_process_repeated and action.repeated and is_modificator_ok and hotkey.is_processing then
				self.on_hotkey_released:trigger(self:get_context(), hotkey.callback_argument)
				return is_consume
			end
			if action.released and is_modificator_ok and hotkey.is_processing then
				self.on_hotkey_released:trigger(self:get_context(), hotkey.callback_argument)
				hotkey.is_processing = false
				return is_consume
			end
		end
	end

	if self._modificators[action_id] ~= nil and action.released then
		self._modificators[action_id] = false
	end

	return false
end


---If true, the callback will be triggered on action.repeated
---@param is_enabled_repeated boolean The flag value
---@return druid.hotkey self Current instance
function M:set_repeat(is_enabled_repeated)
	self._is_process_repeated = is_enabled_repeated
	return self
end


---If node is provided, the hotkey can be disabled, if the node is disabled
---@param node node|nil The node to bind the hotkey to. Nil to unbind the node
---@return druid.hotkey self Current instance
function M:bind_node(node)
	self._node = node

	return self
end


return M
