# Druid Rich Text

## Links
[Rich Text API here](https://insality.github.io/druid/modules/RichText.html)

## Overview


## Setup

Rich Text requires the next GUI Node scheme:
```bash
 root
 ├── text_prefab
 └── node_prefab
```
or make the copy of `/druid/custom/rich_text/rich_text.gui` and adjust your default settings

Create Rich Text:
```lua
local RichText = require("druid.custom.rich_text.rich_text")

function init(self)
	self.druid = druid.new(self)
	self.rich_text = self.druid:new(RichText, "template_name")
	self.rich_text:set_text("Insert your text here")
end
```

## Usage

| Tag     | Description                                    | Example                                     |
|---------|------------------------------------------------|---------------------------------------------|
| a       | Create a "hyperlink" that generates a message  | `<a=message_id>Foobar</a>`                  |
|         | when clicked (see `richtext.on_click`)         |                                             |
| br      | Insert a line break (see notes on linebreak)   | `<br/>`                                     |
| color   | Change text color                              | `<color=red>Foobar</color>`                 |
|         |                                                | `<color=1.0,0,0,1.0>Foobar</color>`         |
|         |                                                | `<color=#ff0000>Foobar</color>`             |
|         |                                                | `<color=#ff0000ff>Foobar</color>`           |
| shadow  | Change text shadow                             | `<shadow=red>Foobar</shadow>`               |
|         |                                                | `<shadow=1.0,0,0,1.0>Foobar</shadow>`       |
|         |                                                | `<shadow=#ff0000>Foobar</shadow>`           |
|         |                                                | `<shadow=#ff0000ff>Foobar</shadow>`         |
| outline | Change text shadow                             | `<outline=red>Foobar</outline>`             |
|         |                                                | `<outline=1.0,0,0,1.0>Foobar</outline>`     |
|         |                                                | `<outline=#ff0000>Foobar</outline>`         |
|         |                                                | `<outline=#ff0000ff>Foobar</outline>`       |
| font    | Change font                                    | `<font=MyCoolFont>Foobar</font>`            |
| img     | Display image                                  | `<img=texture:image/>`                      |
|         | Display image in fixed square                  | `<img=texture:image,size/>`                 |
|         | Display image in fixed rectangle               | `<img=texture:image,width,height/>`         |
| nobr    | Prevent the text from breaking                 | `Words <nobr>inside tag</nobr> won't break` |
| size    | Change text size, relative to default size     | `<size=2>Twice as large</size>`             |


## Usecases

## Notes
