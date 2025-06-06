# druid.widget.property_input API

> at /druid/widget/properties_panel/properties/property_input.lua

## Functions

- [init](#init)
- [set_text_property](#set_text_property)
- [set_text_value](#set_text_value)
- [on_change](#on_change)

## Fields

- [root](#root)
- [container](#container)
- [text_name](#text_name)
- [button](#button)
- [druid](#druid)
- [selected](#selected)
- [rich_input](#rich_input)
- [on_change_value](#on_change_value)



### init

---
```lua
property_input:init()
```

### set_text_property

---
```lua
property_input:set_text_property(text)
```

- **Parameters:**
	- `text` *(string)*:

- **Returns:**
	- `` *(druid.widget.property_input)*:

### set_text_value

---
```lua
property_input:set_text_value(text)
```

- **Parameters:**
	- `text` *(string|number)*:

- **Returns:**
	- `` *(druid.widget.property_input)*:

### on_change

---
```lua
property_input:on_change(callback, [callback_context])
```

- **Parameters:**
	- `callback` *(fun(self: druid.widget.property_input, text: string))*:
	- `[callback_context]` *(any)*:


## Fields
<a name="root"></a>
- **root** (_node_)

<a name="container"></a>
- **container** (_druid.container_): Druid component to manage the size and positions with other containers relations to create a adaptable layouts.

<a name="text_name"></a>
- **text_name** (_druid.text_): Basic Druid text component. Text components by default have the text size adjusting.

<a name="button"></a>
- **button** (_druid.button_): Basic Druid input component. Handle input on node and provide different callbacks on touch events.

<a name="druid"></a>
- **druid** (_druid.instance_): The Druid Factory used to create components

<a name="selected"></a>
- **selected** (_node_)

<a name="rich_input"></a>
- **rich_input** (_druid.rich_input_): The component that handles a rich text input field, it's a wrapper around the druid.input component

<a name="on_change_value"></a>
- **on_change_value** (_event.event_): fun(text) Event triggered when the value of the input changes.
