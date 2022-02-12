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
	- Different anchoring is supported (for easier layouting)
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


You can say thanks to me via stars on GitHub 3! :wink:
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
-  **#149**  [Button] Call button style functions after actual callback
-  **#153** System: Mode Druid acquire input to late_init step
	- Required to solve issues, when go input acquire can be later, when gui input acquire (on init step)
-  **#154** System: Change text adjust const to strings
-  **#155** Fix: Add margin to total width calculation in `helper.centrate_nodes`
