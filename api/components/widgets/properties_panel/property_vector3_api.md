# druid.widget.property_vector3 API

> at /druid/widget/properties_panel/properties/property_vector3.lua


## Functions
- [init](#init)
- [set_text_property](#set_text_property)
- [set_value](#set_value)


## Fields
- [root](#root)
- [container](#container)
- [text_name](#text_name)
- [button](#button)
- [druid](#druid)
- [selected_x](#selected_x)
- [selected_y](#selected_y)
- [selected_z](#selected_z)
- [rich_input_x](#rich_input_x)
- [rich_input_y](#rich_input_y)
- [rich_input_z](#rich_input_z)
- [value](#value)
- [on_change](#on_change)



### init

---
```lua
property_vector3:init()
```

### set_text_property

---
```lua
property_vector3:set_text_property(text)
```

- **Parameters:**
	- `text` *(string)*:

- **Returns:**
	- `` *(druid.widget.property_vector3)*:

### set_value

---
```lua
property_vector3:set_value(x, y, z)
```

- **Parameters:**
	- `x` *(number)*:
	- `y` *(number)*:
	- `z` *(number)*:

- **Returns:**
	- `` *(druid.widget.property_vector3)*:


## Fields
<a name="root"></a>
- **root** (_node_)

<a name="container"></a>
- **container** (_druid.container_): The component used for managing the size and positions with other containers relations to create a adaptable layouts

<a name="text_name"></a>
- **text_name** (_druid.text_): The component to handle text behaviour over a GUI Text node, mainly used to automatically adjust text size to fit the text area

<a name="button"></a>
- **button** (_druid.button_): Druid component to make clickable node with various interaction callbacks

<a name="druid"></a>
- **druid** (_druid.instance_): The Druid Factory used to create components

<a name="selected_x"></a>
- **selected_x** (_node_)

<a name="selected_y"></a>
- **selected_y** (_node_)

<a name="selected_z"></a>
- **selected_z** (_node_)

<a name="rich_input_x"></a>
- **rich_input_x** (_druid.rich_input_): The component that handles a rich text input field, it's a wrapper around the druid.input component

<a name="rich_input_y"></a>
- **rich_input_y** (_druid.rich_input_): The component that handles a rich text input field, it's a wrapper around the druid.input component

<a name="rich_input_z"></a>
- **rich_input_z** (_druid.rich_input_): The component that handles a rich text input field, it's a wrapper around the druid.input component

<a name="value"></a>
- **value** (_unknown_)

<a name="on_change"></a>
- **on_change** (_unknown_)

