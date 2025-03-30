# druid.rich_text API

> at /druid/custom/rich_text/rich_text.lua

The component that handles a rich text display, allows to custom color, size, font, etc. of the parts of the text


## Functions
- [init](#init)
- [set_text](#set_text)
- [get_text](#get_text)
- [clear](#clear)
- [tagged](#tagged)
- [get_words](#get_words)
- [get_line_metric](#get_line_metric)


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
rich_text:set_text("＜color=red＞Foobar＜/color＞")
rich_text:set_text("＜color=1.0,0,0,1.0＞Foobar＜/color＞")
rich_text:set_text("＜color=#ff0000＞Foobar＜/color＞")
rich_text:set_text("＜color=#ff0000ff＞Foobar＜/color＞")
rich_text:set_text("＜shadow=red＞Foobar＜/shadow＞")
rich_text:set_text("＜shadow=1.0,0,0,1.0＞Foobar＜/shadow＞")
rich_text:set_text("＜shadow=#ff0000＞Foobar＜/shadow＞")
rich_text:set_text("＜shadow=#ff0000ff＞Foobar＜/shadow＞")
rich_text:set_text("＜outline=red＞Foobar＜/outline＞")
rich_text:set_text("＜outline=1.0,0,0,1.0＞Foobar＜/outline＞")
rich_text:set_text("＜outline=#ff0000＞Foobar＜/outline＞")
rich_text:set_text("＜outline=#ff0000ff＞Foobar＜/outline＞")
rich_text:set_text("＜font=MyCoolFont＞Foobar＜/font＞")
rich_text:set_text("＜size=2＞Twice as large＜/size＞")
rich_text:set_text("＜br/＞Insert a line break")
rich_text:set_text("＜nobr＞Prevent the text from breaking")
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


## Fields
<a name="root"></a>
- **root** (_node_): The root node of the rich text

<a name="text_prefab"></a>
- **text_prefab** (_node_): The text prefab node

<a name="style"></a>
- **style** (_table_)

