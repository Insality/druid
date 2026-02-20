# druid.input API

> at /druid/extended/input.lua

Basic Druid text input component. Handles user text input via component with button and text.

### Setup
Create input component with druid: `input = druid:new_input(button_node_name, text_node_name, keyboard_type)`

### Notes
- Input component handles user text input. Input contains button and text components
- Button needed for selecting/unselecting input field
- Click outside of button to unselect input field
- On focus lost (game minimized) input field will be unselected
- You can setup max length of the text
- You can setup allowed characters. On add not allowed characters `on_input_wrong` will be called

## Functions

- [init](#init)
- [get_text_selected](#get_text_selected)
- [get_text_selected_replaced](#get_text_selected_replaced)
- [set_text](#set_text)
- [select](#select)
- [unselect](#unselect)
- [get_text](#get_text)
- [set_max_length](#set_max_length)
- [set_allowed_characters](#set_allowed_characters)
- [reset_changes](#reset_changes)
- [select_cursor](#select_cursor)
- [move_selection](#move_selection)
## Fields

- [on_input_select](#on_input_select)
- [on_input_unselect](#on_input_unselect)
- [on_input_text](#on_input_text)
- [on_input_empty](#on_input_empty)
- [on_input_full](#on_input_full)
- [on_input_wrong](#on_input_wrong)
- [on_select_cursor_change](#on_select_cursor_change)
- [style](#style)
- [druid](#druid)
- [text](#text)
- [is_selected](#is_selected)
- [value](#value)
- [previous_value](#previous_value)
- [current_value](#current_value)
- [marked_value](#marked_value)
- [is_empty](#is_empty)
- [text_width](#text_width)
- [market_text_width](#market_text_width)
- [total_width](#total_width)
- [cursor_index](#cursor_index)
- [start_index](#start_index)
- [end_index](#end_index)
- [max_length](#max_length)
- [allowed_characters](#allowed_characters)
- [keyboard_type](#keyboard_type)
- [button](#button)
- [marked_text_width](#marked_text_width)



### init

---
```lua
input:init(click_node, text_node, [keyboard_type])
```

- **Parameters:**
	- `click_node` *(node)*: Node to enabled input component
	- `text_node` *(druid.text|node)*: Text node what will be changed on user input. You can pass text component instead of text node name Text
	- `[keyboard_type]` *(constant|nil)*: Gui keyboard type for input field

### get_text_selected

---
```lua
input:get_text_selected()
```

- **Returns:**
	- `` *(string|unknown)*:

### get_text_selected_replaced

---
```lua
input:get_text_selected_replaced(text)
```

Replace selected text with new text

- **Parameters:**
	- `text` *(string)*: The text to replace selected text

- **Returns:**
	- `new_text` *(string)*: New input text

### set_text

---
```lua
input:set_text([input_text])
```

Set text for input field

- **Parameters:**
	- `[input_text]` *(string?)*: The string to apply for input field, if nil - will be set to empty string

### select

---
```lua
input:select()
```

Select input field. It will show the keyboard and trigger on_select events

### unselect

---
```lua
input:unselect()
```

Remove selection from input. It will hide the keyboard and trigger on_unselect events

### get_text

---
```lua
input:get_text()
```

Return current input field text

- **Returns:**
	- `text` *(string)*: The current input field text

### set_max_length

---
```lua
input:set_max_length(max_length)
```

Set maximum length for input field.
Pass nil to make input field unliminted (by default)

- **Parameters:**
	- `max_length` *(number)*: Maximum length for input text field

- **Returns:**
	- `self` *(druid.input)*: Current input instance

### set_allowed_characters

---
```lua
input:set_allowed_characters(characters)
```

Set allowed charaters for input field.
See: https://defold.com/ref/stable/string/
ex: [%a%d] for alpha and numeric
ex: [abcdef] to allow only these characters
ex: [^%s] to allow only non-space characters

- **Parameters:**
	- `characters` *(string)*: Regular expression for validate user input

- **Returns:**
	- `self` *(druid.input)*: Current input instance

### reset_changes

---
```lua
input:reset_changes()
```

Reset current input selection and return previous value

- **Returns:**
	- `self` *(druid.input)*: Current input instance

### select_cursor

---
```lua
input:select_cursor([cursor_index], [start_index], [end_index])
```

Set cursor position in input field

- **Parameters:**
	- `[cursor_index]` *(number|nil)*: Cursor index for cursor position, if nil - will be set to the end of the text
	- `[start_index]` *(number|nil)*: Start index for cursor position, if nil - will be set to the end of the text
	- `[end_index]` *(number|nil)*: End index for cursor position, if nil - will be set to the start_index

- **Returns:**
	- `self` *(druid.input)*: Current input instance

### move_selection

---
```lua
input:move_selection(delta, is_add_to_selection, is_move_to_end)
```

Change cursor position by delta

- **Parameters:**
	- `delta` *(number)*: side for cursor position, -1 for left, 1 for right
	- `is_add_to_selection` *(boolean)*: (Shift key)
	- `is_move_to_end` *(boolean)*: (Ctrl key)

- **Returns:**
	- `self` *(druid.input)*: Current input instance


## Fields
<a name="on_input_select"></a>
- **on_input_select** (_event_): fun(self: druid.input, input: druid.input) The event triggered when the input field is selected

<a name="on_input_unselect"></a>
- **on_input_unselect** (_event_): fun(self: druid.input, text: string, input: druid.input) The event triggered when the input field is unselected

<a name="on_input_text"></a>
- **on_input_text** (_event_): fun(self: druid.input) The event triggered when the input field is changed

<a name="on_input_empty"></a>
- **on_input_empty** (_event_): fun(self: druid.input) The event triggered when the input field is empty

<a name="on_input_full"></a>
- **on_input_full** (_event_): fun(self: druid.input) The event triggered when the input field is full

<a name="on_input_wrong"></a>
- **on_input_wrong** (_event_): fun(self: druid.input) The event triggered when the input field is wrong

<a name="on_select_cursor_change"></a>
- **on_select_cursor_change** (_event_): fun(self: druid.input, cursor_index: number, start_index: number, end_index: number) The event triggered when the cursor index is changed

<a name="style"></a>
- **style** (_druid.input.style_): The style of the input component

<a name="druid"></a>
- **druid** (_druid.instance_): The Druid Factory used to create components

<a name="text"></a>
- **text** (_druid.text|node_): Basic Druid text component. Text components by default have the text size adjusting.

<a name="is_selected"></a>
- **is_selected** (_boolean_)

<a name="value"></a>
- **value** (_unknown_)

<a name="previous_value"></a>
- **previous_value** (_unknown_)

<a name="current_value"></a>
- **current_value** (_unknown_)

<a name="marked_value"></a>
- **marked_value** (_string_)

<a name="is_empty"></a>
- **is_empty** (_boolean_)

<a name="text_width"></a>
- **text_width** (_integer_)

<a name="market_text_width"></a>
- **market_text_width** (_integer_)

<a name="total_width"></a>
- **total_width** (_integer_)

<a name="cursor_index"></a>
- **cursor_index** (_integer_)

<a name="start_index"></a>
- **start_index** (_number_)

<a name="end_index"></a>
- **end_index** (_number_)

<a name="max_length"></a>
- **max_length** (_nil_)

<a name="allowed_characters"></a>
- **allowed_characters** (_nil_)

<a name="keyboard_type"></a>
- **keyboard_type** (_constant_)

<a name="button"></a>
- **button** (_druid.button_): Basic Druid input component. Handle input on node and provide different callbacks on touch events.

<a name="marked_text_width"></a>
- **marked_text_width** (_number_)

