Druid 0.3.0:

- Druid:final now is important function for correct working

- Add swipe basic component
	- Swipe component handle simple swipe gestures on node. It has single callback with direction on swipe. You can adjust a several parameters of swipe in druid style.
	- Add swipe example at main Druid example. Try swipe left/right to switch example pages.

- Add input basic component
	- Input component handle user text input. Input contains from button and text component. Button needed for selecting input field
	- Long click on input field for clear and select input field
	- Click outside of button to unselect input field
	- On focus lost (game minimized) input field will be unselected
	- You can setup max length of the text
	- You can setup allowed characters. On add not allowed characters `on_input_wrong` will be called. By default it cause simple shake animation
	- The keyboard for input will not show on mobile HTML5

- Add button on_click_outside event. You can subscribe on this event in button. Was needed for Input component (click outside to deselect input field).
- Add start_pos to button component

- Changed input binding settings. Add backspace, enter, text and marked_text. Backspace now is different from android back button.

- Changed component interest: Renamed on_change_language -> on_language_change
- Add two new component interests: on_focus_gain and on_focus_lost
- Add global druid events:
	- on_window_callback: call `druid.on_window_callback(event)` for on_focus_gain/lost correct work
	- on_language_change: call `druid.on_language_change()` for update all druid instances lang components
	- on_layout_change: call `druid.on_layout_change()` for update all gui layouts (unsupported now)

- Add several examples to druid-assets respository
