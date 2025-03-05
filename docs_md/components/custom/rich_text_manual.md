# Druid Rich Text Component

## Description

The Rich Text component extends the basic Text component to provide advanced text formatting capabilities. It allows you to display text with different styles, colors, and formatting within the same text node, using HTML-like markup tags.

## Features

- Inline text styling and formatting
- Support for different colors within text
- Font size variations within text
- Shadow and outline text effects
- Image insertion within text
- Line break control
- Custom tag support for advanced formatting

## Basic Usage

```lua
-- Create a basic rich text component
local rich_text = self.druid:new_rich_text("text_node")

-- Set text with formatting
rich_text:set_text("Hello <color=red>World</color>!")
```

### Parameters

- **node**: The node or node_id of the text node

## Rich Text Markup

The component uses HTML-like tags for formatting:

```l
<color=[#]HEX_VALUE>Colored text</color>
<color=COLOR_NAME>Colored text</color>
<shadow=[#]HEX_VALUE>Text with shadow</shadow>
<outline=[#]HEX_VALUE>Text with outline</outline>
<font=FONT_PATH>Text with custom font</font>
<size=NUMBER>Sized text</size>
<br/>Line break
<nobr>No line break zone</nobr>
<img=TEXTURE_ID[:ANIM_ID][,WIDTH][,HEIGHT]/>
```

## Methods

```lua
-- Set rich text content
rich_text:set_text("Hello <color=red>World</color>!")

-- Get current text (with markup)
local text = rich_text:get_text()

-- Get text without markup
local plain_text = rich_text:get_plain_text()

-- Set default text color
rich_text:set_default_color(vmath.vector4(1, 1, 1, 1))

-- Register a custom tag handler
rich_text:register_tag("shake", function(params, settings, style)
    -- Custom tag implementation
    -- Modify settings table based on params
end)

-- Clear all text
rich_text:clear()
```

## Events

```lua
-- Subscribe to text change event
rich_text.on_text_change:subscribe(function(self, text)
    print("Rich text changed to: " .. text)
end)
```

## Examples

```lua
-- Create a rich text with multiple formatting styles
local rich_text = self.druid:new_rich_text("text_node")
rich_text:set_text("Welcome to Druid! This is a <color=red>rich</color> <color=green>text</color> <color=blue>component</color>.")

-- Create text with custom font and size
local title_text = self.druid:new_rich_text("title_node")
title_text:set_text("<font=fonts/title.font><size=2>GAME TITLE</size></font>")

-- Create text with shadow and outline effects
local effect_text = self.druid:new_rich_text("effect_node")
effect_text:set_text("<shadow=black><outline=white>Stylized Text</outline></shadow>")

-- Create text with embedded images
local info_text = self.druid:new_rich_text("info_text")
info_text:set_text("Your character: <img=hero_avatar,48,48/> Level <color=yellow>5</color><br/>HP: <color=red>75</color>/100<br/>MP: <color=blue>30</color>/50")

-- Create text with custom tag
local custom_text = self.druid:new_rich_text("custom_text")
custom_text:register_tag("pulse", function(params, settings, style)
    -- Implementation of pulsing effect
    settings.pulse = true
    settings.pulse_speed = tonumber(params) or 1
end)
custom_text:set_text("This is a <pulse=1.5>pulsing</pulse> text!")
```

## Color Names

The component supports predefined color names that can be used instead of hex values:

```lua
-- Example of using named colors
rich_text:set_text("<color=aqua>Aqua</color> <color=red>Red</color> <color=lime>Lime</color>")
```

## Notes

- The Rich Text component is based on Britzl's defold-richtext library (version 5.19.0) with modifications
- The markup tags are processed at render time and converted to appropriate visual representations
- For complex formatting needs, you can register custom tags with specialized rendering logic
- When using images within text, you can specify width and height parameters
- The component supports nested tags for combined formatting effects
- For performance reasons, avoid extremely complex formatting in text that changes frequently
- The component handles tag escaping, so you can display tag-like syntax by escaping the brackets
- Rich text parsing may have a small performance impact compared to regular text rendering
- You can define custom colors in the style settings to use them by name in your markup
