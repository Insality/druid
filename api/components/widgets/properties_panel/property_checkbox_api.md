
# druid.widget.property_checkbox API

> at /druid/widget/properties_panel/properties/property_checkbox.lua


## Functions
- [init](#init)
- [set_value](#set_value)
- [get_value](#get_value)
- [on_click](#on_click)
- [set_text_property](#set_text_property)
- [on_change](#on_change)


## Fields
- [root](#root)
- [druid](#druid)
- [text_name](#text_name)
- [button](#button)
- [selected](#selected)
- [icon](#icon)
- [container](#container)
- [on_change_value](#on_change_value)



### init

---
```lua
property_checkbox:init()
```

### set_value

---
```lua
property_checkbox:set_value(value, [is_instant])
```

- **Parameters:**
	- `value` *(boolean)*:
	- `[is_instant]` *(any)*:

### get_value

---
```lua
property_checkbox:get_value()
```

- **Returns:**
	- `` *(boolean)*:

### on_click

---
```lua
property_checkbox:on_click()
```

### set_text_property

---
```lua
property_checkbox:set_text_property(text)
```

Set the text property of the checkbox

- **Parameters:**
	- `text` *(string)*:

### on_change

---
```lua
property_checkbox:on_change(callback)
```

Set the callback function for when the checkbox value changes

- **Parameters:**
	- `callback` *(function)*:


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

<a name="icon"></a>
- **icon** (_node_)

<a name="container"></a>
- **container** (_druid.container_): The component used for managing the size and positions with other containers relations to create a adaptable layouts

<a name="on_change_value"></a>
- **on_change_value** (_unknown_)

