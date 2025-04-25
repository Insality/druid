# Druid FAQ

Welcome to the Druid FAQ! Here are answers to some common questions you may have:

### Q: How do I remove a Druid component instance?
**A:** To remove a created Druid component, use the `druid:remove` function. You can find more information in the [API reference](https://insality.github.io/druid/modules/DruidInstance.html#remove).

### Q: How does Druid process input?
**A:** Input processing in Druid follows a Last-In-First-Out (LIFO) queue. Buttons added later have higher priority than those added earlier. To ensure correct button behavior, place your buttons from back to front in most cases.

### Q: What is the purpose of the Blocker component?
**A:** The Blocker component is used to block input in a specific zone. It is useful for creating unclickable zones within buttons or for creating a panel of buttons on top of another button (e.g., closing windows by clicking on the window background). You can find more information about the Blocker component [here](https://github.com/Insality/druid/blob/master/docs_md/01-components.md#notes-2).

### Q: What can I do with custom components?
**A:** With custom components in Druid, the possibilities are endless! Custom components allow you to separate component placement and game logic from other elements, making them reusable and easier to test and develop. Custom components can be used for scroll elements with buttons, custom GUI widgets, or even components with custom game logic. Templates often accompany custom components, allowing you to create multiple visual variations for a single component module. You can find some examples of custom components [here](https://github.com/Insality/druid-assets).

### Q: How does `self:get_node()` work?
**A:** The `self:get_node()` function in a Druid component searches for nodes in the GUI directly or in cloned nodes created using `gui.clone_tree()`. It also considers nodes placed as templates, with the full node ID composed of the template name and node name (including cloned nodes). To ensure correct usage of `self:get_node()`, set up the component nodes using `self:set_template()` and `self:set_component_nodes()` before calling `self:get_node()`. It's best to pass the string name of the node, rather than the GUI node itself.

### Q: My button in a scroll is clickable outside the stencil node. How can I fix this?
**A:** When using Druid, the stencil node does not prevent buttons from being clickable outside its bounds. To address this, you can set up an additional click zone on your buttons using the `button:set_click_zone()` function. After adding a button to the scroll, you can use the following code:
```lua
-- Assuming the scroll view node is the stencil node
button:set_click_zone(scroll.view_node)
```

### Q: How do I use EmmyLua annotations? (from Druid 0.6.0)
**A:** EmmyLua annotations are used for better autocompletion and type inference in editors. To use the generated EmmyLua annotations, copy the `druid/annotations.lua` file to your project. After copying, you may need to restart the EmmyLua server to ensure the changes take effect. Once the annotations are processed, you can specify the type of Druid in your code:
```lua
---@type druid
local druid = require("druid.druid")

-- Autocomplete and type information should now work
```

Feel free to ask any additional questions you have about Druid!
