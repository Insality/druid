# druid.widget.fps_panel API

> at /druid/widget/fps_panel/fps_panel.lua

## Functions

- [init](#init)
- [on_remove](#on_remove)
- [update](#update)
- [push_fps_value](#push_fps_value)

## Fields

- [root](#root)
- [delta_time](#delta_time)
- [collect_time](#collect_time)
- [collect_time_counter](#collect_time_counter)
- [graph_samples](#graph_samples)
- [fps_samples](#fps_samples)
- [mini_graph](#mini_graph)
- [text_min_fps](#text_min_fps)
- [text_fps](#text_fps)
- [timer_id](#timer_id)
- [previous_time](#previous_time)



### init

---
```lua
fps_panel:init()
```

### on_remove

---
```lua
fps_panel:on_remove()
```

### update

---
```lua
fps_panel:update([dt])
```

- **Parameters:**
	- `[dt]` *(any)*:

### push_fps_value

---
```lua
fps_panel:push_fps_value()
```


## Fields
<a name="root"></a>
- **root** (_node_)

<a name="delta_time"></a>
- **delta_time** (_number_):  in seconds

<a name="collect_time"></a>
- **collect_time** (_integer_):  in seconds

<a name="collect_time_counter"></a>
- **collect_time_counter** (_integer_)

<a name="graph_samples"></a>
- **graph_samples** (_number_)

<a name="fps_samples"></a>
- **fps_samples** (_table_):  Store frame time in seconds last collect_time seconds

<a name="mini_graph"></a>
- **mini_graph** (_druid.widget.mini_graph_): Widget to display a several lines with different height in a row

<a name="text_min_fps"></a>
- **text_min_fps** (_druid.text_): Basic Druid text component. Text components by default have the text size adjusting.

<a name="text_fps"></a>
- **text_fps** (_druid.text_): Basic Druid text component. Text components by default have the text size adjusting.

<a name="timer_id"></a>
- **timer_id** (_unknown_)

<a name="previous_time"></a>
- **previous_time** (_unknown_)

