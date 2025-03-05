# Druid Lang Text Component

## Description

The Lang Text component extends the basic Text component to provide localization support. It automatically updates the text when the game language changes, making it easy to create multilingual UIs.

## Features

- Automatic text localization
- Support for text parameters and formatting
- Updates automatically when language changes
- Inherits all Text component features
- Support for fallback languages

## Basic Usage

```lua
-- Create a basic localized text
local lang_text = self.druid:new_lang_text("text_node", "ui.welcome_message")
```

### Parameters

- **node**: The node or node_id of the text node
- **locale_id**: The localization key to use for this text
- **params**: (optional) Parameters to format into the localized string

## Methods

```lua
-- Set the localization key
lang_text:set_locale_id("ui.new_message")

-- Set parameters for text formatting
lang_text:set_params({name = "Player", score = 100})

-- Update the text with current locale and parameters
lang_text:update_text()

-- Get the current locale ID
local locale_id = lang_text:get_locale_id()

-- Get the current parameters
local params = lang_text:get_params()

-- Set a specific language for this text (overrides global language)
lang_text:set_language("en")

-- Reset to use the global language
lang_text:reset_language()
```

## Inheritance from Text Component

The Lang Text component inherits all methods and properties from the basic Text component, including:

```lua
-- Set text color
lang_text:set_color(vmath.vector4(1, 0, 0, 1))

-- Set text scale
lang_text:set_scale(1.5)

-- Set text pivot
lang_text:set_pivot(gui.PIVOT_CENTER)

-- Set text adjustment
lang_text:set_text_adjust(druid.const.TEXT_ADJUST.DOWNSCALE)
```

## Examples

```lua
-- Create a welcome message with player name
local welcome_text = self.druid:new_lang_text("welcome_text", "ui.welcome", {name = "Player"})

-- Update player name
function update_player_name(new_name)
    welcome_text:set_params({name = new_name})
end

-- Create a score display with formatting
local score_text = self.druid:new_lang_text("score_text", "ui.score", {score = 0})

-- Update score
function update_score(new_score)
    score_text:set_params({score = new_score})
end

-- Create a text with language override
local hint_text = self.druid:new_lang_text("hint_text", "ui.hint")
hint_text:set_language("en") -- Always show hint in English regardless of game language
```

## Localization Format

The Lang Text component works with the localization system to retrieve strings based on locale IDs. The localization format typically looks like:

```lua
-- In your localization files
local localization = {
    en = {
        ui = {
            welcome = "Welcome, {name}!",
            score = "Score: {score}",
            hint = "Press Space to continue"
        }
    },
    fr = {
        ui = {
            welcome = "Bienvenue, {name}!",
            score = "Score: {score}",
            hint = "Appuyez sur Espace pour continuer"
        }
    }
}
```

## Notes

- The Lang Text component requires a properly set up localization system
- The component automatically updates when the game language changes
- You can use parameters in your localized strings with {param_name} syntax
- The component inherits all features from the basic Text component
- You can override the language for specific texts, which is useful for debugging or for text that should always appear in a specific language
- The component works with the Druid localization system, which supports fallback languages
- For complex formatting, you can use custom format functions in your localization system
