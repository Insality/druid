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

Desc

- Input component: rename field _selected_ to _is_selected_ (according to the docs)
- Add EmmyLua annotations. See how to use it FAQ
- Lang text now can be initialized without default locale id
- **#116** You can pass Text component in Input component instead of text node
- **#124** Add _set_click_zone_ functon to Scroll component (just link to Drag:set_click_zone inside scroll component)
- **#102** __[BREAKING]__ Removed _increase_input_priority_ component function. Use _component:set_input_priority_ function instead. The bigger priority value processed first. The value 10 is default for Druid components, the 100 value is maximum priority for acquire input in _drag_ and _input_ components
-- Add constants for priorities: _const.PRIORITY_INPUT_, _const.PRIORITY_INPUT_HIGH_, _const.PRIORITY_INPUT_MAX_.
-- __[BREAKING]__ If you use in you custom components interest: __component.ON_INPUT_HIGH__ you should replace it with __const.PRIORITY_INPUT_HIGH__ as third param, and place it with usual __component.ON_INPUT__. For example
_before:_
```lua
local Drag = component.create("drag", { component.ON_INPUT_HIGH })
```
_after:_
```lua
local Drag = component.create("drag", { component.ON_INPUT }, const.PRIORITY_INPUT_HIGH)
```
- **#123** Add scroll for Scroll component via mouse wheel or touchpad:
-- Added Scroll style params: WHEEL_SCROLL_SPEED, WHEEL_SCROLL_INVERTED
-- Mouse scroll working when cursor is hover on scroll view node
-- Vertical scroll have more priority than horizontal
-- Fix: When Hover component node became disabled, reset hover state (throw on_hover and on_mouse_hover events)
-- This is basic implementation, it is work not perfect
