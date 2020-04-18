Druid 0.3.0:

- `Druid:final` now is important function for correct working

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
	- To make work different keyboard type, make sure value in game.project Android:InputMethod set to HidderInputField (https://defold.com/manuals/project-settings/#input-method)

- Add button on_click_outside event. You can subscribe on this event in button. Was needed for Input component (click outside to deselect input field).
- Add start_pos to button component

- Changed input binding settings. Add backspace, enter, text and marked_text. Backspace now is different from android back button.

- Renamed on_change_language -> on_language_change component interest

- Add basic component two functions: `increase_input_priority` and `reset_input_priority`. It used to process component input first in current input stack (there is two input stacks: INPUT and INPUT_HIGH). Example: on selecting input field, it increase input self priority until it be unselected

- Add two new component interests: `on_focus_gain` and `on_focus_lost`

- Add global druid events:
	- on_window_callback: call `druid.on_window_callback(event)` for on_focus_gain/lost correct work
	- on_language_change: call `druid.on_language_change()` (#38) for update all druid instances lang components
	- on_layout_change: call `druid.on_layout_change()` (#37) for update all gui layouts (unimplemented now)

- Add several examples to druid-assets respository

- Known issues:
	- Adjusting text size by height works wrong. Adjusting single line texting works fine
	