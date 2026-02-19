# druid.rich_text API

> at /druid/custom/rich_text/rich_text.lua

The component that handles a rich text display, allows to custom color, size, font, etc. of the parts of the text

## Functions

- [init](#init)
- [set_text](#set_text)
- [get_text](#get_text)
- [set_pivot](#set_pivot)
- [clear](#clear)
- [tagged](#tagged)
- [set_split_to_characters](#set_split_to_characters)
- [get_words](#get_words)
- [get_line_metric](#get_line_metric)
- [set_width](#set_width)
- [set_height](#set_height)
## Fields

- [root](#root)
- [text_prefab](#text_prefab)
- [style](#style)



### init

---
```lua
rich_text:init(text_node, [value])
```

- **Parameters:**
	- `text_node` *(string|node)*: The text node to make Rich Text
	- `[value]` *(string|nil)*: The initial text value. Default will be gui.get_text(text_node)

### set_text

---
```lua
rich_text:set_text([text])
```

Set text for Rich Text

- **Parameters:**
	- `[text]` *(string|nil)*: The text to set

- **Returns:**
	- `words` *(druid.rich_text.word[])*:
	- `line_metrics` *(druid.rich_text.lines_metrics)*:

- **Example Usage:**

```lua
-- Color
rich_text:set_text("＜color=red＞Foobar＜/color＞")
rich_text:set_text("＜color=1.0,0,0,1.0＞Foobar＜/color＞")
rich_text:set_text("＜color=#ff0000＞Foobar＜/color＞")
rich_text:set_text("＜color=#ff0000ff＞Foobar＜/color＞")
-- Shadow
rich_text:set_text("＜shadow=red＞Foobar＜/shadow＞")
rich_text:set_text("＜shadow=1.0,0,0,1.0＞Foobar＜/shadow＞")
rich_text:set_text("＜shadow=#ff0000＞Foobar＜/shadow＞")
rich_text:set_text("＜shadow=#ff0000ff＞Foobar＜/shadow＞")
-- Outline
rich_text:set_text("＜outline=red＞Foobar＜/outline＞")
rich_text:set_text("＜outline=1.0,0,0,1.0＞Foobar＜/outline＞")
rich_text:set_text("＜outline=#ff0000＞Foobar＜/outline＞")
rich_text:set_text("＜outline=#ff0000ff＞Foobar＜/outline＞")
-- Font
rich_text:set_text("＜font=MyCoolFont＞Foobar＜/font＞")
-- Size
rich_text:set_text("＜size=2＞Twice as large＜/size＞")
-- Line break
rich_text:set_text("＜br/＞Insert a line break")
-- No break
rich_text:set_text("＜nobr＞Prevent the text from breaking")
-- Image
rich_text:set_text("＜img=texture:image＞Display image")
rich_text:set_text("＜img=texture:image,size＞Display image with size")
rich_text:set_text("＜img=texture:image,width,height＞Display image with width and height")
```
### get_text

---
```lua
rich_text:get_text()
```

Get the current text of the rich text

- **Returns:**
	- `text` *(string)*: The current text of the rich text

### set_pivot

---
```lua
rich_text:set_pivot(pivot)
```

Set pivot and keep the content in place (anchor). After this, resizing the root will keep the anchor fixed.

- **Parameters:**
	- `pivot` *(number)*: GUI pivot constant

- **Returns:**
	- `self` *(druid.rich_text)*:

### clear

---
```lua
rich_text:clear()
```

Clear all created words.

### tagged

---
```lua
rich_text:tagged(tag)
```

Get all words, which has a passed tag.

- **Parameters:**
	- `tag` *(string)*: The tag to get the words for

- **Returns:**
	- `words` *(druid.rich_text.word[])*: The words with the passed tag

### set_split_to_characters

---
```lua
rich_text:set_split_to_characters(value)
```

Set if the rich text should split to characters, not words

- **Parameters:**
	- `value` *(boolean)*:

- **Returns:**
	- `self` *(druid.rich_text)*:

### get_words

---
```lua
rich_text:get_words()
```

Get all current created words, each word is a table that contains the information about the word

- **Returns:**
	- `` *(druid.rich_text.word[])*:

### get_line_metric

---
```lua
rich_text:get_line_metric()
```

Get the current line metrics

- **Returns:**
	- `lines_metrics` *(druid.rich_text.lines_metrics)*: The line metrics of the rich text

### set_width

---
```lua
rich_text:set_width(width)
```

Set the width of the rich text, not affects the size of current spawned words

- **Parameters:**
	- `width` *(number)*:

- **Returns:**
	- `self` *(druid.rich_text)*:

### set_height

---
```lua
rich_text:set_height(height)
```

Set the height of the rich text, not affects the size of current spawned words

- **Parameters:**
	- `height` *(number)*:

- **Returns:**
	- `self` *(druid.rich_text)*:


## Fields
<a name="root"></a>
- **root** (_node_): The root text node of the rich text

<a name="text_prefab"></a>
- **text_prefab** (_node_): The text prefab node

<a name="style"></a>
- **style** (_table_)

