Druid 0.3.0:

- Add swipe basic component
	- Swipe component handle simple swipe gestures on node. It has single callback with direction on swipe. You can adjust a several parameters of swipe in druid style.

- Add input basic component
	- Input component handle user text input. Input contains from button and text component. Button needed for selecting input field

- Add button on_click_outside event. You can subscribe on this event in button. Was needed for Input component (click outside to deselect input field).

- Changed input binding settings. Add backspace, enter, text and marked_text. Backspace now is different from android back button.

- Add several examples to druid-assets