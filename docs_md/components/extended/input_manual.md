# Druid Input Component

## Description

The Input component provides a way to handle text input in your UI. It allows users to enter and edit text, with support for various input features like text selection, cursor positioning, and input validation.

## Features

- Text input handling with cursor support
- Text selection capabilities
- Input validation and filtering
- Maximum length restriction
- Password mode with character masking
- Events for text changes and interactions
- Support for multiline input
- Customizable visual feedback

## Basic Usage

```lua
-- Create a basic text input
local input = self.druid:new_input("input_node", "input_text_node")

-- Set initial text
input:set_text("Initial text")
```

### Parameters

- **node**: The node or node_id of the input background
- **text_node**: The node or node_id of the text component
- **keyboard_type**: (optional) The type of keyboard to show on mobile devices

## Methods

```lua
-- Set input text
input:set_text("New text")

-- Get current text
local text = input:get_text()

-- Clear input
input:clear()

-- Set maximum text length
input:set_max_length(50)

-- Set input validation pattern
input:set_allowed_characters("[%w%s]") -- Only alphanumeric and spaces

-- Enable/disable password mode
input:set_password(true) -- Enable password mode
input:set_password(false) -- Disable password mode

-- Set password character
input:set_password_char("*")

-- Set placeholder text (shown when input is empty)
input:set_placeholder("Enter text here...")

-- Set placeholder color
input:set_placeholder_color(vmath.vector4(0.5, 0.5, 0.5, 1))

-- Enable/disable multiline input
input:set_multiline(true)
input:set_multiline(false)

-- Enable/disable the input
input:set_enabled(true)
input:set_enabled(false)

-- Check if input is enabled
local is_enabled = input:is_enabled()

-- Set input focus
input:set_focus()

-- Remove input focus
input:remove_focus()

-- Check if input has focus
local has_focus = input:is_focused()

-- Select all text
input:select_all()

-- Set cursor position
input:set_cursor_position(5)
```

## Events

```lua
-- Subscribe to text change event
input.on_input_text:subscribe(function(self, text)
    print("Text changed to: " .. text)
end)

-- Subscribe to focus events
input.on_focus:subscribe(function(self)
    print("Input gained focus")
end)

input.on_focus_lost:subscribe(function(self)
    print("Input lost focus")
end)

-- Subscribe to input submit event (Enter key)
input.on_submit:subscribe(function(self)
    print("Input submitted with text: " .. self:get_text())
end)

-- Subscribe to input canceled event (Escape key)
input.on_cancel:subscribe(function(self)
    print("Input canceled")
end)
```

## Examples

```lua
-- Create a username input with validation
local username_input = self.druid:new_input("username_bg", "username_text")
username_input:set_placeholder("Username")
username_input:set_allowed_characters("[%w_]") -- Only alphanumeric and underscore
username_input:set_max_length(20)

-- Create a password input
local password_input = self.druid:new_input("password_bg", "password_text")
password_input:set_placeholder("Password")
password_input:set_password(true)
password_input:set_password_char("•")

-- Create a multiline text area
local text_area = self.druid:new_input("textarea_bg", "textarea_text")
text_area:set_multiline(true)
text_area:set_placeholder("Enter your message here...")

-- Create a numeric input for age
local age_input = self.druid:new_input("age_bg", "age_text")
age_input:set_allowed_characters("%d") -- Only digits
age_input:set_max_length(3)
age_input:set_keyboard_type(gui.KEYBOARD_TYPE_NUMBER_PAD)

-- Create a form with multiple inputs and validation
local email_input = self.druid:new_input("email_bg", "email_text")
email_input:set_placeholder("Email")

local function validate_form()
    local email = email_input:get_text()
    local password = password_input:get_text()
    
    -- Simple email validation
    if not email:match("^[%w%.]+@[%w%.]+%.%w+$") then
        print("Invalid email format")
        return false
    end
    
    if #password < 8 then
        print("Password must be at least 8 characters")
        return false
    end
    
    return true
end

local submit_button = self.druid:new_button("submit_button", function()
    if validate_form() then
        print("Form submitted successfully")
    end
end)
```

## Notes

- The Input component requires proper key triggers setup in your `input.binding` file
- On mobile platforms, the component will show the appropriate keyboard based on the keyboard_type parameter
- The component handles text selection, cursor positioning, and clipboard operations
- You can customize the visual appearance of the input, including text color, selection color, and cursor
- Input validation can be used to restrict what characters users can enter
- The placeholder text is shown when the input is empty and doesn't have focus
- For multiline input, the component supports line breaks and scrolling
- The component provides events for all major input interactions, allowing you to create responsive forms
- Password mode masks the entered text with the specified character for security
