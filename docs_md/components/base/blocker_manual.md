# Druid Blocker Component

## Description

The Blocker component is designed to consume input in a specific zone defined by a GUI node. It's useful for creating unclickable zones within buttons or for creating panels of buttons on top of another button.

## Features

- Blocks input in a specific zone
- Can be enabled or disabled programmatically
- Useful for creating safe zones in UI

## Basic Usage

```lua
local blocker = self.druid:new_blocker("blocker_node")
```

### Parameters

- **node**: The node or node_id of the blocker node

## Methods

```lua
-- Enable or disable the blocker
blocker:set_enabled(true)  -- Enable
blocker:set_enabled(false) -- Disable

-- Check if blocker is enabled
local is_enabled = blocker:is_enabled()
```

## Notes

- The Blocker component consumes input if `gui.pick_node` works on it
- The Blocker node should be enabled to capture input
- The initial enabled state is determined by `gui.is_enabled(node, true)`
- Blocker is useful for creating "safe zones" in your UI, where you have large buttons with specific clickable areas
- A common use case is to place a blocker with window content behind a close button, so clicking outside the close button (but still on the window) doesn't trigger actions from elements behind the window

### Example Use Case

![Blocker Scheme](../../../media/blocker_scheme.png)

In this example:
- Blue zone is a **button** with close_window callback
- Yellow zone is a blocker with window content

This setup creates a safe zone where the user can interact with the window content without accidentally triggering actions from elements behind the window.
