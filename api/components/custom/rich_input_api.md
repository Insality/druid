# druid.rich_input API

> at /druid/custom/rich_input/rich_input.lua


## Functions
- [init](#init)
- [on_input](#on_input)
- [set_placeholder](#set_placeholder)
- [select](#select)
- [set_text](#set_text)
- [set_font](#set_font)
- [get_text](#get_text)
- [set_allowed_characters](#set_allowed_characters)


## Fields
- [root](#root)
- [input](#input)
- [cursor](#cursor)
- [cursor_text](#cursor_text)
- [cursor_position](#cursor_position)
- [druid](#druid)
- [is_lshift](#is_lshift)
- [is_lctrl](#is_lctrl)
- [is_button_input_enabled](#is_button_input_enabled)
- [drag](#drag)
- [placeholder](#placeholder)
- [text_position](#text_position)



### init

---
```lua
rich_input:init(template, nodes)
```

- **Parameters:**
	- `template` *(string)*: The template string name
	- `nodes` *(table)*: Nodes table from gui.clone_tree

### on_input

---
```lua
rich_input:on_input([action_id], [action])
```

- **Parameters:**
	- `[action_id]` *(any)*:
	- `[action]` *(any)*:

- **Returns:**
	- `` *(boolean)*:

### set_placeholder

---
```lua
rich_input:set_placeholder(placeholder_text)
```

Set placeholder text

- **Parameters:**
	- `placeholder_text` *(string)*: The placeholder text

- **Returns:**
	- `` *(druid.rich_input)*:

### select

---
```lua
rich_input:select()
```

Select input field

### set_text

---
```lua
rich_input:set_text(text)
```

Set input field text

- **Parameters:**
	- `text` *(string)*: The input text

- **Returns:**
	- `self` *(druid.rich_input)*: Current instance

### set_font

---
```lua
rich_input:set_font(font)
```

Set input field font

- **Parameters:**
	- `font` *(hash)*: The font hash

- **Returns:**
	- `self` *(druid.rich_input)*: Current instance

### get_text

---
```lua
rich_input:get_text()
```

Set input field text

- **Returns:**
	- `` *(string)*:

### set_allowed_characters

---
```lua
rich_input:set_allowed_characters(characters)
```

Set allowed charaters for input field.
 See: https://defold.com/ref/stable/string/
 ex: [%a%d] for alpha and numeric

- **Parameters:**
	- `characters` *(string)*: Regulax exp. for validate user input

- **Returns:**
	- `Current` *(druid.rich_input)*: instance


## Fields
<a name="root"></a>
- **root** (_node_)

<a name="input"></a>
- **input** (_druid.input_)

<a name="cursor"></a>
- **cursor** (_node_)

<a name="cursor_text"></a>
- **cursor_text** (_node_)

<a name="cursor_position"></a>
- **cursor_position** (_vector3_)

<a name="druid"></a>
- **druid** (_druid.instance_)

<a name="is_lshift"></a>
- **is_lshift** (_boolean_)

<a name="is_lctrl"></a>
- **is_lctrl** (_boolean_)

<a name="is_button_input_enabled"></a>
- **is_button_input_enabled** (_unknown_)

<a name="drag"></a>
- **drag** (_druid.drag_)

<a name="placeholder"></a>
- **placeholder** (_druid.text_)

<a name="text_position"></a>
- **text_position** (_unknown_)

