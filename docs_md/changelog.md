### Druid 0.3.0:

- `Druid:final()` now is important function for correct working

- Add _swipe_ basic component
	- Swipe component handle simple swipe gestures on node. It has single callback with direction on swipe. You can adjust a several parameters of swipe in druid style.
	- Swipe can be triggered on action.released or while user is make swiping (in process)
	- Add swipe example at main Druid example. Try swipe left/right to switch example pages.

- Add _input_ basic component
	- Input component handle user text input. Input contains from button and text components. Button needed for selecting/unselecting input field
	- Long click on input field for clear and select input field (clearing can be disable via styles)
	- Click outside of button to unselect input field
	- On focus lost (game minimized) input field will be unselected
	- You can setup max length of the text
	- You can setup allowed characters. On add not allowed characters `on_input_wrong` will be called. By default it cause simple shake animation
	- The keyboard for input will not show on mobile HTML5. So input field in mobile HTML5 is not working now
	- To make work different keyboard type, make sure value in game.project Android:InputMethod set to HiddenInputField (https://defold.com/manuals/project-settings/#input-method)

- Add two functions to basic component: `increase_input_priority` and `reset_input_priority`. It used to process component input first in current input stack (there is two input stacks now: INPUT and INPUT_HIGH). Example: on selecting input field, it increase input self priority until it be unselected

- Add two new component interests: `on_focus_gain` and `on_focus_lost`

- Add global druid events:
	- on_window_callback: call `druid.on_window_callback(event)` for on_focus_gain/lost correct work
	- on_language_change: call `druid.on_language_change()` (#38) for update all druid instances lang components
	- on_layout_change: call `druid.on_layout_change()` (#37) for update all gui layouts (unimplemented now)

- Add button `on_click_outside` event. You can subscribe on this event in button. Was needed for Input component (click outside to deselect input field)

- Add _start_pos_ field to button component

- Changed input binding settings. Add esc, enter, text and marked_text. Backspace now is different from android back button event. Check the README setup section

- Renamed _on_change_language_ -> _on_language_change_ component interest

- Add several examples to druid-assets respository (see live example here): https://insality.github.io/druid-assets/)

- Known issues:
	- Adjusting text size by height works wrong. Adjusting single line texting works fine
	- Space is not working in HTML5



### Druid 0.4.0:

- Add _Drag_ basic component
	- Drag component allow you detect dragging on GUI node
	- Drag will be processed even the cursor is outside of node, if drag is already started
	- Drag provides correct handle of several touches. Drag can switch between them (no more scroll gliches with position)
	- Drag have next events:
		- on_touch_start (self)
		- on_touch_end (self)
		- on_drag_start (self)
		- on_drag (self, dx, dy)
		- on_drag_end (self)
	- You can restriction side of dragging by changing _drag.can_x_ and _drag.can_y_ fields
	- You can setup drag deadzone to detect, when dragging is started (_by default 10 pixels_)

- [Breaking changes] Druid _Scroll_ component fully reworked. Input logic moved to _Drag_ component
	- Update scroll documentation
	- Change constructor order params
	- Change _scroll:set_border_ to _scroll:set_size_
	- Scroll now contains from view and content node
		- _View node_ - static node, which size determine the "camera" zone
		- _Content node_ - dynamic node, moving by _Scroll_ component
	- Scroll will be disabled only if content size equals to view size (by width or height separatly)
	- You can adjust start scroll size via _.gui_ scene. Just setup correct node size
	- Different anchoring is supported (for easier layout)
	- Function _scroll_to_ now accept position relative to _content node_. It's more easier for handling. _Example:_ if you have children node of _content_node_, you can pass this node position to scroll to this.
	- **Resolve #52**: _Content node size_ now can be less than _view node size_. In this case, content will be scrolled only inside _view size_ (can be disabled via style field: _SMALL_CONTENT_SCROLL_)
	- **Fix #50**: If style.SOFT_ZONE_SIZE equals to [0..1], scroll can be disappeared

- Druid _Grid_ Update
	- Anchor by default equals to node pivot (so, more component settings in _.gui_ settings) (#51)
	- Function `grid:clear` now don't delete any GUI nodes. Druid will not care about `gui.delete_node` logic anymore (#56)

- Druid _Hover_ component now have two _hover_ events (#49):
	- _on_hover_ is usual hover event. Trigger only if touch or mouse action_id pressed on node
	- _on_mouse_hover_ action on node without action_id (desktop mouse over). Works only on desktop platform

- Styles update:
	- Styles table now can be empty, every component have their default style values
	- Remove `component:get_style` function. Now you can only set styles
	- To get style values in component, add `component:on_style_change` function. It's invoked on `component:set_style` function
	- You can look up default values inside `component:on_style_change` function or style component API on [Druid API](https://insality.github.io/druid/index.html)

- Druid update:
	- Now function `druid:remove` remove instance and all instance children components. No more manual deleting child components (#41)

- **Fix:** Blocker component bug (blocker had very high priority, so it's block even button components, created after blocker)
- **Fix #58:** Bug, when druid instance should be always named `druid` (ex: `self.druid = druid.new(self)`)
- **Fix #53:** Bug with final _Druid instance_ without any components


### Druid 0.5.0:

Besides a lot of fixes (thanks for feedback!) two components was add: _StaticGrid_ and _DynamicGrid_ instead of usual _Grid_ component (it is deprecated now).
Add _component:set_input_enabled_ for basic component class. So you can enable/disable user input for any component.
Finaly implemented _on_layout_changed_ support. Druid components now will try keep their data between layout changing! You also can use this callback in your custom components.
Also check _component.template.lua_ what you can use for your own custom components!

- **#77** Grid update:
	- The _grid_ component now is __deprecated__. Use _static_grid_ instead. Druid will show you deprecated message, if you still using _grid_ component
	- __[BREAKING]__ Remove the _grid:set_offset_ grid functions. To adjust the distance between nodes inside grid - setup correct node sizes
	- Add _static_grid_ component
		- The behaviour like previous _grid_ component
		- Have constant element size, so have ability to precalculate positions, indexes and size of content
		- By default, not shifting elements on removing element. Add _is_shift_ flag to _static_grid:remove_ function
		- This grid can spawn elements with several rows and columns
	- Add _dynamic_grid_ component
		- Can have different element size. So have no ability to precalculate stuff like _static_grid_
		- This grid can't have gaps between elements. You will get the error, if spawn element far away from other elements
		- The grid can spawn elements only in row or in column
		- The grid node should have __West__, __East__, __South__ or __North__ pivot (vertical or horizontal element placement)
		- Able to shift nodes left or right on _grid:add_ / _grid:remove_ functions
- Scroll update:
	- Add _scroll:set_vertical_scroll_ and _scroll:set_horizontal_scroll_ for disable scroll sides
	- Add _scroll:bind_grid_ function. Now is possible to bind Druid Grid component (Static or Dynamic) to the scroll for auto refresh the scroll size on grid nodes changing
- **#37** Add _on_layout_change_ support. Druid will keep and restore GUI component data between changing game layout. Override function _on_layout_change_ in your custom components to do stuff you need.
- **#85** Move several components from `base` folder to `extended`. In future to use them, you have to register them manually. This is done for decrease build size by excluding unused components
- **Fix #61:** Button component: fix button animation node creation
- **Fix #64:** Hover component: wrong mouse_hover default state
- **Fix #71:** Blocker: blocker now correct block mouse hover event
- **Fix #72:** Fix `return nil` in some `on_input` functions
- **Fix #74:** __[BREAKING]__ Fix typo: strech -> stretch. Scroll function `set_extra_stretch_size` renamed
- **Fix #76:** Add params for lang text localization component
- **Fix #79:** Fix _druid:remove_ inside on_input callback
- **Fix #80:** Fix _hover:set_enable_ typo function call
- **Fix #88:** Add _component:set_input_enabled_ function to enable/disable input for druid component. Now you can disable input of any druid component, even complex (with other components inside)
- Add `component.template.lua` as template for Druid custom component
- Update the example app


### Druid 0.6.0:

Hey! Are you tired from **Druid** updates? _(It's a joke)_

Finally, got a time to release component to process huge amount of data. So introducing: **DataList** component. It can help solve your problem with `GUI nodes limit reached` and helps with scroll optimization. Give feedback about it!

The next important stuff is **EmmyLua** docs. I'm implemented EmmyLua doc generator from LuaDoc and Protofiles, so now you can use EmmyLua annotations inside your IDE instead of website API looking or source code scanning.

Also the **Druid examples** is reworked, so each example will be in separate collection. Now it's become a  much easier to learn Druid via examples. A lot of stuff in progress now, but you already can see on it!

Input priority got reworked too. Now instead of two input stacks: usual and high, Druid use simple input priority value.

And I should note here are several breaking changes, take a look in changelogs.

Wanna something more? [Add an issues!](https://github.com/Insality/druid/issues)
Have a good day.


**Changelog 0.6.0**
---

- **#43** Add **DataList** Druid extended component. Component used to manage huge amount of data to make stuff like _infinity_ scroll.
	- This versions is first basic implementation. But it should be enough for almost all basic stuff.
	- Create Data List with `druid:new_data_list(scroll, grid, create_function)`.
		-	_scroll_ - already created __Scroll__ component
		-	_grid_ - already created __StaticGrid__ or __DynamicGrid__ component
		-	_create_function_ - your function to create node instances. This callback have next parameters: `fun(self, data, index, data_list)`
			-	_self_ - Script/Druid context
			-	_data_- your element data
			-	_index_ - element index
			-	_data_list_ - current __DataList__ component
	- Create function should return root node and optionaly, _Druid_ component. It's required to manage create/remove lifecycle
	-	Set data with `data_list:set_data({...})`
	-	In current version there is no `add/remove` functions
- Add EmmyLua annotations (_ta-daaa_). See how to [use it FAQ](https://github.com/Insality/druid/blob/develop/docs_md/FAQ.md)!
- Add context argument to Druid Event. You can pass this argument to forward it first in your callbacks (for example - object context)
-  Add _SHIFT_POLICY_ for _Static_ and _Dynamic_ Grids. It mean how nodes will be shifted if you append data between nodes. There are `const.SHIFT.RIGHT`, `const.SHIFT.LEFT` and `const.SHIFT.NO_SHIFT`.
	- __[BREAKING]__ Please check your `StaticGrid:remove` and `DynamicGrid:remove` functions
- **#102** __[BREAKING]__ Removed `component:increase_input_priority` component function. Use `component:set_input_priority` function instead. The bigger priority value processed first. The value 10 is default for Druid components, the 100 value is maximum priority for acquire input in _drag_ and _input_ components
	- Add constants for priorities: _const.PRIORITY_INPUT_, _const.PRIORITY_INPUT_HIGH_, _const.PRIORITY_INPUT_MAX_.
	- __[BREAKING]__ If you use in you custom components interest: `component.ON_INPUT_HIGH` you should replace it with `component.ON_INPUT` and add `const.PRIORITY_INPUT_HIGH` as third param. For example:
		_before:_
		```lua
		local Drag = component.create("drag", { component.ON_INPUT_HIGH })
		```
		_after:_
		```lua
		local Drag = component.create("drag", { component.ON_INPUT }, const.PRIORITY_INPUT_HIGH)
		```
- Lang text now can be initialized without default locale id
- Input component: rename field _selected_ to _is_selected_ (according to the docs)
- **#92** Setup repo for CI and unit tests. (Yea, successful build and tests badges!)
- **#86** Fix a lot of event triggers on scroll inertia moving
- **#101** Fix scroll to other node instead of swipe direction with scroll's points of interest (without inert settings)
- **#103** Add `helper.centate_nodes` function. It can horizontal align several Box and Text nodes
- **#105** Add `Input:select` and `Input:unselect` function.
- **#106** Add `Input.style.IS_UNSELECT_ON_RESELECT` style param. If true, it will be unselect input on click on input box, not only on outside click.
- **#108** Add component interests const to `component.lua`
- **#116** You can pass Text component in Input component instead of text node
- **#117** Move each Druid example in separate collection. It's a lot of easier now to learn via examples, check it!
	- Examples in progress, so a lot of stuff are locked now, stay tuned!
- **#118** Druid.scroll freezes if held in one place for a long time
- **#123** Add scroll for Scroll component via mouse wheel or touchpad:
	- Added Scroll style params: `WHEEL_SCROLL_SPEED`, `WHEEL_SCROLL_INVERTED`
	- Mouse scroll working when cursor is hover on scroll view node
	- Vertical scroll have more priority than horizontal
	- Fix: When Hover component node became disabled, reset hover state (throw on_hover and on_mouse_hover events)
	- By default mouse scroll is disabled
	- This is basic implementation, it is work not perfect
- **#124** Add `Scroll:set_click_zone` function. This is just link to `Drag:set_click_zone` function inside scroll component.
- **#127** The `druid:create` is deprecated. Use `druid:new` for creating custom components


### Druid 0.7.0:

Hello! Here I'm again with new Druid stuff for you!

The feature I want a long time to deliver for you: the different Text size adjust modes. Druid use the text node sizes to fit the text into this box.
There are new adjust modes such as Trim, Scroll, Downscale with restrictions and Downscale + Scroll. You can change default adjust mode via text style table, but by default there is no changes - it's downscale adjust mode as before.
I'll hope it can be useful for you for in different cases and now it will be much easy to fit all your texts for different languages!

The next features is made for add more control for availability of user input. So meet the whitelists, blacklists and custom check functions for Buttons. Now you can easily choose the more suitable way to enable/disable/restrict input for you users. I'm sure it can be useful for you tutorials.

Another small, but cool feature on my mind is `druid.stencil_check`. If you did interactive elements inside the Scroll, probably you used `component:set_click_zone` to restrict input zone by stencil scroll view node. With this feature, Druid will do it automaticaly for you! You can enable this feature in your `game.project`. It will not override you existing `set_click_zone`.

Now you even able to remap default input keys! Also there are several bugfixes with Scroll, Text, Grids.

Wanna something more? [Add an issues!](https://github.com/Insality/druid/issues)
Good luck!


**Changelog 0.7.0**
---

- **#78** [Text] Update Text component:
	- Add text adjust type instead of _no_adjust_ param.
		- const.TEXT_ADJUST.DOWNSCALE - Change text's scale to fit in the text node size
		- const.TEXT_ADJUST.TRIM - Trim the text with postfix (default - "...", override in styles) to fit in the text node size
		- const.TEXT_ADJUST.NO_ADJUST - No any adjust, like default Defold text node
		- const.TEXT_ADJUST.DOWNSCALE_LIMITED - Change text's scale list downscale, but there is limit for text's scale
		- const.TEXT_ADJUST.SCROLL - Change text's pivot to imitate scrolling in the text box. Use with stencil node for better effect.
		- const.TEXT_ADJUST.SCALE_THEN_SCROLL - Combine two modes: first limited downscale, then scroll
- **#110** [Button] Add `Button:set_check_function(check_function, failure_callback)` function to add your custom click condition to button.
	- `Button:set_enabled` has more priority than this to check button availability
	- The `check_function` should return _true_ of _false_. If true - button can be clicked by user
	- The `failure_callback` will be called if `check_function` will return false
	- Example with `set_check_function` in general:buttons example collection
- **#66** Add `druid:set_whitelist()` and `druid.set_blacklist()` functions. It's affects only on input process step, you can allow/forbid interact with list of specific components
	- You can pass array of components, single component or nil in these functions
- **#111** Add autocheck for input and stencil nodes. To enable this feature, add `druid.stencil_check = 1` to your _game.project_ file.
	- This feature is using for auto setup `component:set_click_zone` to restrict clicks outside scrolls zone for example. Now you can don't think about click zone and let Druid do it instead of you!
	- Add `helper.get_closest_stencil_node` function to get closest parent of non inverted stencil node
	- Add `component.ON_LATE_INIT` interest. Component with this will call `component.on_late_init` function once after component init on update step. This can be used to do something after all gui components are inited
- **#81** Add ability to interact with Druid input via messages:
	- Currently add for Button and Text component only:
		- Send to _gui.script_ message: `druid_const.ON_MESSAGE_INPUT`. The message table params:
			- `node_id` - the name of the node with component on it
			- `action` - value from `druid_const.MESSAGE_INPUT`. Available values:
				- **BUTTON_CLICK** - usual button click callback
				- **BUTTON_LONG_CLICK** - button long click callback
				- **BUTTON_DOUBLE_CLICK** - button double click callback
				- **BUTTON_REPEATED_CLICK** - button repeated click callback
				- **TEXT_SET** - set text for Text component
			- `value` - optional field for several actions. For example value is text for **TEXT_SET**
	- Add Druid component interest: `component.ON_MESSAGE_INPUT`
	- Implement new interest via function `component:on_message_input(node_id, message)`
	- See **System: Message input** example
- **#131** [Static Grid] Add style param: `IS_DYNAMIC_NODE_POSES` (default: false). Always align by content size with node anchor.
	- If true - Static Grid will by always align to content anchor.
	- If false (currently behaviour) - all poses for static grid is predefined and not depends on element's count (see example: static grid and static grid with dynamic poses)
- **#125** Now `component:set_input_priority()` affects on all component's children too
- **#143** Update all lang components on `druid.set_text_function` call
- **#112** Allow remap default Druid input bindings via `game.project`
- **#107** [Text] Better scale text adjust by height for multiline text nodes (but still not perfect)
- **#144** [Scroll] Fix some glitches with scroll Points of Interest. Remove false detection of scroll stopped.
- **#142** [Scroll] Add Scroll style param `WHEEL_SCROLL_BY_INERTION` (default - false). If true - mouse wheel will add inertion to scroll, if false - set position directly per mouse wheel event.
	- This fix caused because Mac trackpad seems have additional mouse wheel events for simulate inertion. If you uncomfortable with this, you can disable `WHEEL_SCROLL_BY_INERTION` for more controllable scroll by mouse wheel.
- **#132** Add example with grid add/remove with animations


### Druid 0.8.0
Hello!

In this Druid update no any huge special features. Mostly the bug fixes and reworking the component's interest points. If you used interests in your custom components, you should remove it from `component.create` and all should works as before.

Also added last row allignment in Static Grid component with "dynamic content poses" style enabled. You can look how it is work here: https://insality.github.io/druid/druid/?example=grid_static_grid_dynamic_pos


You can say thanks to me via stars on GitHub! :wink:
Wanna something more? [Add an issues!](https://github.com/Insality/druid/issues)
Have a nice day!


**Changelog 0.8.0**

---

-  **#160** __[BREAKING]__ Remove component interests list
	- The component interests now setup via function declaration inside your components. The functions are still the same.
	- Now `component.create` function have next signature: _create(component_name, input_priority)_
	- Your should remove interests list from your custom components if exists
		- From `component.create("custom", { component.ON_INPUT, component.ON_LATE_INIT }, const.PRIORITY_INPUT_HIGH)` to
`component.create("custom", const.PRIORITY_INPUT_HIGH)`
-  **#166**  [Input] Fix issue with Cyrillic symbols in range "[А-я]"
-  **#162** [Static Grid] Add last row alignment with dynamic content poses enabled
	- Add style param: _static_grid.IS_ALIGN_LAST_ROW_, true by default. Works only if _static_grid.IS_DYNAMIC_NODE_POSES_ enabled. See the "Static grid with dynamic poses" example.
-  **#163** [Lang Text] Set default locale_id value from text node
-  **#147** [Lang Text] Remove `...` from lang_text to fixed arguments, add _format_ function to change only string format arguments
	- There are some issues with `...`. Now Lang Text will support up to 7 _string.format_ arguments
- [Lang Text] Add more self chaining to Lang text component (_set_to_, _translate_ and _format_ functions)
-  **#151**  [Text] Fix text adjust by height
	- It still have not perfect fitting, but it's good enough!
-  **#164 #150**  [Scroll] Fix `scroll:scroll_to_percent` by Y position
-  **#148**  [Scroll] Remove scroll inertion after scroll `animate` or `set_to` functions
-  [Input] Add current text argument to _on_input_unselect_ event
-  **#152**  [Checkbox] Add _is_instant_ argument to  `set_state` function
	- Add _initial_state_ argument to Checkbox component constructor
	- Update Checkbox style, add _is_instant_ param
-  **#149**  [Button] Call button style functions after actual callback
-  **#153** System: Mode Druid acquire input to late_init step
	- Required to solve issues, when go input acquire can be later, when gui input acquire (on init step)
-  **#154** System: Change text adjust const to strings
-  **#155** Fix: Add margin to total width calculation in `helper.centrate_nodes`


### Druid 0.9.0
_Custom components update_

Hello!

Here is the long awaited update! Finally I implemented some ideas how to make easier creating custom components. There is a bunch of improvements you can be interested in.

I wanna make a point that Druid is not only set of defined components to place buttons, scroll, etc. But mostly it's a way how to handle all your GUI elements in general. Custom components is most powerful way to separate logic and make higher abstraction in your code.

Usually - custom components is set of GUI template and lua code for this template. I've added editor script, that can make a lua component file from your GUI scene (all boilerplate and usage code, also some component that can be defined right in GUI scene).

Auto layout from GUI script should be a powerful tool too! Also it's brings some code structure and style across all your files. Auto layout works from node names. If its starts or equal to some string, it will add code to generated lua file. For example, if you have in your scene node with name "button_start", it will create the Druid button, stub function and annotations to this. Sounds good!

For more information see [Create custom components](docs_md/02-creating_custom_components.md) documentations.

Also this update have some breaking changes: you should no more pass full tempalte name in inner components and the second one is renaming `text:get_text_width` to `text:get_text_size`.

The Defold 1.3.0 solves the old my issue with slider component. Now you can define input zone (not only the slider pin node) to interact with slider. It's because of inroduction `gui.screen_to_local` and `gui.set_screen_position` in default GUI api. If you using previuos Defold releases, this piece of logic will be ignored.

The Druid Assets repository will be closed and I move some components right in Druid repository. You can now use custom components in your game if your need. Right now it's Rich Input (input field with cursor and placegolder) and Pin Knob (Rotating node for set value). And slowly working on adding new examples and improvements of existing ones.

You can say thanks to me via stars on GitHub! :wink:
Also you can help with testing new functions and leave feedback.
Wanna something more? [Add an issues!](https://github.com/Insality/druid/issues)
Take care of yourself


**Changelog 0.9.0**

---

-  **#119** Add **Create Druid Component** editor script *(python3 with deftree required)*
	- The headliner of current update. This editor scripts allows you to create Custom component lua script from you *.gui* scene file. It will create component file with the same name as GUI scene and place it nearby. Inside this generated file you will find the instructions how to start usage this (require and create code).
	- This code contains GUI scheme, basic component boilerplace and generated code for components, used in this GUI scene (see #159)
	- See [Create custom components](docs_md/02-creating_custom_components.md) for more info
-  **#159** Add auto layout custom components by node naming
	- The **Create Druid Component** script will check the node names to create Druid components stubs inside generated code
	- The generator will check the node name, if it's starts from special prefix, it will create component code for you
	- Currently support the next components: `button`, `text`, `lang_text`, `grid`, `static_grid`, `dynamic_grid`, `scroll_view`, `blocker`, `slider`, `progress` and `timer`
-  **#158** **[BREAKING]** Auto `get_node` inside inner components with template/nodes
	- Before this update, if your component with template using another component with template, you had to pass full template name (`current_template .. "/" .. inner_component_template`). From this update you should pass only the `inner_component_template` name. It's will auto check the parent component template name to build full template path
	- If you don't want migrate code for this, this option can be disabled via `druid.no_auto_template` in your _game.project_ file. By default it's enabled now
-  **#171** Add `component:get_template()` function to **Druid** Base Component
	- Now it's able to get full component template name. This function has "protected" scope, so you should use it only inside your component code.
-  **#173** Fix GUI nodes usage inside inner templates
	- Now you can pass the node name instead of node itself to Druid components inside your Custom Components. Before this update Druid didn't check the nodes in parent component (usually for basic components such as button, text inside your components)
	- So you can use now `self.druid:new_button(SCHEME.BUTTON)` instead of `self.druid:new_button(self:get_node(SCHEME.BUTTON))` inside your custom components
-  **#174** Add assert to nil node on `self:get_node()`
	- It's required for easier debuging components, when GUI node path is wrong and your got the nil. The error with node path will appear in console.
-  **#169** [System] Fix on_layout_change event
	- It was broken, now the on_layout_change event is working as expected
-  **#165** [StaticGrid] Add `static_grid:set_in_row(amount)` function
-  **#44** [Slider] Click zone on all slider node, not only pin node
	- Finally! Added the `slider:set_input_node(node)` function. Now slider can be interacted not only with slider pin node, but with any zone you will define.
	- It will work only from Defold 1.3.0. If you use earlier version, nothing is happened. It using new `gui.screen_to_local` and `gui.set_screen_position` functions.
- **#178** **[BREAKING][Text]** Rename `text:get_text_width` to `text:get_text_size`. Now it return two numbers: width and height
-  **#114** Add default component templates
	- Added templates for fast prototyping. Use GUI templates to place buttons, checkbox, input and sliders on your GUI scene. You still have to create component with `druid:new` functions inside gui_script.
-  **#168** Add button to open code of current example
	- Inside every example added button to open code of this example on GitHub
-  **#140** Better documentation for custom components
-  **#172** Update documentation with links to components
	- The docs in (https://insality.github.io/druid/) now have cross links for every custom type
-  **#175** Remove Druid Assets repository, move to Druid library
	- Added folder `druid/custom`. It will have the complex custom components. Usually you should to use default GUI template or create your own with similar GUI scheme. Currently add `RichInput` and `PinKnob` components from druid-assets repository.
	- Usually to use custom component you have to require lua file first and create it's via `druid:new(Component, template_name, [nodes])`. See component docs to see constructor params.
	- This components will be included in build only if used
-  **#176** Keep last scene and scroll position in Druid example
	- Probably, it's useful for faster debug, but anyway. The example now keep the last scene and scroll position.
- Add new examples: Checkboxes, Swipe, Grid, Rich input, Pin knob
- Now editor scripts are available in Druid as dependency
- Move emmylua annotations inside Druid dependency folder. You can copy it from Defold Editor outline
- Optimize different stuff(Scroll, Druid Event, Druid instance and Base component)
- Force Data List component to `IS_DYNAMIC_NODE_POSES = false` style
