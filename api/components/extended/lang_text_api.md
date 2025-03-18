# druid.lang_text API

> at /druid/extended/lang_text.lua

The component used for displaying localized text, can automatically update text when locale is changed


## Functions
- [init](#init)
- [on_language_change](#on_language_change)
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
	- `[locale_id]` *(string|nil)*: Default locale id or text from node as default
	- `[adjust_type]` *(string|nil)*: Adjust type for text. By default is DOWNSCALE. Look const.TEXT_ADJUST for reference

- **Returns:**
	- `` *(druid.lang_text)*:

### on_language_change

---
```lua
lang_text:on_language_change()
```

### set_to

---
```lua
lang_text:set_to(text)
```

Setup raw text to lang_text component

- **Parameters:**
	- `text` *(string)*: Text for text node

- **Returns:**
	- `self` *(druid.lang_text)*: Current instance

### set_text

---
```lua
lang_text:set_text(text)
```

Setup raw text to lang_text component

- **Parameters:**
	- `text` *(string)*: Text for text node

- **Returns:**
	- `self` *(druid.lang_text)*: Current instance

### translate

---
```lua
lang_text:translate(locale_id, ...)
```

Translate the text by locale_id

- **Parameters:**
	- `locale_id` *(string)*: Locale id
	- `...` *(...)*: vararg

- **Returns:**
	- `self` *(druid.lang_text)*: Current instance

### format

---
```lua
lang_text:format(...)
```

Format string with new text params on localized text

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
- **on_change** (_event_): The event triggered when the text is changed

<a name="druid"></a>
- **druid** (_druid.instance_): The Druid Factory used to create components

