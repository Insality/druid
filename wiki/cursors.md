# Cursors

Druid changes the hardware mouse cursor through [DefOS](https://github.com/subsoap/defos). Add DefOS to your `game.project` dependencies. When the `defos` global is missing, the cursor fields stay empty and the system cursor stays as it is.

Cursors are for desktop and HTML5. On mobile the mouse-hover state is skipped, so only a pressed touch can request a cursor, and there is usually no pointer to change.

## The two fields

Every component that can change the cursor has the same two style fields:

- `ON_MOUSE_HOVER_CURSOR` — the pointer is over the node and no button is pressed. This is the usual desktop hover (`action_id` is nil).
- `ON_HOVER_CURSOR` — a touch or a mouse button is down on the node.

Set both to the same cursor. While the button is held, the touch cursor is on screen. After release, the mouse cursor comes back if the pointer is still over the node. With only one field set, the cursor appears only for that state: only while hovering, or only while pressed.

`nil` leaves that state out. When no node wants a cursor, Druid calls `defos.set_cursor(nil)`, which is the system cursor.

The value is anything [`defos.set_cursor`](https://github.com/subsoap/defos/blob/master/README.md) accepts:

- `defos.CURSOR_ARROW`
- `defos.CURSOR_HAND`
- `defos.CURSOR_CROSSHAIR`
- `defos.CURSOR_IBEAM`
- a cursor loaded with `defos.load_cursor`
- `nil`

## Default cursors

With DefOS in the project, the [default style](https://github.com/Insality/druid/blob/master/druid/styles/default/style.lua) is:

| Component | Cursor | Where it shows |
| --- | --- | --- |
| Button | `CURSOR_HAND` | The button node |
| Drag | `CURSOR_HAND` | The drag node. `drag.hover` is created when DefOS is available and a cursor is set |
| Slider | `CURSOR_HAND` | The pin, and the input node from `set_input_node`. `slider.hover` is nil without DefOS or when both cursors are nil |
| Input | `CURSOR_IBEAM` | The input node |
| Rich Input | The Input cursors | The whole field, including the inner drag |
| Scroll | `nil` | The view, and only while the content can scroll |
| Hover | `nil` | `new_hover` keeps the current cursor until you set the fields |

A disabled Button, Drag or Slider drops its cursor. Removing the component does the same, and the previous cursor comes back if another node is still hovered.

If you replace the default style with your own table, add these fields to the sections you use. A custom `button` section without them has an empty cursor.

## Set them in a style

Put the two fields in your style module, next to the other fields of that component. Components created after the style is set pick them up. Already created components keep the cursors they were created with. See [Styles](styles.md) for `druid.set_default_style`, `druid.new(self, style)` and `component:set_style`.

```lua
button = {
	ON_HOVER_CURSOR = defos and defos.CURSOR_HAND or nil,
	ON_MOUSE_HOVER_CURSOR = defos and defos.CURSOR_HAND or nil,
},
```

The same keys exist on `drag`, `slider`, `input`, `scroll` and `hover`.

To turn the scroll cursor on in the default style, set the fields before you create scrolls:

```lua
local style = require("druid.styles.default.style")
style.scroll.ON_HOVER_CURSOR = defos and defos.CURSOR_HAND or nil
style.scroll.ON_MOUSE_HOVER_CURSOR = defos and defos.CURSOR_HAND or nil
```

The `hover` section covers every `new_hover`, including hovers you create yourself. Leave it nil when only buttons, drags and inputs should change the cursor.

## One component

The fields are read when the pointer enters or leaves. Assign them before that happens.

```lua
local button = self.druid:new_button("buy", self.on_buy)
button.hover.style.ON_HOVER_CURSOR = defos.CURSOR_HAND
button.hover.style.ON_MOUSE_HOVER_CURSOR = defos.CURSOR_HAND
```

A node that is not a button gets the same treatment through Hover. The Hover style cursors are nil, so set them on the instance:

```lua
local hover = self.druid:new_hover("card")
hover.style.ON_HOVER_CURSOR = defos.CURSOR_HAND
hover.style.ON_MOUSE_HOVER_CURSOR = defos.CURSOR_HAND
```

Drag reads the cursors from its own style. `set_drag_cursors` creates the hover on the first enable and picks the fields up. `drag.hover` is nil when DefOS is missing.

```lua
local drag = self.druid:new_drag("token")
drag.style.ON_HOVER_CURSOR = defos.CURSOR_CROSSHAIR
drag.style.ON_MOUSE_HOVER_CURSOR = defos.CURSOR_CROSSHAIR
drag:set_drag_cursors(true)
```

`drag:set_drag_cursors(false)` hides them. A disabled drag hides them too.

Input stores the cursors on the inner button hover:

```lua
input.button.hover.style.ON_HOVER_CURSOR = defos.CURSOR_IBEAM
input.button.hover.style.ON_MOUSE_HOVER_CURSOR = defos.CURSOR_IBEAM
```

Rich Input copies the Input style onto its drag when it is created and again when the field is selected. Change the Input style cursors so the field and the drag stay on the same cursor.

Slider copies its style onto the pin and the input node when the slider is created and when `set_style` runs. `slider.hover` is that pin hover.

A custom image is a cursor from `defos.load_cursor`, stored in the same two fields. Druid passes that value to `defos.set_cursor` unchanged. Loading the image is DefOS's part, and the file format differs per platform: see the [DefOS readme](https://github.com/subsoap/defos/blob/master/README.md).

## Several nodes at once

Each hovered node keeps its own cursor. The pressed cursor wins over the plain hover cursor for as long as the button is down. When the pointer leaves, the component is disabled, or the component is removed, that cursor is dropped and the next one is shown.

A component that consumes the mouse move, such as a Blocker, clears the mouse hover of the nodes under it. Their cursor goes away while the pointer is over the blocker.
