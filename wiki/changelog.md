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


### Druid 0.10.0

Hello! Here is new Druid update. It's brings to you two new components: Layout and Hotkey. Both components are "extended", so to use it, you should register it first (when you try to use it, in console will be prompt with code you should use)

In general:
```
local layout =  require("druid.extended.layout")
druid.register("layout", layout)
```

The Drag component now knows about window scaling, so now it have more accuracy dx/dy values depends on the screen size. The scroll and other components should work better :)

Now you can change the input priority of components temporary. For example while you interact with them (input fields, drag on select etc).

Also the update brings several bug fixes and now **Druid** have stencil_check mode enabled by default. It should be more easy to use input components with stencil nodes without manual `set_click_zone` functions.

And yeah, the new **Druid** logo is here!

**Changelog 0.10.0**

---

- **#133** [Hotkey] Add new extended component: Hotkey
	- It's allow you set hotkeys to call callbacks
	- You should pass one action key and several modificator keys (left shift, right ctrl etc)
	- List of modificator keys ids setup via component style (you can change it)
	- You can add several hotkeys on one callback via `hotkey:add_hotkey` with additional params
- **#98** [Layout] Add new extended component: Layout
	- It's allow you to extend standart Defold node adjust modes
	- Layout mode can be next:
		- `const.LAYOUT_MODE.STRETCH_X` - Stretch node only by X
		- `const.LAYOUT_MODE.STRETCH_Y` - Stretch node only by Y
		- `const.LAYOUT_MODE.ZOOM_MIN` - Zoom node by minimal stretch multiplier
		- `const.LAYOUT_MODE.ZOOM_MAX` - Zoom node by maximum stretch multiplier
		- `const.LAYOUT_MODE.FIT` - Usual Defold Fit mode
		- `const.LAYOUT_MODE.STRETCH` - Usual Defold Stretch Mode
	- The Layout changes the node size property. So it's look much better if you use 9slice nodes
	- Works even the node parent is have Fit adjust mode
- **#200** [Scroll] Glitch if content size equals to scroll view size in runtime
- **#201** [DataList] Update DataList:
	- Add two events: `on_element_add` and `on_element_remove`
	- Add `data_list:get_data()` to access all current data in DataList
	- Add `data_list:get_created_nodes()` to access currently visual nodes in DataList
	- Add `data_list:get_created_components()` to access currently visual component in DataList (if created)
- **#190** [Progress] Add `progress:set_max_size` function to change max size of progress bar
- **#188** [Drag] Add two values passed to on_drag callback. Now it is `on_drag(self, dx, dy, total_x, total_y)` to check the overral drag distance
- **#195** [Drag] Add `drag:is_enabled` and `drag:set_enabled` to enable/disable drag input component
- **#186** [Grid] Fix: Method `set_in_row` works incorrectly with IS_DYNAMIC_NODE_POSES style option
- **#185** [System] Add `on_window_resized` component interest. It will called on game window size changes
- **#189** [System] Add optional flag to `component:set_input_priority` to mark it as temporary. It will reset to default input priority after the `component:reset_input_priority`
- **#204** [System] Fix: wrong code example link, if open example from direct URL
- **#202** [System] Enabled stencil check to true by default. To disable this, use `druid.no_stencil_check` in game.project settings
- [Examples] Add layout, layout fit, progress bar, data list + component examples


### Druid 0.11.0
Hello! What a wonderful day for the new **Druid** update!

Alright, let's get straight to the point. Look at what I have for you!

**Druid Rich Text** has finally been released. The main difference from the existing **Bjorn's** Rich Text is that all visual parameters are customizable directly in the GUI. This allows you to integrate **Rich Text** more accurately and quickly. Additionally, this **Rich Text** aligns pixel perfect (well, [almost](https://github.com/defold/defold/issues/7197)) with regular GUI text node.

This version is the most basic one. Honestly, just wanna to publish current version for your and polish it later. Read [RichText API here](https://insality.github.io/druid/modules/RichText.html)

Another addition is the ability to enable the "HTML mode" for the Button component. In this mode, the button's action occurs in the context of `user action`, allowing operations like "copy and paste text" "show the keyboard" and more. However, in this mode, the button only responds to regular clicks due to the technical implementation of it (so no double clicks or long taps for this button).

The huge work was done on documentation. Now it's more clear and have more examples. All documentation now moved to the API section. The separate `componentd.md` manual will be deleted soon as all documentation will be moved to the API section.

The API section now filled with overview and usage examples. I've started with the basic modules, in future I will add more examples for all modules.

Also, I've added the **Unit Tests**. It's not cover all **Druid** code, but it's a good start! 🎉

Have a good day!


**Changelog 0.11.0**

---

- **#191**: [RichText] Finally add **Druid [Rich Text](https://insality.github.io/druid/modules/RichText.html)** custom component. Component is used to make formatted text in your's GUI. This Rich Text mostly adjusted visually in GUI and have almost pixel-perfect match with similar GUI text node
- **#39**: [System] Finally add **Unit Tests**. Yeah, it cover not all **Druid** code, but it's a good start! 🎉
- **#219**: [System] UTF-8 performance optimization. Now Druid will try to use *utf8* native extension over lua utf8 library if exists. If you wanna use native utf8, just [add the extension](https://github.com/d954mas/defold-utf8) in your `game.project` dependency.
- **#156**: [Button] Now button can work in HTML5 with `html5.set_interaction_listener`.
	- The API is `button:set_web_user_interaction(true)`. In HTML5 mode button have several restrictions. Basically, only the single tap event will work.
- **#227**: [System] Update current URL in HTML5 example
	- Now if you will open the example from direct URL, it will be updated to the current URL in your browser. So now it's much easier to share the example link with each other.
- **#183**: [Docs] Documentation about [GUI in World Space](https://forum.defold.com/t/how-to-gui-in-defold/73256#gui-in-world-coordinates-49)
	- Also not only the GUI in World Space, but overall How to GUI in Defold article.
- **#234**: [**BREAKING**] [Blocker] Now `blocker:set_enabled` and `blocker:is_enabled` affects only inner state of component. To consume input, the blocker component should be enabled and the node itself should be enabled.
	- Breaking due the changes can affect your current logic. Please if use this re-check Blocker component usage.
- **#235**: [Drag] Fix Drag coordinates on streched screen.
- **#236**: [Hover] Fix nil return in `hover:on_input`.
- **#237**: [Layout] Add `layout:set_max_gui_upscale` function.
	- This functions will scale down element, if current GUI scale is bigger than `max_gui_upscale` value. It can be useful for adapt mobile device to desktop screen.
- **#238**: [System] Add Helper documentation.
- [System] Now the documentation contains the **Druid** size. The current size as dependency is around **67KB**. It counted without extended components, which is not included by default in the build.


Thanks to the my supporters:
- [Defold Foundation](https://defold.com)
- [Ragetto](https://forum.defold.com/u/ragetto)

❤️ Support ❤️

Please support me if you like this project! It will help me keep engaged to update **Druid** and make it even better!

[![Github-sponsors](https://img.shields.io/badge/sponsor-30363D?style=for-the-badge&logo=GitHub-Sponsors&logoColor=#EA4AAA)](https://github.com/sponsors/insality) [![Ko-Fi](https://img.shields.io/badge/Ko--fi-F16061?style=for-the-badge&logo=ko-fi&logoColor=white)](https://ko-fi.com/insality) [![BuyMeACoffee](https://img.shields.io/badge/Buy%20Me%20a%20Coffee-ffdd00?style=for-the-badge&logo=buy-me-a-coffee&logoColor=black)](https://www.buymeacoffee.com/insality)



### Druid 1.0

**Description**

Hello! The long-awaited update for Druid is finally here! The Druid now is finally 1.0 version! 🎉 This was a long path to achieve current state!

This update brings a lot of improvements, so let's dive in:

**New Example Page**
I’ve updated Druid's main examples page. Since Druid has become quite popular, I wanted to ensure the examples meet high standards of quality and aesthetics. The examples are now clearer and provide more information. I’ve also added many new examples. Check them out! Share your feedback and suggestions for new examples. Now it's much easier to learn Druid!

Play right here - https://insality.github.io/druid/druid

**Component Reworking**
Several components have been reworked. While I generally avoid introducing breaking changes, sometimes they are necessary for progress.

- **Rich Text** is now applied directly to the text node, rather than using a `Rich Text Template`. This makes setup and usage much easier! I’m still working on figuring out how to apply this approach to Rich Input.

- The **Layout** component has been completely replaced. It now functions similarly to **Dynamic Grid** but with more settings and modes. This layout now works similarly to Figma Auto Layout, allowing you to arrange nodes in various ways.

- **Dynamic Grid** will be deprecated in the future, with the new Layout component serving as its replacement.

- **Data List** now works exclusively with **Static Grid**, making it more stable and optimized. Additionally, a new `cached` version is available, which optimizes node reuse. However, the cached version requires using `on_add_element` and `on_remove_element` events to properly set up nodes.

**Code Cleanup**
I’ve finally removed `middleclass` from Druid. If you were using it for some reason, you’ll need to copy the "middleclass" code into your project.

**Annotations**
Druid’s annotations were originally created when there were no Lua language servers. These annotations are of the older LDoc type and not EmmyLua. In the future, I aim to get rid of annotations altogether and rely on annotated code, which is easier to read, maintain, and feature-rich. The Defold will support the LLS (Lua Language Server) as well as VSCode with amazing Defold-Kit extension.

---

**Milestone**: https://github.com/Insality/druid/milestone/12

**Changelog 1.0**

- New Druid logo!
- **[Example]** New Example Page with 40+ examples.
- **BREAKING** **[Rich Text]** Now applied directly to the text node instead of using a Rich Text Template (which previously contained three nodes: root, text, and image prefabs). This simplifies usage in the GUI.
- **BREAKING** **[System]** Removed `middleclass.lua`. If you were using it, you’ll need to copy the code into your project.
- **BREAKING** **[System]** Removed: `checkbox`, `checkbox_group`, and `radio_button` components. These components can be easily created using the Button component. Check the examples for implementation.
- **BREAKING** **[Layout]** Reworked the Layout component. The new version allows arranging nodes in various modes (vertical, horizontal, horizontal wrap) and includes more settings (margins, padding, justification, pivots, and content hugging options). This will replace Dynamic Grid in the future.
- **[Data List]** Reworked Data List to work only with **Static Grid**. It’s now more stable and has an extended API.
    - Added a **Cached Data List** option, which uses less memory (highly optimized) but requires `on_add_element` and `on_remove_element` events for node setup. All components must be of the same class in this case.
- **[Rich Input]** Updated with new features such as selection and cursor navigation. New input keys can be configured in Druid (arrows, ctrl, shift).
- **[Input]** Users can now switch between text input areas with a single click, instead of needing to tap twice (once to close the focus and once to open the new input).
- **[Dynamic Grid]** Deprecated in favor of the new Layout component.
- **[Drag]** Added a touch parameter to Drag callbacks, making it easier to add custom logic with input action data.
- **[Scroll]** Added `scroll.view_size`, `scroll:set_view_size(size)`, and `scroll:update_view_size()` functions for better management of the scroll input area and visible part.
- **[Static Grid]** Added `grid:set_item_size(size)` and `grid:sort_nodes(comparator)` functions.
- **[Text]** Adjustments for multiline text height seem to be working correctly now.
- **[Progress Bar]** Improved accuracy when scaling progress bars for images with slice9 parameters.
- **[Slider]** Fixed several slider setup issues.
- **[System]** Updated and fixed annotations.
- **[System]** Removed: `pin_knob` custom component. It mostly was created as an example and now is not needed.
- **[System]** Added `self:get_druid(template, nodes)` to replace `self:set_template(template)` and `self:set_nodes(nodes)` calls in custom components.
- Various improvements and fixes.


A big thanks to the my Github supporters:
- [Defold Foundation](https://defold.com)
- [Ragetto](https://forum.defold.com/u/ragetto)
- [Pawel](https://forum.defold.com/u/pawel/summary)

And all my other supporters! Very appreciated!

❤️ Support ❤️

Please support me if you like this project! It will help me keep engaged to update **Druid** and make it even better!

[![Github-sponsors](https://img.shields.io/badge/sponsor-30363D?style=for-the-badge&logo=GitHub-Sponsors&logoColor=#EA4AAA)](https://github.com/sponsors/insality) [![Ko-Fi](https://img.shields.io/badge/Ko--fi-F16061?style=for-the-badge&logo=ko-fi&logoColor=white)](https://ko-fi.com/insality) [![BuyMeACoffee](https://img.shields.io/badge/Buy%20Me%20a%20Coffee-ffdd00?style=for-the-badge&logo=buy-me-a-coffee&logoColor=black)](https://www.buymeacoffee.com/insality)



### Druid 1.1.0

Hello there, Druid users!

The wait is over - **Druid 1.1** has arrived! This update brings substantial improvements and exciting new features that make building UI in Defold easier and more powerful than ever.

By the way, the PR number of this release is #300. It's sounds ve-eery huge and the long journey for me!

## Highlights

- **Widgets** are here! This is the evolution of custom components, but Widgets with totally no boilerplate code and far more convenient usage. All Druid examples have been migrated to use widgets. Widgets are now a default way to create a new user custom components.

The widget code is simple as:
```lua
---@class my_widget: druid.widget
local M = {}

function M:init()
	-- Druid is available now
	self.button = self.druid:new_button("button")
end

return M
```

To instantiate a widget, you need to call
```lua
local my_widget = require("widgets.my_widget.my_widget")
self.widget = self.druid:new_widget(my_widget, "widget_template_id")
```

To create a widget with a even more fast way, now you always can right click on GUI file and select `Create Druid Widget` to create a widget file for current GUI file nearby.

- **No more calling `druid.register()`!** All Druid components are now available by default with `self.druid:new_*` functions, making getting started simpler than ever.

- **Druid UI Kit** brings fonts, atlas, and ready-to-use GUI templates right out of the box - a long-requested feature that lets you use Druid UI elements instantly in your projects. I think now it's a possible to create even a external dependencies with a set of GUI templates and Druid's widgets to make a ready to use UI kit for projects! The flow to init widgets always now from two steps:
	- Add GUI template to your GUI scene
	- Call `self.widget = self.druid:new_widget(widget_file, "template_id")` to init widget
	- or Call `self.widget = self.druid:new_widget(widget_file, "template_id", "tempalate_id/root")` to clone root node from template and init widget from it


- **Completely reworked documentation** with full code annotations. Let's check the new brand [Quick API Reference](/api/quick_api_reference.md) to get familiar with **Druid**. Any documentation are generated from the code annotations, so in case to update documentation, you need to update annotations in the code directly.

## Breaking Changes

- `druid.event` has been replaced with the [defold-event](https://github.com/Insality/defold-event) library, requiring a small migration in your code if you were using Druid events directly before. Double dependencies: `defold-event` and `druid` are now required to use **Druid**.

---

This release represents a major step forward in making Druid more maintainable, readable, and powerful. Check out the full changelog for all the details!

The [contributing guide](CONTRIBUTING.md) is created for people who want to contribute to the Druid.

Thank you for using Druid and please share your feedback!


---

**Changelog 1.1.0**
- **[Docs]** Reworked all documentation pages
	- The code now is fully annotated
	- The old API website is removed
	- The API now placed as a markdown files in the `api` folder of the repository
	- Start with [Quick API Reference](/api/quick_api_reference.md) to learn how to use Druid
- **[BREAKING]** Remove `druid.event`, replaced with `defold-event` library. Now it required to two dependencies to use Druid.
	- This allow to make more flexible features, like shaders and sync init functions between script and gui_script in various cases.
	- You need to migrate from `require("druid.event")` to `require("event.event")` if you are using it in your project
	- If you are used `event.is_exist()` now, you should use `#event > 0` or `not event:is_empty()` instead
	- Use 11+ version of `defold-event` library: `https://github.com/Insality/defold-event/archive/refs/tags/11.zip`
	- Read [defold-event](https://github.com/Insality/defold-event) to learn more about the library
- **[UI Kit]** Add Druid UI Kit, contains `druid.atlas`, `druid_text_bold.font`, `druid_text_regular.font` so now you can use Druid GUI files in your projects.
	- Contains mostly basic shapes for the UI and can contains several icons. Atlas is a small, only `128x128` size and will be included in build only if you use it. Probably will grow a little bit in future.
	- A long waited feature which allows try or just use some **Druid** GUI features almost instantly.
	- No more "rich_input" template is not working! Should be good for now.
	- Now GUI files from **Druid** can be added inside your project.
	- This allow to include `Default Widgets` - ready to use GUI templates
	- Two fonts will keep in the UI Kit: `druid_text_bold.font` and `druid_text_regular.font`. They each of them `~100KB`, already contains extended characters set, with font size of `40`.
- **[Widgets]** **Widgets here!**
	- A replacement for Druid's `custom_components`. Basically it's the same, but `widgets` contains no boilerplate code and more convinient to use.
	- Now I can include a kind of `widgets` with Druid and you can use it almost instantly in your project.
	- All Druid Examples was migrated to use Widgets instead of Custom Components.
- **[Widgets]** Widgets can be used in GO `script` files.
	- It's a kind of experimental feature, but looks fun to check.
	- Added the `druid_widget.gui_script` which can register a Druid instance for this GUI scene.
	- You can use `druid.get_widget(class, url)` to get a Druid instance in GO context.
	- All top level functions from widget are available in GO context.
	- It uses an `defold-event` library, so wrapping have a costs.
- **[System]** 🎉 No need for the `druid.register()`! Now all Druid's components are available by default and available with `self.druid:new_*` functions
	- This means the Druid will be bigger in size, but it's much comfortable to use
	- In case you want to delete components you are not using, you can do it in fork in `druid.lua` file
	- Read [optimize_druid_size.md](optimize_druid_size.md) to learn how to reduce the size of the Druid library if you interested
	- Any additional new widgets, utilities files will be not included until you use it
	- You still can register your custom components to make a aliases for them. Widgets are not supported here.
- **[BREAKING]** Removed old `druid.no_stencil_check` and `druid.no_auto_template` flags. Now it's always disabled
- **[System]** Huge code refactoring and improvements. The goal is to raise maintainability and readability of the code to help people to contribute.
- **[Docs]** Add [CONTRIBUTING.md](/CONTRIBUTING.md) file with various information to help people to contribute to the Druid.
- **[Editor Scripts]** Updated editor scripts
- **[Editor Scripts]** Add "[Druid] Create Druid Widget" instead of "Create Custom Component"
- **[Editor Scripts]** Add "[Druid] Settings" editor dialog
	- Contains different documentation links
	- You can adjust the widget template path to use your own templates in "Create Druid Widget" editor script
- **[Text]** Add `trim_left` and `scale_then_trim_left` text adjust modes
- **[Text]** Add `set_text` function instead `set_to` (the `set_to` now deprecated)
- **[Widget]** Add widget `mini_graph`
- **[Widget]** Add widget `memory_panel` (works over `mini_graph` widget)
- **[Widget]** Add widget `fps_panel` (works over `mini_graph` widget)
- **[Widget]** Add widget `properties_panel`
- **[Unit Tests]** Updated Unit tests
	- Now it's cover more cases and more code, which is great!


A big thanks to the my Github supporters:
- [Defold Foundation](https://defold.com)
- [Pawel](https://forum.defold.com/u/pawel)
- [Ragetto](https://forum.defold.com/u/ragetto)
- [Ekharkunov](https://forum.defold.com/u/ekharkunov)

And all my other supporters! Very appreciated!

❤️ Support ❤️

Please support me if you like this project! It will help me keep engaged to update **Druid** and make it even better!

[![Github-sponsors](https://img.shields.io/badge/sponsor-30363D?style=for-the-badge&logo=GitHub-Sponsors&logoColor=#EA4AAA)](https://github.com/sponsors/insality) [![Ko-Fi](https://img.shields.io/badge/Ko--fi-F16061?style=for-the-badge&logo=ko-fi&logoColor=white)](https://ko-fi.com/insality) [![BuyMeACoffee](https://img.shields.io/badge/Buy%20Me%20a%20Coffee-ffdd00?style=for-the-badge&logo=buy-me-a-coffee&logoColor=black)](https://www.buymeacoffee.com/insality)


### Druid 1.1.X

- {Place for the community changelogs}
