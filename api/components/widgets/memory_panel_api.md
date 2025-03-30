# druid.widget.memory_panel API

> at /druid/widget/memory_panel/memory_panel.lua


## Functions
- [init](#init)
- [on_remove](#on_remove)
- [set_low_memory_limit](#set_low_memory_limit)
- [push_next_value](#push_next_value)
- [update_text_memory](#update_text_memory)


## Fields
- [root](#root)
- [delta_time](#delta_time)
- [samples_count](#samples_count)
- [memory_limit](#memory_limit)
- [mini_graph](#mini_graph)
- [max_value](#max_value)
- [text_per_second](#text_per_second)
- [text_memory](#text_memory)
- [memory](#memory)
- [memory_samples](#memory_samples)
- [timer_id](#timer_id)



### init

---
```lua
memory_panel:init()
```

### on_remove

---
```lua
memory_panel:on_remove()
```

### set_low_memory_limit

---
```lua
memory_panel:set_low_memory_limit([limit])
```

- **Parameters:**
	- `[limit]` *(any)*:

### push_next_value

---
```lua
memory_panel:push_next_value()
```

### update_text_memory

---
```lua
memory_panel:update_text_memory()
```


## Fields
<a name="root"></a>
- **root** (_node_)

<a name="delta_time"></a>
- **delta_time** (_number_)

<a name="samples_count"></a>
- **samples_count** (_integer_)

<a name="memory_limit"></a>
- **memory_limit** (_integer_)

<a name="mini_graph"></a>
- **mini_graph** (_druid.widget.mini_graph_): Widget to display a several lines with different height in a row
Init, set amount of samples and max value of value means that the line will be at max height
Use `push_line_value` to add a new value to the line
Or `set_line_value` to set a value to the line by index
Setup colors inside template file (at minimum and maximum)

<a name="max_value"></a>
- **max_value** (_druid.text_): The component to handle text behaviour over a GUI Text node, mainly used to automatically adjust text size to fit the text area

<a name="text_per_second"></a>
- **text_per_second** (_druid.text_): The component to handle text behaviour over a GUI Text node, mainly used to automatically adjust text size to fit the text area

<a name="text_memory"></a>
- **text_memory** (_druid.text_): The component to handle text behaviour over a GUI Text node, mainly used to automatically adjust text size to fit the text area

<a name="memory"></a>
- **memory** (_unknown_)

<a name="memory_samples"></a>
- **memory_samples** (_table_)

<a name="timer_id"></a>
- **timer_id** (_unknown_)

