# druid.widget.property_button API

> at /druid/widget/properties_panel/properties/property_button.lua


## Functions
- [init](#init)
- [on_click](#on_click)
- [set_text_property](#set_text_property)
- [set_text_button](#set_text_button)
- [set_color](#set_color)


## Fields
- [root](#root)
- [container](#container)
- [text_name](#text_name)
- [button](#button)
- [text_button](#text_button)
- [druid](#druid)
- [selected](#selected)



### init

---
```lua
property_button:init()
```

### on_click

---
```lua
property_button:on_click()
```

### set_text_property

---
```lua
property_button:set_text_property(text)
```

- **Parameters:**
	- `text` *(string)*:

- **Returns:**
	- `` *(druid.widget.property_button)*:

### set_text_button

---
```lua
property_button:set_text_button(text)
```

- **Parameters:**
	- `text` *(string)*:

- **Returns:**
	- `` *(druid.widget.property_button)*:

### set_color

---
```lua
property_button:set_color([color_value])
```

- **Parameters:**
	- `[color_value]` *(any)*:


## Fields
<a name="root"></a>
- **root** (_node_)

<a name="container"></a>
- **container** (_druid.container_): The component used for managing the size and positions with other containers relations to create a adaptable layouts

<a name="text_name"></a>
- **text_name** (_druid.text_): The component to handle text behaviour over a GUI Text node, mainly used to automatically adjust text size to fit the text area

<a name="button"></a>
- **button** (_druid.button_): Druid component to make clickable node with various interaction callbacks

<a name="text_button"></a>
- **text_button** (_druid.text_): The component to handle text behaviour over a GUI Text node, mainly used to automatically adjust text size to fit the text area

<a name="druid"></a>
- **druid** (_druid.instance_): The Druid Factory used to create components

<a name="selected"></a>
- **selected** (_node_)

