# druid.lang_text API

> at /druid/extended/lang_text.lua

The component used for displaying localized text, can automatically update text when locale is changed.
It wraps the Text component to handle localization using druid's get_text_function to set text by its id.

### Setup
Create lang text component with druid: `text = druid:new_lang_text(node_name, locale_id)`

### Notes
- Component automatically updates text when locale is changed
- Uses druid's get_text_function to get localized text by id
- Supports string formatting with additional parameters

## Functions

- [init](#init)
- [set_to](#set_to)
- [set_text](#set_text)
- [translate](#translate)
- [format](#format)

## Fields

- [text](#text)
- [node](#node)
- [on_change](#on_change)
- [druid](#druid)



### init

---
```lua
lang_text:init(node, [locale_id], [adjust_type])
```

- **Parameters:**
	- `node` *(string|node)*: The node_id or gui.get_node(node_id)
	- `[locale_id]` *(string|nil)*: Default locale id or text from node as default. If not provided, will use text from the node
	- `[adjust_type]` *(string|nil)*: Adjust type for text. By default is DOWNSCALE. Look const.TEXT_ADJUST for reference

- **Returns:**
	- `` *(druid.lang_text)*:

### set_to

---
```lua
lang_text:set_to(text)
```

Setup raw text to lang_text component. This will clear any locale settings.

- **Parameters:**
	- `text` *(string)*: Text for text node

- **Returns:**
	- `self` *(druid.lang_text)*: Current instance

### set_text

---
```lua
lang_text:set_text(text)
```

Setup raw text to lang_text component. This will clear any locale settings.

- **Parameters:**
	- `text` *(string)*: Text for text node

- **Returns:**
	- `self` *(druid.lang_text)*: Current instance

### translate

---
```lua
lang_text:translate(locale_id, ...)
```

Translate the text by locale_id. The text will be automatically updated when locale changes.

- **Parameters:**
	- `locale_id` *(string)*: Locale id to get text from
	- `...` *(...)*: vararg

- **Returns:**
	- `self` *(druid.lang_text)*: Current instance

### format

---
```lua
lang_text:format(...)
```

Format string with new text params on localized text. Keeps the current locale but updates the format parameters.

- **Parameters:**
	- `...` *(...)*: vararg

- **Returns:**
	- `self` *(druid.lang_text)*: Current instance


## Fields
<a name="text"></a>
- **text** (_druid.text_): The text component

<a name="node"></a>
- **node** (_node_): The node of the text component

<a name="on_change"></a>
- **on_change** (_event_): fun(self: druid.lang_text) The event triggered when the text is changed

<a name="druid"></a>
- **druid** (_druid.instance_): The Druid Factory used to create components

