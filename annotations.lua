---@class druid
---@field checkbox druid.checkbox Submodule
---@field checkbox_group druid.checkbox_group Submodule
---@field drag druid.drag Submodule
---@field dynamic_grid druid.dynamic_grid Submodule
---@field helper druid.helper Submodule
---@field hover druid.hover Submodule
---@field input druid.input Submodule
---@field lang_text druid.lang_text Submodule
---@field progress druid.progress Submodule
---@field radio_group druid.radio_group Submodule
---@field scroll druid.scroll Submodule
---@field slider druid.slider Submodule
---@field static_grid druid.static_grid Submodule
---@field swipe druid.swipe Submodule
---@field text druid.text Submodule
---@field timer druid.timer Submodule
---@field new fun(context:table, style:table):druid_instance Create Druid instance.
---@field on_language_change fun() Druid on language change.
---@field on_language_change fun() Callback on global language change event.
---@field on_layout_change fun() Callback on global layout change event.
---@field on_window_callback fun(event:string) Callback on global window event.
---@field register fun(name:string, module:table) Register external druid component.
---@field set_default_style fun(style:table) Set new default style.
---@field set_sound_function fun(callback:function) Set sound function.
---@field set_text_function fun(callback:function) Set text function  Druid locale component will call this function  to get translated text.

---@class druid.back_handler : druid.base_component
---@field on_back druid_event On back handler callback(self, params)
---@field init fun(self:druid.back_handler, callback:callback, params:any) Component init function
---@field on_input fun(self:druid.back_handler, action_id:string, action:table) Input handler for component

---@class druid.base_component
---@field get_context fun(self:druid.base_component):table Get current component context
---@field get_druid fun(self:druid.base_component):Druid Return druid with context of calling component.
---@field get_name fun(self:druid.base_component):string Return component name
---@field get_node fun(self:druid.base_component, node_or_name:string|node):node Get node for component by name.
---@field get_parent_component fun(self:druid.base_component):druid.base_component|nil Return the parent for current component
---@field increase_input_priority fun(self:druid.base_component) Increase input priority in current input stack
---@field reset_input_priority fun(self:druid.base_component) Reset input priority in current input stack
---@field set_input_enabled fun(self:druid.base_component, state:bool):druid.base_component Set component input state.
---@field set_nodes fun(self:druid.base_component, nodes:table) Set current component nodes
---@field set_style fun(self:druid.base_component, druid_style:table) Set current component style table.
---@field set_template fun(self:druid.base_component, template:string) Set current component template name
---@field setup_component fun(self:druid.base_component, druid_instance:table, context:table, style:table):component Setup component context and his style table

---@class druid.blocker : druid.base_component
---@field init fun(self:druid.blocker, node:node) Component init function
---@field is_enabled fun(self:druid.blocker):bool Return blocked enabled state
---@field set_enabled fun(self:druid.blocker, state:bool) Set enabled blocker component state

---@class druid.button : druid.base_component
---@field anim_node node Animation node
---@field hover druid.hover Druid hover logic component
---@field node node Trigger node
---@field on_click druid_event On release button callback(self, params, button_instance)
---@field on_click_outside druid_event On click outside of button(self, params, button_instance)
---@field on_double_click druid_event On double tap button callback(self, params, button_instance, click_amount)
---@field on_hold_callback druid_event On button hold before long_click callback(self, params, button_instance, time)
---@field on_long_click druid_event On long tap button callback(self, params, button_instance, time)
---@field on_repeated_click druid_event On repeated action button callback(self, params, button_instance, click_amount)
---@field params any Params to click callbacks
---@field pos vector3 Initial pos of anim_node
---@field start_pos vector3 Initial pos of anim_node
---@field start_scale vector3 Initial scale of anim_node
---@field style druid.button.style Component style params.
---@field get_key_trigger fun(self:druid.button):hash Get key-code to trigger this button
---@field init fun(self:druid.button, node:node, callback:function, params:table, anim_node:node) Component init function
---@field is_enabled fun(self:druid.button):bool Return button enabled state
---@field set_click_zone fun(self:druid.button, zone:node):druid.button Strict button click area.
---@field set_enabled fun(self:druid.button, state:bool):druid.button Set enabled button component state
---@field set_key_trigger fun(self:druid.button, key:hash):druid.button Set key-code to trigger this button

---@class druid.button.style
---@field AUTOHOLD_TRIGGER field  Maximum hold time to trigger button release while holding
---@field DOUBLETAP_TIME field  Time between double taps
---@field LONGTAP_TIME field  Minimum time to trigger on_hold_callback
---@field on_click field  (self, node)
---@field on_click_disabled field  (self, node)
---@field on_hover field  (self, node, hover_state)
---@field on_mouse_hover field  (self, node, hover_state)
---@field on_set_enabled field  (self, node, enabled_state)

---@class druid.checkbox : druid.base_component
---@field Events druid.checkbox.Events Component events
---@field Fields druid.checkbox.Fields Component fields
---@field Style druid.checkbox.Style Component style params.
---@field get_state fun():bool Return checkbox state
---@field init fun(node:node, callback:function, click:node) Component init function
---@field set_state fun(state:bool, is_silent:bool) Set checkbox state

---@class druid.checkbox.Events
---@field on_change_state field  On change state callback

---@class druid.checkbox.Fields
---@field button field  Button component from click_node
---@field click_node field  Button trigger node
---@field node field  Visual node

---@class druid.checkbox.Style
---@field on_change_state field  (self, node, state)

---@class druid.checkbox_group : druid.base_component
---@field Events druid.checkbox_group.Events Component events
---@field Fields druid.checkbox_group.Fields Component fields
---@field get_state fun():bool[] Return checkbox group state
---@field init fun(node:node[], callback:function, click:node[]) Component init function
---@field set_state fun(indexes:bool[]) Set checkbox group state

---@class druid.checkbox_group.Events
---@field on_checkbox_click field  On any checkbox click

---@class druid.checkbox_group.Fields
---@field checkboxes field  Array of checkbox components

---@class druid.drag : druid.base_component
---@field Events druid.drag.Events Component events
---@field Fields druid.drag.Fields Components fields
---@field Style druid.drag.Style Component style params.
---@field init fun(node:node, on_drag_callback:function) Drag component constructor
---@field set_click_zone fun(zone:node) Strict drag click area.

---@class druid.drag.Events
---@field on_drag field  (self, dx, dy) Event on drag progress
---@field on_drag_end field  (self) Event on drag end
---@field on_drag_start field  (self) Event on drag start
---@field on_touch_end field  (self) Event on touch end
---@field on_touch_start field  (self) Event on touch start

---@class druid.drag.Fields
---@field can_x field  Is drag component process vertical dragging. Default - true
---@field can_y field  Is drag component process horizontal. Default - true
---@field is_drag field  Is component now dragging
---@field is_touch field  Is component now touching
---@field touch_start_pos field  Touch start position
---@field x field  Current touch x position
---@field y field  Current touch y position

---@class druid.drag.Style
---@field DRAG_DEADZONE field  Distance in pixels to start dragging

---@class druid.dynamic_grid : druid.base_component
---@field Events druid.dynamic_grid.Events Component events
---@field Fields druid.dynamic_grid.Fields Component fields
---@field DynamicGrid:_get_side_vector fun(side:unknown, is_forward:unknown) Return side vector to correct node shifting
---@field add fun(node:node, index:number, is_shift_left:bool) Add new node to the grid
---@field clear fun():druid.dynamic_grid Clear grid nodes array.
---@field get_all_pos fun():vector3[] Return array of all node positions
---@field get_index_by_node fun(node:node):number Return grid index by node
---@field get_pos fun(index:number, node:node):vector3 Return pos for grid node index
---@field get_size fun():vector3 Return grid content size
---@field init fun(parent:node) Component init function
---@field remove fun(index:number, is_shift_left:bool) Remove the item from the grid.
---@field set_position_function fun(callback:function):druid.dynamic_grid Change set position function for grid nodes.

---@class druid.dynamic_grid.Events
---@field on_add_item field  On item add callback
---@field on_change_items field  On item add or remove callback
---@field on_clear field  On grid clear callback
---@field on_remove_item field  On item remove callback
---@field on_update_positions field  On update item positions callback

---@class druid.dynamic_grid.Fields
---@field border field  The size of item content
---@field first_index field  The first index of node in grid
---@field last_index field  The last index of node in grid
---@field node_size field  Item size
---@field nodes field  List of all grid nodes
---@field parent field  Parent gui node

---@class druid.helper
---@field centrate_icon_with_text fun(icon_node:box, text_node:text, margin:number) Center two nodes.
---@field centrate_text_with_icon fun(text_node:text, icon_node:box, margin:number) Center two nodes.
---@field deprecated fun(message:string) Show deprecated message.
---@field get_border fun(): Distance from node to size border
---@field get_pivot_offset fun(pivot:gui.pivot):vector3 Get node offset for given gui pivot
---@field is_enabled fun(node:node):bool Check if node is enabled in gui hierarchy.
---@field is_web fun() Check if device is HTML5

---@class druid.hover : druid.base_component
---@field Events druid.hover.Events Component events
---@field init fun(node:node, on_hover_callback:function) Component init function
---@field is_enabled fun():bool Return current hover enabled state
---@field set_click_zone fun(zone:node) Strict hover click area.
---@field set_enabled fun(state:bool) Set enable state of hover component.
---@field set_hover fun(state:bool) Set hover state
---@field set_mouse_hover fun(state:bool) Set mouse hover state

---@class druid.hover.Events
---@field on_hover field  On hover callback (Touch pressed)
---@field on_mouse_hover field  On mouse hover callback (Touch over without action_id)

---@class druid.input : druid.base_component
---@field Events druid.input.Events Component events
---@field Fields druid.input.Fields Component fields
---@field Style druid.input.Style Component style params.
---@field get_text fun():string Return current input field text
---@field reset_changes fun() Reset current input selection and return previous value
---@field set_allowerd_characters fun(characters:string):druid.input Set allowed charaters for input field.
---@field set_max_length fun(max_length:number):druid.input Set maximum length for input field.
---@field set_text fun(input_text:string) Set text for input field

---@class druid.input.Events
---@field on_input_empty field  (self, input_text) On input field text change to empty string callback
---@field on_input_full field  (self, input_text) On input field text change to max length string callback
---@field on_input_select field  (self, button_node) On input field select callback
---@field on_input_text field  (self, input_text) On input field text change callback
---@field on_input_unselect field  (self, button_node) On input field unselect callback
---@field on_input_wrong field  (self, params, button_instance) On trying user input with not allowed character callback

---@class druid.input.Fields
---@field allowerd_characters field  Pattern matching for user input
---@field button field  Button component
---@field is_empty field  Is current input is empty now
---@field is_selected field  Is current input selected now
---@field keyboard_type field  Gui keyboard type for input field
---@field max_length field  Max length for input text
---@field text field  Text component

---@class druid.input.Style
---@field IS_LONGTAP_ERASE field  Is long tap will erase current input data
---@field MASK_DEFAULT_CHAR field  Default character mask for password input
---@field button_style field  Custom button style for input node
---@field on_input_wrong field  (self, button_node) Callback on wrong user input
---@field on_select field  (self, button_node) Callback on input field selecting
---@field on_unselect field  (self, button_node) Callback on input field unselecting

---@class druid.lang_text : druid.base_component
---@field Events druid.lang_text.Events Component events
---@field Fields druid.lang_text.Fields Component fields
---@field init fun(node:node, locale_id:string, no_adjust:bool) Component init function
---@field set_to fun(text:string) Setup raw text to lang_text component
---@field translate fun(locale_id:string) Translate the text by locale_id

---@class druid.lang_text.Events
---@field on_change field  On change text callback

---@class druid.lang_text.Fields
---@field text field  The text component

---@class druid.progress : druid.base_component
---@field Events druid.progress.Events Component events
---@field Fields druid.progress.Fields Component fields
---@field Style druid.progress.Style Component style params.
---@field empty fun() Empty a progress bar
---@field fill fun() Fill a progress bar and stop progress animation
---@field get fun() Return current progress bar value
---@field init fun(node:string|node, key:string, init_value:number) Component init function
---@field set_steps fun(steps:number[], callback:function) Set points on progress bar to fire the callback
---@field set_to fun(to:number) Instant fill progress bar to value
---@field to fun(to:number, callback:function) Start animation of a progress bar

---@class druid.progress.Events
---@field on_change field  On progress bar change callback

---@class druid.progress.Fields
---@field key field  The progress bar direction
---@field max_size field  Maximum size of progress bar
---@field node field  Progress bar fill node
---@field scale field  Current progress bar scale
---@field size field  Current progress bar size
---@field slice field  Progress bar slice9 settings

---@class druid.progress.Style
---@field MIN_DELTA field  Minimum step to fill progress bar
---@field SPEED field  Progress bas fill rate. More -> faster

---@class druid.radio_group : druid.base_component
---@field Events druid.radio_group.Events Component events
---@field Fields druid.radio_group.Fields Component fields
---@field get_state fun():number Return radio group state
---@field init fun(node:node[], callback:function, click:node[]) Component init function
---@field set_state fun(index:number) Set radio group state

---@class druid.radio_group.Events
---@field on_radio_click field  On any checkbox click

---@class druid.radio_group.Fields
---@field checkboxes field  Array of checkbox components

---@class druid.scroll : druid.base_component
---@field Events druid.scroll.Events Component events
---@field Fields druid.scroll.Fields Component fields
---@field Style druid.scroll.Style Component style params.
---@field Scroll:_cancel_animate fun() Cancel animation on other animation or input touch
---@field bind_grid fun(Druid:druid.static_grid|druid.dynamic_grid):druid.scroll Bind the grid component (Static or Dynamic) to recalculate  scroll size on grid changes
---@field get_percent fun():vector3 Return current scroll progress status.
---@field get_scroll_size fun():vector3 Return vector of scroll size with width and height.
---@field init fun(view_node:node, content_node:node) Scroll constructor.
---@field is_inert fun():bool Return if scroll have inertion.
---@field scroll_to fun(vector3:point, is_instant:bool) Start scroll to target point.
---@field scroll_to_index fun(index:number, skip_cb:bool) Scroll to item in scroll by point index.
---@field scroll_to_percent fun(vector3:point, is_instant:bool) Start scroll to target scroll percent
---@field set_extra_stretch_size fun(stretch_size:number):druid.scroll Set extra size for scroll stretching.
---@field set_horizontal_scroll fun(state:bool):druid.scroll Lock or unlock horizontal scroll
---@field set_inert fun(state:bool):druid.scroll Enable or disable scroll inert.
---@field set_points fun(points:table):druid.scroll Set points of interest.
---@field set_size fun(size:vector3):druid.scroll Set scroll content size.
---@field set_vertical_scroll fun(state:bool):druid.scroll Lock or unlock vertical scroll

---@class druid.scroll.Events
---@field on_point_scroll field  On scroll_to_index function callback
---@field on_scroll field  On scroll move callback
---@field on_scroll_to field  On scroll_to function callback

---@class druid.scroll.Fields
---@field Current field  index of points of interests
---@field available_pos field  Available position for content node: (min_x, max_y, max_x, min_y)
---@field available_size field  Size of available positions: (width, height, 0)
---@field content_node field  Scroll content node
---@field drag field  Drag component
---@field inertion field  Current inert speed
---@field is_animate field  Flag, if scroll now animating by gui.animate
---@field is_inert field  Flag, if scroll now moving by inertion
---@field position field  Current scroll posisition
---@field target_position field  Current scroll target position
---@field view_node field  Scroll view node

---@class druid.scroll.Style
---@field ANIM_SPEED field  Scroll gui.animation speed for scroll_to function
---@field BACK_SPEED field  Scroll back returning lerp speed
---@field EXTRA_STRETCH_SIZE field  extra size in pixels outside of scroll (stretch effect)
---@field FRICT field  Multiplier for free inertion
---@field FRICT_HOLD field  Multiplier for inertion, while touching
---@field INERT_SPEED field  Multiplier for inertion speed
---@field INERT_THRESHOLD field  Scroll speed to stop inertion
---@field POINTS_DEADZONE field  Speed to check points of interests in no_inertion mode
---@field SMALL_CONTENT_SCROLL field  If true, content node with size less than view node size can be scrolled

---@class druid.slider : druid.base_component
---@field Events druid.slider.Events Component events
---@field Fields druid.slider.Fields Component fields
---@field init fun(node:node, end_pos:vector3, callback:function) Component init function
---@field set fun(value:number, is_silent:bool) Set value for slider
---@field set_steps fun(steps:number[]) Set slider steps.

---@class druid.slider.Events
---@field on_change_value field  On change value callback

---@class druid.slider.Fields
---@field dist field  Length between start and end position
---@field end_pos field  End pin node position
---@field is_drag field  Current drag state
---@field node field  Slider pin node
---@field pos field  Current pin node position
---@field start_pos field  Start pin node position
---@field target_pos field  Targer pin node position
---@field value field  Current slider value

---@class druid.static_grid : druid.base_component
---@field Events druid.static_grid.Events Component events
---@field Fields druid.static_grid.Fields Component fields
---@field add fun(item:node, index:number) Add new item to the grid
---@field clear fun():druid.static_grid Clear grid nodes array.
---@field get_all_pos fun():vector3[] Return array of all node positions
---@field get_index fun(pos:vector3):number Return index for grid pos
---@field get_index_by_node fun(node:node):number Return grid index by node
---@field get_pos fun(index:number):vector3 Return pos for grid node index
---@field get_size fun():vector3 Return grid content size
---@field init fun(parent:node, element:node, in_row:number) Component init function
---@field remove fun(index:number, is_shift_nodes:bool) Remove the item from the grid.
---@field set_anchor fun(anchor:vector3) Set grid anchor.
---@field set_position_function fun(callback:function):druid.static_grid Change set position function for grid nodes.

---@class druid.static_grid.Events
---@field on_add_item field  On item add callback
---@field on_change_items field  On item add or remove callback
---@field on_clear field  On grid clear callback
---@field on_remove_item field  On item remove callback
---@field on_update_positions field  On update item positions callback

---@class druid.static_grid.Fields
---@field anchor field  Item anchor
---@field border field  The size of item content
---@field first_index field  The first index of node in grid
---@field last_index field  The last index of node in grid
---@field node_size field  Item size
---@field nodes field  List of all grid nodes
---@field parent field  Parent gui node

---@class druid.swipe : druid.base_component
---@field Events druid.swipe.Events Component events
---@field Fields druid.swipe.Fields Components fields
---@field Style druid.swipe.Style Component style params.
---@field init fun(node:node, on_swipe_callback:function) Component init function
---@field set_click_zone fun(zone:node) Strict swipe click area.

---@class druid.swipe.Events
---@field on_swipe field  Trigger on swipe event

---@class druid.swipe.Fields
---@field click_zone field  Restriction zone
---@field node field  Swipe node

---@class druid.swipe.Style
---@field SWIPE_THRESHOLD field  Minimum distance for swipe trigger
---@field SWIPE_TIME field  Maximum time for swipe trigger
---@field SWIPE_TRIGGER_ON_MOVE field  If true, trigger on swipe moving, not only release action

---@class druid.text : druid.base_component
---@field Events druid.text.Events Component events
---@field Fields druid.text.Fields Component fields
---@field get_text_width fun(text:string) Calculate text width with font with respect to trailing space
---@field init fun(node:node, value:string, no_adjust:bool) Component init function
---@field is_multiline fun():bool Return true, if text with line break
---@field set_alpha fun(alpha:number) Set alpha
---@field set_color fun(color:vector4) Set color
---@field set_pivot fun(pivot:gui.pivot) Set text pivot.
---@field set_scale fun(scale:vector3) Set scale
---@field set_to fun(set_to:string) Set text to text field

---@class druid.text.Events
---@field on_set_pivot field  On change pivot callback
---@field on_set_text field  On set text callback
---@field on_update_text_scale field  On adjust text size callback

---@class druid.text.Fields
---@field color field  Current text color
---@field is_no_adjust field  Current text size adjust settings
---@field node field  Text node
---@field pos field  Current text position
---@field scale field  Current text node scale
---@field start_scale field  Initial text node scale
---@field start_size field  Initial text node size
---@field text_area field  Current text node available are

---@class druid.timer : druid.base_component
---@field Events druid.timer.Events Component events
---@field Fields druid.timer.Fields Component fields
---@field init fun(node:node, seconds_from:number, seconds_to:number, callback:function) Component init function
---@field set_interval fun(from:number, to:number) Set time interval
---@field set_state fun(is_on:bool) Called when update
---@field set_to fun(set_to:number) Set text to text field

---@class druid.timer.Events
---@field on_set_enabled field  On timer change enabled state callback
---@field on_tick field  On timer tick callback. Fire every second
---@field on_timer_end field  On timer end callback

---@class druid.timer.Fields
---@field from field  Initial timer value
---@field node field  Trigger node
---@field target field  Target timer value
---@field value field  Current timer value

---@class druid_event
---@field Event fun(initial_callback:function) Event constructur
---@field event:clear fun() Clear the all event handlers
---@field event:is_exist fun():bool Return true, if event have at lease one handler
---@field event:subscribe fun(callback:function) Subscribe callback on event
---@field event:trigger fun(...:unknown) Trigger the event and call all subscribed callbacks
---@field event:unsubscribe fun(callback:function) Unsubscribe callback on event

---@class druid_instance
---@field druid:create fun(component:Component, ...:args) Create new druid component
---@field druid:final fun() Call on final function on gui_script.
---@field druid:initialize fun(table:context, table:style) Druid class constructor
---@field druid:new_back_handler fun(...:args):Component Create back_handler basic component
---@field druid:new_blocker fun(...:args):Component Create blocker basic component
---@field druid:new_button fun(...:args):Component Create button basic component
---@field druid:new_checkbox fun(...:args):Component Create checkbox component
---@field druid:new_checkbox_group fun(...:args):Component Create checkbox_group component
---@field druid:new_drag fun(...:args):Componetn Create drag basic component
---@field druid:new_dynamic_grid fun(...:args):Component Create dynamic grid component
---@field druid:new_grid fun(...:args):Component Create grid basic component  Deprecated
---@field druid:new_hover fun(...:args):Component Create hover basic component
---@field druid:new_input fun(...:args):Component Create input component
---@field druid:new_lang_text fun(...:args):Component Create lang_text component
---@field druid:new_progress fun(...:args):Component Create progress component
---@field druid:new_radio_group fun(...:args):Component Create radio_group component
---@field druid:new_scroll fun(...:args):Component Create scroll basic component
---@field druid:new_slider fun(...:args):Component Create slider component
---@field druid:new_static_grid fun(...:args):Component Create static grid basic component
---@field druid:new_swipe fun(...:args):Component Create swipe basic component
---@field druid:new_text fun(...:args):Component Create text basic component
---@field druid:new_timer fun(...:args):Component Create timer component
---@field druid:on_focus_gained fun() Druid on focus gained interest function.
---@field druid:on_focus_lost fun() Druid on focus lost interest function.
---@field druid:on_input fun(action_id:hash, action:table) Druid on_input function
---@field druid:on_layout_change fun() Druid on layout change function.
---@field druid:on_message fun(message_id:hash, message:table, sender:hash) Druid on_message function
---@field druid:remove fun(component:Component) Remove component from druid instance.
---@field druid:update fun(dt:number) Druid update function

---@class helper
---@field is_mobile fun() Check if device is mobile (Android or iOS)


