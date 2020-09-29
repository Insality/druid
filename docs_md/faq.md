
# Druid FAQ

>_Have questions about Druid? Ask me!_
> _Here is questions you might have_

### Q: Why I want use Druid?
**A:** ---


### Q: How to remove the Druid component instance?
**A:** Any created **Druid** component can be removed with _druid:remove_. [API reference link](https://insality.github.io/druid/modules/druid_instance.html#druid:remove).


### Q: How to make scroll work?
**A:** ---


### Q: How the input is processing?
**A:**
*SImply*: the **Druid** has a LIFO queue to check input. Last added buttons have more priority than first. Placing your buttons from behind to the front is correct in most cases.


### Q: For what purpose Blocker component is exist?
**A:** Component explanation [here](https://github.com/Insality/druid/blob/master/docs_md/01-components.md#notes-2). 
With Blocker you can block input in some zone. It is useful for make unclickable zone in buttons or kind of buttons panel on other big button (ex. close windows on window background click)


### Q: Which stuff can I do with custom components?
**A:** Any of you can imagine! There is a lot of examples, but in general: custom components allow you place component and some game logic separately from other stuff. It will be reusable, easier for testing and developing.

For example it can be element in scroll with buttons, your custom GUI widget or even component with your game logic. Usually custom components going with templates. You can do several templates for single component module (for different visuals!)

Some examples of custom components you can find [here](https://github.com/Insality/druid-assets).


### Q: How *self:get_node()* is working?
**A:** The node can be placed in gui directly or can be cloned via *gui.clone_tree()*. Also nodes can be placed as templates, so full node id will be composed from template name and node name (in cloned nodes too).

**Druid** component *self:get_node()* trying to search in all of this places. Use *self:set_template()* and *self:set_component_nodes()* for correct setup component nodes before any call of *self:get_node()*.

Remember, usually you should pass *__string name__ of the node*, not gui node itself. It's better and more druid-way. 


### Q: My button in scroll is clickable outside the stencil node
**A:** Since **Druid** checking click node with _gui.pick_node_, stencil is not prevent this. You can setup additional click zone on your buttons with _button:set_click_zone_.

The usual Druid way after add button to the scroll do:
```lua
-- Scroll view node usually is stencil node
button:set_click_zone(scroll.view_node)
 ```


### Q: How to use EmmyLua annotations? _(from Druid 0.6.0)_
**A:** Since the dependencies can't be processed by external editors, for use generated EmmyLua annotations you should copy the _annotations.lua_ to your project. For EmmyLua it will be enough. Remember you can _restart emmylua server_ for refresh the changes, if something goes wrong.
After the annotations is processed, you should point the type of druid in requires:
```lua
---@type druid
local druid = require("druid.druid")

-- Now the autocomplete is working
```


### Q: When I should use *on_layout_change*?
**A:** ---
