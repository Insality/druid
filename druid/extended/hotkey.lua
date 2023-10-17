-- Copyright (c) 2021 Maksim Tuprikov <insality@gmail.com>. This code is licensed under MIT license

--- Druid hotkey component
--
-- <a href="https://insality.github.io/druid/druid/index.html?example=general_hotkey" target="_blank"><b>Example Link</b></a>
-- @module Hotkey
-- @within BaseComponent
-- @alias druid.hotkey

--- On change state callback(self, state)
-- @tfield DruidEvent on_change_state @{DruidEvent}

--- Visual node
-- @tfield node node

--- Button trigger node
-- @tfield[opt=node] node click_node

--- Button component from click_node
-- @tfield Button button @{Button}

---

local helper = require("druid.helper")
local component = require("druid.component")

local Hotkey = component.create("hotkey")


--- The @{Hotkey} constructor
-- @tparam Hotkey self @{Hotkey}
-- @tparam string[]|string keys The keys to be pressed for trigger callback. Should contains one key and any modificator keys
-- @tparam function callback The callback function
-- @tparam any|nil callback_argument The argument to pass into the callback function
function Hotkey.init(self, keys, callback, callback_argument)
	self.druid = self:get_druid()

	self._hotkeys = {}
	self._modificators = {}
	self._callback = callback

	if keys then
		self:add_hotkey(keys, callback_argument)
	end
end


--- Component style params.
-- You can override this component styles params in druid styles table
-- or create your own style
-- @table style
-- @tfield string[] MODIFICATORS The list of action_id as hotkey modificators
function Hotkey.on_style_change(self, style)
	self.style = {}
	self.style.MODIFICATORS = style.MODIFICATORS or {}

	for index = 1, #style.MODIFICATORS do
		self.style.MODIFICATORS[index] = hash(self.style.MODIFICATORS[index])
	end
end


--- Add hotkey for component callback
-- @tparam Hotkey self @{Hotkey}
-- @tparam string[]|hash[]|string|hash keys that have to be pressed before key pressed to activate
-- @tparam any|nil callback_argument The argument to pass into the callback function
function Hotkey.add_hotkey(self, keys, callback_argument)
	keys = keys or {}
	if type(keys) == "string" then
		keys = { keys }
	end

	local modificators = {}
	local key = nil

	for index = 1, #keys do
		local key_hash = hash(keys[index])
		if helper.contains(self.style.MODIFICATORS, key_hash) then
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
	for index = 1, #self.style.MODIFICATORS do
		local modificator = hash(self.style.MODIFICATORS[index])
		self._modificators[modificator] = self._modificators[modificator] or false
	end

	return self
end


function Hotkey.on_input(self, action_id, action)
	if not action_id then
		return false
	end

	if self._modificators[action_id] ~= nil then
		if action.pressed then
			self._modificators[action_id] = true
		end
		if action.released then
			self._modificators[action_id] = false
		end
	end

	for index = 1, #self._hotkeys do
		local hotkey = self._hotkeys[index]
		if action_id == hotkey.key then
			local is_modificator_ok = true

			-- Check only required modificators pressed
			for i = 1, #self.style.MODIFICATORS do
				local mod = self.style.MODIFICATORS[i]
				if helper.contains(hotkey.modificators, mod) and self._modificators[mod] == false then
					is_modificator_ok = false
				end
				if not helper.contains(hotkey.modificators, mod) and self._modificators[mod] == true then
					is_modificator_ok = false
				end
			end

			if action.pressed and is_modificator_ok then
				hotkey.is_processing = true
			end
			if action.released and is_modificator_ok and hotkey.is_processing then
				hotkey.is_processing = false
				if hotkey.callback_argument then
					self._callback(self:get_context(), hotkey.callback_argument)
					return true
				else
					self._callback(self:get_context())
					return true
				end
			end
		end
	end

	return false
end


return Hotkey
