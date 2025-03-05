# Druid Hotkey Component

## Description

The Hotkey component provides a way to handle keyboard shortcuts in your UI. It allows you to define specific key combinations that trigger actions, making your UI more accessible and efficient for keyboard users.

## Features

- Support for single key and key combination shortcuts
- Customizable callback functions
- Optional key modifiers (shift, ctrl, alt)
- Ability to enable/disable hotkeys
- Events for hotkey triggers

## Basic Usage

```lua
-- Create a hotkey for the 'Enter' key
local hotkey = self.druid:new_hotkey("key_enter", function(self)
    -- Handle Enter key press
    print("Enter key pressed!")
end)

-- Create a hotkey with modifiers (Ctrl+S)
local save_hotkey = self.druid:new_hotkey({
    key = "key_s",
    modifier = "key_ctrl"
}, function(self)
    -- Handle Ctrl+S key combination
    print("Ctrl+S pressed - saving...")
end)
```

### Parameters

- **key_trigger**: The key or key combination to trigger the hotkey
  - Can be a string for a single key (e.g., "key_enter")
  - Can be a table for key combinations (e.g., {key = "key_s", modifier = "key_ctrl"})
- **callback**: (optional) Function to call when the hotkey is triggered

## Methods

```lua
-- Enable the hotkey
hotkey:set_enabled(true)

-- Disable the hotkey
hotkey:set_enabled(false)

-- Check if hotkey is enabled
local is_enabled = hotkey:is_enabled()

-- Trigger the hotkey programmatically
hotkey:trigger()
```

## Events

```lua
-- Subscribe to hotkey trigger event
hotkey.on_pressed:subscribe(function(self)
    print("Hotkey was triggered")
end)
```

## Key Combinations

The component supports various key combinations:

```lua
-- Single key
local hotkey1 = self.druid:new_hotkey("key_space", callback)

-- Key with modifier
local hotkey2 = self.druid:new_hotkey({
    key = "key_s",
    modifier = "key_ctrl"
}, callback)

-- Key with multiple modifiers
local hotkey3 = self.druid:new_hotkey({
    key = "key_s",
    modifier = {"key_ctrl", "key_shift"}
}, callback)
```

## Examples

```lua
-- Create navigation hotkeys
local next_hotkey = self.druid:new_hotkey("key_right", function()
    navigate_to_next_page()
end)

local prev_hotkey = self.druid:new_hotkey("key_left", function()
    navigate_to_previous_page()
end)

-- Create application shortcuts
local save_hotkey = self.druid:new_hotkey({
    key = "key_s",
    modifier = "key_ctrl"
}, function()
    save_document()
end)

local undo_hotkey = self.druid:new_hotkey({
    key = "key_z",
    modifier = "key_ctrl"
}, function()
    undo_last_action()
end)

-- Create a help dialog hotkey
local help_hotkey = self.druid:new_hotkey("key_f1", function()
    show_help_dialog()
end)
```

## Notes

- The Hotkey component requires proper key triggers setup in your `input.binding` file
- Hotkeys are global by default and will trigger regardless of UI focus
- You can enable/disable hotkeys based on context (e.g., disable certain hotkeys when a dialog is open)
- Key names should match the action IDs defined in your input bindings
- Common key names include:
  - Navigation: "key_up", "key_down", "key_left", "key_right"
  - Modifiers: "key_ctrl", "key_shift", "key_alt"
  - Function keys: "key_f1", "key_f2", etc.
  - Special keys: "key_enter", "key_space", "key_escape", "key_backspace"
- The component handles both key press and key release events
- Hotkeys are a great way to improve accessibility and user experience for keyboard users
