# Static Grid Quick API reference

```lua
static_grid:init(parent, element, [in_row])
static_grid:add(item, [index], [shift_policy], [is_instant])
static_grid:get_index(pos)
static_grid:get_index_by_node(node)
static_grid:get_pos(index)
static_grid:get_size()
static_grid:get_size_for(count)
static_grid:on_layout_change()
static_grid:on_style_change(style)
static_grid:refresh()
static_grid:remove(index, [shift_policy], [is_instant])
static_grid:set_anchor(anchor)
static_grid:set_items(nodes, [is_instant])
static_grid:set_pivot(pivot)
