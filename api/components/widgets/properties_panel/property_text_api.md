# druid.widget.property_text API

> at /druid/widget/properties_panel/properties/property_text.lua

## Functions

- [init](#init)
- [set_text_property](#set_text_property)
- [set_text_value](#set_text_value)

## Fields

- [root](#root)
- [container](#container)
- [text_name](#text_name)
- [text_right](#text_right)



### init

---
```lua
property_text:init()
```

### set_text_property

---
```lua
property_text:set_text_property(text)
```

- **Parameters:**
	- `text` *(string)*:

- **Returns:**
	- `` *(druid.widget.property_text)*:

### set_text_value

---
```lua
property_text:set_text_value([text])
```

- **Parameters:**
	- `[text]` *(string|nil)*:

- **Returns:**
	- `` *(druid.widget.property_text)*:


## Fields
<a name="root"></a>
- **root** (_node_)

<a name="container"></a>
- **container** (_druid.container_): Druid component to manage the size and positions with other containers relations to create a adaptable layouts.

<a name="text_name"></a>
- **text_name** (_druid.text_): Basic Druid text component. Text components by default have the text size adjusting.

<a name="text_right"></a>
- **text_right** (_druid.text_): Basic Druid text component. Text components by default have the text size adjusting.

