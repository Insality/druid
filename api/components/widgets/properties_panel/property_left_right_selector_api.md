# druid.widget.property_left_right_selector API

> at /druid/widget/properties_panel/properties/property_left_right_selector.lua


## Functions
- [init](#init)
- [set_text](#set_text)
- [on_button_left](#on_button_left)
- [on_button_right](#on_button_right)
- [add_step](#add_step)
- [set_number_type](#set_number_type)
- [set_array_type](#set_array_type)
- [set_value](#set_value)
- [get_value](#get_value)


## Fields
- [root](#root)
- [druid](#druid)
- [text_name](#text_name)
- [button](#button)
- [selected](#selected)
- [value](#value)
- [on_change_value](#on_change_value)
- [text_value](#text_value)
- [button_left](#button_left)
- [button_right](#button_right)
- [container](#container)
- [number_type](#number_type)
- [array_type](#array_type)



### init

---
```lua
property_left_right_selector:init()
```

### set_text

---
```lua
property_left_right_selector:set_text([text])
```

- **Parameters:**
	- `[text]` *(any)*:

- **Returns:**
	- `` *(druid.widget.property_left_right_selector)*:

### on_button_left

---
```lua
property_left_right_selector:on_button_left()
```

### on_button_right

---
```lua
property_left_right_selector:on_button_right()
```

### add_step

---
```lua
property_left_right_selector:add_step(koef)
```

- **Parameters:**
	- `koef` *(number)*: -1 0 1, on 0 will not move

### set_number_type

---
```lua
property_left_right_selector:set_number_type([min], [max], [is_loop], [steps])
```

- **Parameters:**
	- `[min]` *(any)*:
	- `[max]` *(any)*:
	- `[is_loop]` *(any)*:
	- `[steps]` *(any)*:

- **Returns:**
	- `` *(druid.widget.property_left_right_selector)*:

### set_array_type

---
```lua
property_left_right_selector:set_array_type([array], [is_loop], [steps])
```

- **Parameters:**
	- `[array]` *(any)*:
	- `[is_loop]` *(any)*:
	- `[steps]` *(any)*:

- **Returns:**
	- `` *(druid.widget.property_left_right_selector)*:

### set_value

---
```lua
property_left_right_selector:set_value(value, [is_instant])
```

- **Parameters:**
	- `value` *(string|number)*:
	- `[is_instant]` *(any)*:

### get_value

---
```lua
property_left_right_selector:get_value()
```

- **Returns:**
	- `` *(string|number)*:


## Fields
<a name="root"></a>
- **root** (_node_)

<a name="druid"></a>
- **druid** (_druid.instance_): The Druid Factory used to create components

<a name="text_name"></a>
- **text_name** (_druid.text_): The component to handle text behaviour over a GUI Text node, mainly used to automatically adjust text size to fit the text area

<a name="button"></a>
- **button** (_druid.button_): Druid component to make clickable node with various interaction callbacks

<a name="selected"></a>
- **selected** (_node_)

<a name="value"></a>
- **value** (_string_)

<a name="on_change_value"></a>
- **on_change_value** (_event_): fun(value: string|number)

<a name="text_value"></a>
- **text_value** (_druid.text_): The component to handle text behaviour over a GUI Text node, mainly used to automatically adjust text size to fit the text area

<a name="button_left"></a>
- **button_left** (_druid.button_): Druid component to make clickable node with various interaction callbacks

<a name="button_right"></a>
- **button_right** (_druid.button_): Druid component to make clickable node with various interaction callbacks

<a name="container"></a>
- **container** (_druid.container_): The component used for managing the size and positions with other containers relations to create a adaptable layouts

<a name="number_type"></a>
- **number_type** (_table_)

<a name="array_type"></a>
- **array_type** (_table_)

