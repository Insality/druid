
# Druid components


## Button

Basic Druid input component

- Button callback have next params: (self, params, button_instance)
	- **self** - Druid self context
	- **params** - Additional params, specified on button creating
	- **button_instance** - button itself
- You can set _params_ on button callback on button creating: `druid:new_button("node_name", callback, params)`. This _params_ will pass in callback as second argument
- Button have next events:
	- **on_click** - basic button callback
	- **on_repeated_click** - repeated click callback, while holding the button, don't trigger if callback is empty
	- **on_long_click** - callback on long button tap, don't trigger if callback is empty
	- **on_hold_click** - hold callback, before long_click trigger, don't trigger if callback is empty
	- **on_double_click** - different callback, if tap button 2+ in row, don't trigger if callback is empty
- If you have stencil on buttons and you don't want trigger them outside of stencil node, you can use `button:set_click_zone` to restrict button click zone
- Button can have key trigger to use then by key: `button:set_key_trigger`


## Text

Basic Druid text component

- Text component by default have auto adjust text sizing. Text never will be bigger, than text node size, which you can setup in GUI scene. It can be disabled on component creating by settings argument `is_no_adjust` to _true_

![](../media/text_autosize.png)

- Text pivot can be changed with `text:set_pivot`, and text will save their position inside their text size box:

![](../media/text_anchor.gif)


## Blocker

Druid component for block input

It can be used for block input in special zone.

Example:

![](../media/blocker_scheme.png)

Blue zone is **button** with close_window callback

Yellow zone is blocker with window content

So you can do the safe zones, when you have the big buttons

## Back Handler
Component to handle back button

It works on Android back button and Backspace. Key triggers in `input.binding` should be setup

Setup callback on back button with `druid:new_back_handler(callback)`

## Lang text
Wrap on Text component to handle localization
- This is text druid component, using druid get_text_function to set text by it's id

## Scroll
Basic Druid scroll component

## Progress
Basic Druid progress bar component

## Slider
Basic Druid slider component
- You can setup points of interests on slider via `slider:set_steps`. If steps are exist, slider values will be only from this steps (notched slider)

## Input
Basic Druid text input component (unimplemented)

## Checkbox
Basic Druid checkbox component

## Checkbox group
Several checkboxes in one group

## Radio group
Several checkboxes in one group with single choice

## Timer
Handle timer work on gui text node

## Grid
Component for manage node positions 

## Hover
System Druid component, handle hover node state