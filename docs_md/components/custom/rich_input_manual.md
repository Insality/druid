# Druid Rich Input Component

## Description

The Rich Input component provides an enhanced text input field with advanced features like text selection, cursor positioning, and placeholder text. It extends the basic Input component to offer a more sophisticated text entry experience.

## Features

- Text input with cursor support
- Text selection capabilities
- Customizable placeholder text
- Maximum length restriction
- Input validation and filtering
- Events for text changes and interactions
- Support for multiline input
- Customizable visual feedback

## Basic Usage

```lua
-- Create a basic rich input
local rich_input = self.druid:new_rich_input("input_node", "input_text_node")

-- Set initial text
rich_input:set_text("Initial text")

-- Set placeholder text
rich_input:set_placeholder("Enter text here...")
```

### Parameters

- **node**: The node or node_id of the input background
- **text_node**: The node or node_id of the text component
- **keyboard_type**: (optional) The type of keyboard to show on mobile devices

## Methods

```lua
-- Set input text
rich_input:set_text("New text")

-- Get current text
local text = rich_input:get_text()

-- Clear input
rich_input:clear()

-- Set maximum text length
rich_input:set_max_length(50)

-- Set input validation pattern
rich_input:set_allowed_characters("[%w%s]") -- Only alphanumeric and spaces

-- Set placeholder text
rich_input:set_placeholder("Enter text here...")

-- Set placeholder color
rich_input:set_placeholder_color(vmath.vector4(0.5, 0.5, 0.5, 1))

-- Enable/disable multiline input
rich_input:set_multiline(true)
rich_input:set_multiline(false)

-- Enable/disable the input
rich_input:set_enabled(true)
rich_input:set_enabled(false)

-- Check if input is enabled
local is_enabled = rich_input:is_enabled()

-- Set input focus
rich_input:set_focus()

-- Remove input focus
rich_input:remove_focus()

-- Check if input has focus
local has_focus = rich_input:is_focused()

-- Select all text
rich_input:select_all()

-- Set cursor position
rich_input:set_cursor_position(5)

-- Set selection range
rich_input:set_selection(2, 5) -- Select characters from index 2 to 5

-- Get current selection
local selection_start, selection_end = rich_input:get_selection()
```

## Events

```lua
-- Subscribe to text change event
rich_input.on_input_text:subscribe(function(self, text)
    print("Text changed to: " .. text)
end)

-- Subscribe to focus events
rich_input.on_focus:subscribe(function(self)
    print("Input gained focus")
end)

rich_input.on_focus_lost:subscribe(function(self)
    print("Input lost focus")
end)

-- Subscribe to input submit event (Enter key)
rich_input.on_submit:subscribe(function(self)
    print("Input submitted with text: " .. self:get_text())
end)

-- Subscribe to input canceled event (Escape key)
rich_input.on_cancel:subscribe(function(self)
    print("Input canceled")
end)

-- Subscribe to selection change event
rich_input.on_selection_change:subscribe(function(self, start, end_pos)
    print("Selection changed: " .. start .. " to " .. end_pos)
end)

-- Subscribe to cursor position change event
rich_input.on_cursor_change:subscribe(function(self, position)
    print("Cursor position: " .. position)
end)
```

## Examples

```lua
-- Create a username input with validation
local username_input = self.druid:new_rich_input("username_bg", "username_text")
username_input:set_placeholder("Username")
username_input:set_allowed_characters("[%w_]") -- Only alphanumeric and underscore
username_input:set_max_length(20)

-- Create a password input
local password_input = self.druid:new_rich_input("password_bg", "password_text")
password_input:set_placeholder("Password")
password_input:set_password(true)
password_input:set_password_char("•")

-- Create a multiline text area
local text_area = self.druid:new_rich_input("textarea_bg", "textarea_text")
text_area:set_multiline(true)
text_area:set_placeholder("Enter your message here...")

-- Create a search input with clear button
local search_input = self.druid:new_rich_input("search_bg", "search_text")
search_input:set_placeholder("Search...")

local clear_button = self.druid:new_button("clear_button", function()
    search_input:clear()
    search_input:set_focus()
end)

-- Create an input with selection handling
local editor_input = self.druid:new_rich_input("editor_bg", "editor_text")
editor_input.on_selection_change:subscribe(function(self, start, end_pos)
    if start ~= end_pos then
        -- Text is selected
        show_formatting_toolbar()
    else
        -- No selection
        hide_formatting_toolbar()
    end
end)

-- Format selected text
function format_bold()
    local start, end_pos = editor_input:get_selection()
    if start ~= end_pos then
        local text = editor_input:get_text()
        local selected_text = text:sub(start, end_pos)
        local new_text = text:sub(1, start-1) .. "**" .. selected_text .. "**" .. text:sub(end_pos+1)
        editor_input:set_text(new_text)
        editor_input:set_selection(start, end_pos + 4) -- Adjust selection to include formatting
    end
end
```

## Notes

- The Rich Input component extends the basic Input component with enhanced selection and cursor capabilities
- The placeholder text is shown when the input is empty and doesn't have focus
- Text selection can be done via mouse/touch drag or programmatically
- The component handles cursor positioning and blinking
- Input validation can be used to restrict what characters users can enter
- For multiline input, the component supports line breaks and scrolling
- The component provides events for all major input interactions, allowing you to create responsive forms
- Selection and cursor position are reported in character indices, not pixel positions
- The component handles clipboard operations (copy, cut, paste) on supported platforms
- For best user experience, consider providing visual feedback for selection and cursor position
