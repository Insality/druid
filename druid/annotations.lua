-- luacheck: ignore


---@class druid
local druid = {}

--- Create a new Druid instance for creating GUI components.
---@param context table The Druid context. Usually, this is the self of the gui_script. It is passed into all Druid callbacks.
---@param style? table The Druid style table to override style parameters for this Druid instance.
---@return druid_instance The Druid instance @{DruidInstance}.
function druid.new(context, style) end

--- Call this function when the game language changes.
--- This function will translate all current LangText components.
function druid.on_language_change() end

--- Set the window callback to enable on_focus_gain and on_focus_lost functions.
--- This is used to trigger the on_focus_lost and on_focus_gain functions in Druid components.
---@param event string Event param from window listener
function druid.on_window_callback(event) end

--- Register a new external Druid component.
--- You can register your own components to make new alias: the druid:new_{name} function.  For example, if you want to register a component called "my_component", you can create it using druid:new_my_component(...).  This can be useful if you have your own "basic" components that you don't want to re-create each time.
---@param name string module name
---@param module table lua table with component
function druid.register(name, module) end

--- Set your own default style for all Druid instances.
--- To create your own style file, copy the default style file and make changes to it.  Register the new style before creating your Druid instances.
---@param style table Druid style module
function druid.set_default_style(style) end

--- Set the Druid sound function to play UI sounds if used.
--- Set a function to play a sound given a sound_id. This function is used for button clicks to play the "click" sound.  It can also be used to play sounds in your custom components (see the default Druid style file for an example).
---@param callback function Sound play callback
function druid.set_sound_function(callback) end

--- Set the text function for the LangText component.
--- The Druid locale component will call this function to get translated text.  After setting the text function, all existing locale components will be updated.
---@param callback function Get localized text function
function druid.set_text_function(callback) end


---@class druid.back_handler : druid.base_component
---@field on_back druid.event The @{DruidEvent} Event on back handler action.
---@field params any Custom args to pass in the callback
local druid__back_handler = {}


---@class druid.base_component
local druid__base_component = {}

--- Return all children components, recursive
---@param self druid.base_component @{BaseComponent}
---@return table Array of childrens if the Druid component instance
function druid__base_component.component:get_childrens(self) end

--- Context used as first arg in all Druid events
--- Context is usually self of gui_script.
---@param self druid.base_component @{BaseComponent}
---@return table BaseComponent context
function druid__base_component.component:get_context(self) end

--- Get Druid instance for inner component creation.
---@param self druid.base_component @{BaseComponent}
---@return Druid Druid instance with component context
function druid__base_component.component:get_druid(self) end

--- Return component input priority
---@param self druid.base_component @{BaseComponent}
---@return number The component input priority
function druid__base_component.component:get_input_priority(self) end

--- Return component name
---@param self druid.base_component @{BaseComponent}
---@return string The component name
function druid__base_component.component:get_name(self) end

--- Get component node by name.
--- If component has nodes, node_or_name should be string  It autopick node by template name or from nodes by gui.clone_tree  if they was setup via component:set_nodes, component:set_template.  If node is not found, the exception will fired
---@param self druid.base_component @{BaseComponent}
---@param node_or_name string|node Node name or node itself
---@return node Gui node
function druid__base_component.component:get_node(self, node_or_name) end

--- Return the parent component if exist
---@param self druid.base_component @{BaseComponent}
---@return BaseComponent|nil The druid component instance or nil
function druid__base_component.component:get_parent_component(self) end

--- Return parent component name
---@param self druid.base_component @{BaseComponent}
---@return string|nil The parent component name if exist or bil
function druid__base_component.component:get_parent_name(self) end

--- Get current component template name.
---@param self druid.base_component @{BaseComponent}
---@return string Component full template name
function druid__base_component.component:get_template(self) end

--- Return component UID.
--- UID generated in component creation order.
---@param self druid.base_component @{BaseComponent}
---@return number The component uid
function druid__base_component.component:get_uid(self) end

--- Reset component input priority to default value
---@param self druid.base_component @{BaseComponent}
---@return number The component input priority
function druid__base_component.component:reset_input_priority(self) end

--- Set component input state.
--- By default it enabled  If input is disabled, the component will not receive input events
---@param self druid.base_component @{BaseComponent}
---@param state bool The component input state
---@return druid.base_component BaseComponent itself
function druid__base_component.component:set_input_enabled(self, state) end

--- Set component input priority
--- Default value: 10
---@param self druid.base_component @{BaseComponent}
---@param value number The new input priority value
---@param is_temporary boolean If true, the reset input priority will return to previous value
---@return number The component input priority
function druid__base_component.component:set_input_priority(self, value, is_temporary) end

--- Set current component nodes.
--- Use if your component nodes was cloned with `gui.clone_tree` and you got the node tree.
---@param self druid.base_component @{BaseComponent}
---@param nodes table BaseComponent nodes table
---@return druid.base_component @{BaseComponent}
function druid__base_component.component:set_nodes(self, nodes) end

--- Set current component style table.
--- Invoke `on_style_change` on component, if exist. Component should handle  their style changing and store all style params
---@param self druid.base_component @{BaseComponent}
---@param druid_style table Druid style module
---@return druid.base_component @{BaseComponent}
function druid__base_component.component:set_style(self, druid_style) end

--- Set component template name.
--- Use on all your custom components with GUI layouts used as templates.  It will check parent template name to build full template name in self:get_node()
---@param self druid.base_component @{BaseComponent}
---@param template string BaseComponent template name
---@return druid.base_component @{BaseComponent}
function druid__base_component.component:set_template(self, template) end


---@class druid.blocker : druid.base_component
---@field node node Blocker node
local druid__blocker = {}

--- @{Blocker} constructor
---@param self druid.blocker @{Blocker}
---@param node node Gui node
function druid__blocker.init(self, node) end

--- Return blocker enabled state
---@param self druid.blocker @{Blocker}
---@return bool True, if blocker is enabled
function druid__blocker.is_enabled(self) end

--- Set enabled blocker component state.
--- Don't change node enabled state itself.
---@param self druid.blocker @{Blocker}
---@param state bool Enabled state
function druid__blocker.set_enabled(self, state) end


---@class druid.button : druid.base_component
---@field anim_node node Button animation node.
---@field click_zone node Additional button click area, defined by another GUI Node
---@field hover druid.hover The @{Hover}: Button Hover component
---@field node node Button trigger node
---@field node_id hash The GUI node id from button node
---@field on_click druid.event The @{DruidEvent}: Event on successful release action over button.
---@field on_click_outside druid.event The @{DruidEvent}: Event calls if click event was outside of button.
---@field on_double_click druid.event The @{DruidEvent}: Event on double tap action over button.
---@field on_hold_callback druid.event The @{DruidEvent}: Event calls every frame before on_long_click event.
---@field on_long_click druid.event The @{DruidEvent}: Event on long tap action over button.
---@field on_pressed druid.event The @{DruidEvent}: Event triggered if button was pressed by user.
---@field on_repeated_click druid.event The @{DruidEvent}: Event on repeated action over button.
---@field params any Custom args for any Button event.
---@field style druid.button.style Component style params.
local druid__button = {}

--- Get current key name to trigger this button.
---@param self druid.button
---@return hash The action_id of the input key
function druid__button.get_key_trigger(self) end

--- The @{Button} constructor
---@param self druid.button @{Button}
---@param node string|node Node name or GUI Node itself
---@param callback function On click button callback
---@param custom_args any Button events custom arguments
---@param anim_node string|node Node to animate instead of trigger node.
function druid__button.init(self, node, callback, custom_args, anim_node) end

--- Get button enabled state.
--- By default all Buttons is enabled on creating.
---@param self druid.button @{Button}
---@return bool True, if button is enabled now, False overwise
function druid__button.is_enabled(self) end

--- Set function for additional check for button click availability
---@param self druid.button
---@param check_function function Should return true or false. If true - button can be pressed.
---@param failure_callback function Function will be called on button click, if check function return false
---@return druid.button Current button instance
function druid__button.set_check_function(self, check_function, failure_callback) end

--- Set additional button click area.
--- Useful to restrict click outside out stencil node or scrollable content.  This functions calls automatically if you don't disable it in game.project: druid.no_stencil_check
---@param self druid.button @{Button}
---@param zone node Gui node
---@return druid.button Current button instance
function druid__button.set_click_zone(self, zone) end

--- Set button enabled state.
--- The style.on_set_enabled will be triggered.  Disabled button is not clickable.
---@param self druid.button @{Button}
---@param state bool Enabled state
---@return druid.button Current button instance
function druid__button.set_enabled(self, state) end

--- Set key name to trigger this button by keyboard.
---@param self druid.button @{Button}
---@param key hash The action_id of the input key
---@return druid.button Current button instance
function druid__button.set_key_trigger(self, key) end

--- Set Button mode to work inside user HTML5 interaction event.
--- It's required to make protected things like copy & paste text, show mobile keyboard, etc  The HTML5 button's doesn't call any events except on_click event.  If the game is not HTML, html mode will be not enabled
---@param self druid.button
---@param is_web_mode boolean If true - button will be called inside html5 callback
---@return druid.button Current button instance
function druid__button.set_web_user_interaction(self, is_web_mode) end


---@class druid.button.style
---@field AUTOHOLD_TRIGGER field  Maximum hold time to trigger button release while holding
---@field DOUBLETAP_TIME field  Time between double taps
---@field LONGTAP_TIME field  Minimum time to trigger on_hold_callback
---@field on_click field  (self, node)
---@field on_click_disabled field  (self, node)
---@field on_hover field  (self, node, hover_state)
---@field on_mouse_hover field  (self, node, hover_state)
---@field on_set_enabled field  (self, node, enabled_state)
local druid__button__style = {}


---@class druid.checkbox : druid.base_component
---@field button druid.button Button component from click_node
---@field click_node node Button trigger node
---@field node node Visual node
---@field on_change_state druid.event On change state callback(self, state)
---@field style druid.checkbox.style Component style params.
local druid__checkbox = {}

--- Return checkbox state
---@param self druid.checkbox @{Checkbox}
---@return bool Checkbox state
function druid__checkbox.get_state(self) end

--- Component init function
---@param self druid.checkbox @{Checkbox}
---@param node node Gui node
---@param callback function Checkbox callback
---@param click_node node Trigger node, by default equals to node
---@param initial_state boolean The initial state of checkbox, default - false
function druid__checkbox.init(self, node, callback, click_node, initial_state) end

--- Set checkbox state
---@param self druid.checkbox @{Checkbox}
---@param state bool Checkbox state
---@param is_silent bool Don't trigger on_change_state if true
---@param is_instant bool If instant checkbox change
function druid__checkbox.set_state(self, state, is_silent, is_instant) end


---@class druid.checkbox.style
---@field on_change_state field  (self, node, state)
local druid__checkbox__style = {}


---@class druid.checkbox_group : druid.base_component
---@field checkboxes table Array of checkbox components
---@field on_checkbox_click druid.event On any checkbox click callback(self, index)
local druid__checkbox_group = {}

--- Return checkbox group state
---@param self druid.checkbox_group @{CheckboxGroup}
---@return bool[] Array if checkboxes state
function druid__checkbox_group.get_state(self) end

--- Component init function
---@param self druid.checkbox_group @{CheckboxGroup}
---@param nodes node[] Array of gui node
---@param callback function Checkbox callback
---@param click_nodes node[] Array of trigger nodes, by default equals to nodes
function druid__checkbox_group.init(self, nodes, callback, click_nodes) end

--- Set checkbox group state
---@param self druid.checkbox_group @{CheckboxGroup}
---@param indexes bool[] Array of checkbox state
---@param is_instant boolean If instant state change
function druid__checkbox_group.set_state(self, indexes, is_instant) end

---@alias Grid druid.static_grid|druid.dynamic_grid

---@class druid.data_list : druid.base_component
---@field grid druid.static_grid|druid.dynamic_grid The Druid Grid component
---@field last_index number The current visual last data index
---@field on_element_add druid.event On DataList visual element created Event callback(self, index, node, instance)
---@field on_element_remove druid.event On DataList visual element created Event callback(self, index)
---@field on_scroll_progress_change druid.event Event triggered when scroll progress is changed; event(self, progress_value)
---@field scroll druid.scroll The Druid scroll component
---@field scroll_progress number The current progress of scroll posititon
---@field top_index number The current visual top data index
local druid__data_list = {}

--- Clear the DataList and refresh visuals
---@param self druid.data_list @{DataList}
function druid__data_list.clear(self) end

--- Return all currenly created components in DataList
---@param self druid.data_list @{DataList}
---@return druid.base_component[] List of created nodes
function druid__data_list.get_created_components(self) end

--- Return all currenly created nodes in DataList
---@param self druid.data_list @{DataList}
---@return node[] List of created nodes
function druid__data_list.get_created_nodes(self) end

--- Return current data from DataList component
---@param self druid.data_list @{DataList}
---@return table The current data array
function druid__data_list.get_data(self) end

--- Return first index from data.
--- It not always equals to 1
---@param self druid.data_list @{DataList}
function druid__data_list.get_first_index(self) end

--- Return index for data value
---@param self druid.data_list @{DataList}
---@param data table
function druid__data_list.get_index(self, data) end

--- Return last index from data
---@param self druid.data_list @{DataList}
function druid__data_list.get_last_index(self) end

--- Return amount of data
---@param self druid.data_list @{DataList}
function druid__data_list.get_length(self) end

--- Data list constructor
---@param self druid.data_list @{DataList}
---@param scroll druid.scroll The @{Scroll} instance for Data List component
---@param grid druid.static_grid|druid.dynamic_grid The @{StaticGrid} or @{DynamicGrid} instance for Data List component
---@param create_function function The create function callback(self, data, index, data_list). Function should return (node, [component])
function druid__data_list.init(self, scroll, grid, create_function) end

--- Druid System on_remove function
---@param self druid.data_list @{DataList}
function druid__data_list.on_remove(self) end

--- Instant scroll to element with passed index
---@param self druid.data_list @{DataList}
---@param index number
function druid__data_list.scroll_to_index(self, index) end

--- Set new data set for DataList component
---@param self druid.data_list @{DataList}
---@param data table The new data array
---@return druid.data_list Current DataList instance
function druid__data_list.set_data(self, data) end


---@class druid.drag : druid.base_component
---@field can_x bool Is drag component process vertical dragging.
---@field can_y bool Is drag component process horizontal.
---@field is_drag bool Is component now dragging
---@field is_touch bool Is component now touching
---@field on_drag druid.event on drag progress callback(self, dx, dy, total_x, total_y)
---@field on_drag_end druid.event Event on drag end callback(self, total_x, total_y)
---@field on_drag_start druid.event Event on drag start callback(self)
---@field on_touch_end druid.event Event on touch end callback(self)
---@field on_touch_start druid.event Event on touch start callback(self)
---@field style druid.drag.style Component style params.
---@field touch_start_pos vector3 Touch start position
---@field x number Current touch x position
---@field y number Current touch y position
local druid__drag = {}

--- Drag component constructor
---@param self druid.drag @{Drag}
---@param node node GUI node to detect dragging
---@param on_drag_callback function Callback for on_drag_event(self, dx, dy)
function druid__drag.init(self, node, on_drag_callback) end

--- Check if Drag component is enabled
---@param self druid.drag @{Drag}
---@return bool
function druid__drag.is_enabled(self) end

--- Strict drag click area.
--- Useful for  restrict events outside stencil node
---@param self druid.drag @{Drag}
---@param node node Gui node
function druid__drag.set_click_zone(self, node) end

--- Set Drag input enabled or disabled
---@param self druid.drag @{Drag}
---@param is_enabled bool
function druid__drag.set_enabled(self, is_enabled) end


---@class druid.drag.style
---@field DRAG_DEADZONE field  Distance in pixels to start dragging
---@field NO_USE_SCREEN_KOEF field  If screen aspect ratio affects on drag values
local druid__drag__style = {}


---@class druid.dynamic_grid : druid.base_component
---@field border vector4 The size of item content
---@field first_index number The first index of node in grid
---@field last_index number The last index of node in grid
---@field node_size vector3 Item size
---@field nodes node[] List of all grid elements.
---@field on_add_item druid.event On item add callback(self, node, index)
---@field on_change_items druid.event On item add or remove callback(self, index)
---@field on_clear druid.event On grid clear callback(self)
---@field on_remove_item druid.event On item remove callback(self, index)
---@field on_update_positions druid.event On update item positions callback(self)
---@field parent node Parent gui node
local druid__dynamic_grid = {}

--- Return side vector to correct node shifting
---@param self unknown
---@param side unknown
---@param is_forward unknown
function druid__dynamic_grid._get_side_vector(self, side, is_forward) end

--- Add new node to the grid
---@param self druid.dynamic_grid @{DynamicGrid}
---@param node node Gui node
---@param index? number The node position. By default add as last node
---@param shift_policy? number How shift nodes, if required. See const.SHIFT
---@param is_instant? boolean If true, update node positions instantly
function druid__dynamic_grid.add(self, node, index, shift_policy, is_instant) end

--- Clear grid nodes array.
--- GUI nodes will be not deleted!  If you want to delete GUI nodes, use dynamic_grid.nodes array before grid:clear
---@param self druid.dynamic_grid @{DynamicGrid}
---@return druid.dynamic_grid Current grid instance
function druid__dynamic_grid.clear(self) end

--- Return array of all node positions
---@param self druid.dynamic_grid @{DynamicGrid}
---@return vector3[] All grid node positions
function druid__dynamic_grid.get_all_pos(self) end

--- Return grid content borders
---@param self druid.dynamic_grid @{DynamicGrid}
---@return vector3 The grid content borders
function druid__dynamic_grid.get_borders(self) end

--- Return grid index by node
---@param self druid.dynamic_grid @{DynamicGrid}
---@param node node The gui node in the grid
---@return number The node index
function druid__dynamic_grid.get_index_by_node(self, node) end

--- Return DynamicGrid offset, where DynamicGrid content starts.
---@param self druid.dynamic_grid @{DynamicGrid} The DynamicGrid instance
---@return vector3 The DynamicGrid offset
function druid__dynamic_grid.get_offset(self) end

--- Return pos for grid node index
---@param self druid.dynamic_grid @{DynamicGrid}
---@param index number The grid element index
---@param node node The node to be placed
---@param origin_index? number Index of nearby node
---@return vector3 Node position
function druid__dynamic_grid.get_pos(self, index, node, origin_index) end

--- Return grid content size
---@param self druid.dynamic_grid @{DynamicGrid}
---@param border vector3
---@return vector3 The grid content size
function druid__dynamic_grid.get_size(self, border) end

--- Component init function
---@param self druid.dynamic_grid @{DynamicGrid}
---@param parent node The gui node parent, where items will be placed
function druid__dynamic_grid.init(self, parent) end

--- Remove the item from the grid.
--- Note that gui node will be not deleted
---@param self druid.dynamic_grid @{DynamicGrid}
---@param index number The grid node index to remove
---@param shift_policy? number How shift nodes, if required. See const.SHIFT
---@param is_instant? boolean If true, update node positions instantly
---@return node The deleted gui node from grid
function druid__dynamic_grid.remove(self, index, shift_policy, is_instant) end

--- Change set position function for grid nodes.
--- It will call on  update poses on grid elements. Default: gui.set_position
---@param self druid.dynamic_grid @{DynamicGrid}
---@param callback function Function on node set position
---@return druid.dynamic_grid Current grid instance
function druid__dynamic_grid.set_position_function(self, callback) end


---@class druid.event
local druid__event = {}

--- Clear the all event handlers
---@param self druid.event @{DruidEvent}
function druid__event.clear(self) end

--- DruidEvent constructor
---@param self druid.event @{DruidEvent}
---@param initial_callback function Subscribe the callback on new event, if callback exist
function druid__event.initialize(self, initial_callback) end

--- Return true, if event have at lease one handler
---@param self druid.event @{DruidEvent}
---@return bool True if event have handlers
function druid__event.is_exist(self) end

--- Subscribe callback on event
---@param self druid.event @{DruidEvent}
---@param callback function Callback itself
---@param context any Additional context as first param to callback call, usually it's self
function druid__event.subscribe(self, callback, context) end

--- Trigger the event and call all subscribed callbacks
---@param self druid.event @{DruidEvent}
---@param ... any All event params
function druid__event.trigger(self, ...) end

--- Unsubscribe callback on event
---@param self druid.event @{DruidEvent}
---@param callback function Callback itself
---@param context any Additional context as first param to callback call
function druid__event.unsubscribe(self, callback, context) end


---@class druid.hotkey : druid.base_component
---@field button druid.button Button component from click_node
---@field click_node node Button trigger node
---@field node node Visual node
---@field on_change_state druid.event On change state callback(self, state)
---@field style druid.hotkey.style Component style params.
local druid__hotkey = {}

--- Add hotkey for component callback
---@param self druid.hotkey @{Hotkey}
---@param keys string[]|hash[]|string|hash that have to be pressed before key pressed to activate
---@param callback_argument value The argument to pass into the callback function
function druid__hotkey.add_hotkey(self, keys, callback_argument) end

--- Component init function
---@param self druid.hotkey @{Hotkey}
---@param keys string[]|string The keys to be pressed for trigger callback. Should contains one key and any modificator keys
---@param callback function The callback function
---@param callback_argument value The argument to pass into the callback function
function druid__hotkey.init(self, keys, callback, callback_argument) end


---@class druid.hotkey.style
---@field MODIFICATORS field  The list of action_id as hotkey modificators
local druid__hotkey__style = {}


---@class druid.hover : druid.base_component
---@field on_hover druid.event On hover callback(self, state, hover_instance)
---@field on_mouse_hover druid.event On mouse hover callback(self, state, hover_instance)
local druid__hover = {}

--- Component init function
---@param self druid.hover @{Hover}
---@param node node Gui node
---@param on_hover_callback function Hover callback
function druid__hover.init(self, node, on_hover_callback) end

--- Return current hover enabled state
---@param self druid.hover @{Hover}
---@return bool The hover enabled state
function druid__hover.is_enabled(self) end

--- Return current hover state.
--- True if touch action was on the node at current time
---@param self druid.hover @{Hover}
---@return bool The current hovered state
function druid__hover.is_hovered(self) end

--- Return current hover state.
--- True if nil action_id (usually desktop mouse) was on the node at current time
---@param self druid.hover @{Hover}
---@return bool The current hovered state
function druid__hover.is_mouse_hovered(self) end

--- Strict hover click area.
--- Useful for  no click events outside stencil node
---@param self druid.hover @{Hover}
---@param zone node Gui node
function druid__hover.set_click_zone(self, zone) end

--- Set enable state of hover component.
--- If hover is not enabled, it will not generate  any hover events
---@param self druid.hover @{Hover}
---@param state bool The hover enabled state
function druid__hover.set_enabled(self, state) end

--- Set hover state
---@param self druid.hover @{Hover}
---@param state bool The hover state
function druid__hover.set_hover(self, state) end

--- Set mouse hover state
---@param self druid.hover @{Hover}
---@param state bool The mouse hover state
function druid__hover.set_mouse_hover(self, state) end


---@class druid.input : druid.base_component
---@field allowerd_characters string Pattern matching for user input
---@field button druid.button Button component
---@field is_empty bool Is current input is empty now
---@field is_selected bool Is current input selected now
---@field keyboard_type number Gui keyboard type for input field
---@field max_length number Max length for input text
---@field on_input_empty druid.event On input field text change to empty string callback(self, input_text)
---@field on_input_full druid.event On input field text change to max length string callback(self, input_text)
---@field on_input_select druid.event On input field select callback(self, button_node)
---@field on_input_text druid.event On input field text change callback(self, input_text)
---@field on_input_unselect druid.event On input field unselect callback(self, input_text)
---@field on_input_wrong druid.event On trying user input with not allowed character callback(self, params, button_instance)
---@field style druid.input.style Component style params.
---@field text druid.text Text component
local druid__input = {}

--- Return current input field text
---@param self druid.input @{Input}
---@return string The current input field text
function druid__input.get_text(self) end

--- Component init function
---@param self druid.input @{Input}
---@param click_node node Node to enabled input component
---@param text_node node|druid.text Text node what will be changed on user input. You can pass text component instead of text node name @{Text}
---@param keyboard_type number Gui keyboard type for input field
function druid__input.init(self, click_node, text_node, keyboard_type) end

--- Reset current input selection and return previous value
---@param self druid.input @{Input}
function druid__input.reset_changes(self) end

--- Select input field.
--- It will show the keyboard and trigger on_select events
---@param self druid.input @{Input}
function druid__input.select(self) end

--- Set allowed charaters for input field.
--- See: https://defold.com/ref/stable/string/  ex: [%a%d] for alpha and numeric
---@param self druid.input @{Input}
---@param characters string Regulax exp. for validate user input
---@return druid.input Current input instance
function druid__input.set_allowed_characters(self, characters) end

--- Set maximum length for input field.
--- Pass nil to make input field unliminted (by default)
---@param self druid.input @{Input}
---@param max_length number Maximum length for input text field
---@return druid.input Current input instance
function druid__input.set_max_length(self, max_length) end

--- Set text for input field
---@param self druid.input @{Input}
---@param input_text string The string to apply for input field
function druid__input.set_text(self, input_text) end

--- Remove selection from input.
--- It will hide the keyboard and trigger on_unselect events
---@param self druid.input @{Input}
function druid__input.unselect(self) end


---@class druid.input.style
---@field IS_LONGTAP_ERASE field  Is long tap will erase current input data
---@field IS_UNSELECT_ON_RESELECT field  If true, call unselect on select selected input
---@field MASK_DEFAULT_CHAR field  Default character mask for password input
---@field NO_CONSUME_INPUT_WHILE_SELECTED field  If true, will not consume input while input is selected. It's allow to interact with other components while input is selected (text input still captured)
---@field button_style field  Custom button style for input node
---@field on_input_wrong field  (self, button_node) Callback on wrong user input
---@field on_select field  (self, button_node) Callback on input field selecting
---@field on_unselect field  (self, button_node) Callback on input field unselecting
local druid__input__style = {}


---@class druid.lang_text : druid.base_component
---@field on_change druid.event On change text callback
---@field text druid.text The text component
local druid__lang_text = {}

--- Format string with new text params on localized text
---@param self druid.lang_text @{LangText}
---@param a string Optional param to string.format
---@param b string Optional param to string.format
---@param c string Optional param to string.format
---@param d string Optional param to string.format
---@param e string Optional param to string.format
---@param f string Optional param to string.format
---@param g string Optional param to string.format
---@return druid.lang_text Current instance
function druid__lang_text.format(self, a, b, c, d, e, f, g) end

--- The @{LangText} constructor
---@param self druid.lang_text @{LangText}
---@param node string|node Node name or GUI Text Node itself
---@param locale_id string Default locale id or text from node as default
---@param adjust_type string Adjust type for text. By default is DOWNSCALE. Look const.TEXT_ADJUST for reference
function druid__lang_text.init(self, node, locale_id, adjust_type) end

--- Setup raw text to lang_text component
---@param self druid.lang_text @{LangText}
---@param text string Text for text node
---@return druid.lang_text Current instance
function druid__lang_text.set_to(self, text) end

--- Translate the text by locale_id
---@param self druid.lang_text @{LangText}
---@param locale_id string Locale id
---@param a string Optional param to string.format
---@param b string Optional param to string.format
---@param c string Optional param to string.format
---@param d string Optional param to string.format
---@param e string Optional param to string.format
---@param f string Optional param to string.format
---@param g string Optional param to string.format
---@return druid.lang_text Current instance
function druid__lang_text.translate(self, locale_id, a, b, c, d, e, f, g) end


---@class druid.layout : druid.base_component
---@field mode string Current layout mode
---@field node node Layout node
---@field on_size_changed druid.event On window resize callback(self, new_size)
local druid__layout = {}

--- Set node for layout node to fit inside it.
--- Pass nil to reset
---@param self druid.layout @{Layout}
---@param node node
---@return druid.layout @{Layout}
function druid__layout.fit_into_node(self, node) end

--- Set size for layout node to fit inside it
---@param self druid.layout @{Layout}
---@param target_size vector3
---@return druid.layout @{Layout}
function druid__layout.fit_into_size(self, target_size) end

--- Set current size for layout node to fit inside it
---@param self druid.layout @{Layout}
---@return druid.layout @{Layout}
function druid__layout.fit_into_window(self) end

--- Component init function
---@param self druid.layout @{Layout}
---@param node node Gui node
---@param mode string The layout mode (from const.LAYOUT_MODE)
---@param on_size_changed_callback function The callback on window resize
function druid__layout.init(self, node, mode, on_size_changed_callback) end

--- Set max gui upscale for FIT adjust mode (or side).
--- It happens on bigger render gui screen
---@param self druid.layout @{Layout}
---@param max_gui_upscale number
---@return druid.layout @{Layout}
function druid__layout.set_max_gui_upscale(self, max_gui_upscale) end

--- Set maximum size of layout node
---@param self druid.layout @{Layout}
---@param max_size vector3
---@return druid.layout @{Layout}
function druid__layout.set_max_size(self, max_size) end

--- Set minimal size of layout node
---@param self druid.layout @{Layout}
---@param min_size vector3
---@return druid.layout @{Layout}
function druid__layout.set_min_size(self, min_size) end

--- Set new origin position of layout node.
--- You should apply this on node movement
---@param self druid.layout @{Layout}
---@param new_origin_position vector3
---@return druid.layout @{Layout}
function druid__layout.set_origin_position(self, new_origin_position) end

--- Set new origin size of layout node.
--- You should apply this on node manual size change
---@param self druid.layout @{Layout}
---@param new_origin_size vector3
---@return druid.layout @{Layout}
function druid__layout.set_origin_size(self, new_origin_size) end


---@class druid.pin_knob : druid.base_component
---@field druid druid_instance The component druid instance
---@field is_drag bool Is currently under user control
---@field node node The pin node
local druid__pin_knob = {}

--- Component init function
---@param self druid.pin_knob @{PinKnob}
---@param callback function Callback(self, value) on value changed
---@param template string The template string name
---@param nodes table Nodes table from gui.clone_tree
function druid__pin_knob.init(self, callback, template, nodes) end

--- Set current and min/max angles for component
---@param self druid.pin_knob @{PinKnob}
---@param cur_value number The new value for pin knob
---@param min number The minimum value for pin knob
---@param max number The maximum value for pin knob
---@return druid.pin_knob @{PinKnob}
function druid__pin_knob.set_angle(self, cur_value, min, max) end

--- Set current and min/max angles for component
---@param self druid.pin_knob @{PinKnob}
---@param value number The spin speed multiplier
---@return druid.pin_knob @{PinKnob}
function druid__pin_knob.set_friction(self, value) end


---@class druid.progress : druid.base_component
---@field key string The progress bar direction.
---@field max_size number Maximum size of progress bar
---@field node node Progress bar fill node
---@field on_change druid.event On progress bar change callback(self, new_value)
---@field scale vector3 Current progress bar scale
---@field size vector3 Current progress bar size
---@field slice vector4 Progress bar slice9 settings
---@field style druid.progress.style Component style params.
local druid__progress = {}

--- Empty a progress bar
---@param self druid.progress @{Progress}
function druid__progress.empty(self) end

--- Fill a progress bar and stop progress animation
---@param self druid.progress @{Progress}
function druid__progress.fill(self) end

--- Return current progress bar value
---@param self druid.progress @{Progress}
function druid__progress.get(self) end

--- @{Progress} constructor
---@param self druid.progress @{Progress}
---@param node string|node Node name or GUI Node itself.
---@param key string Progress bar direction: const.SIDE.X or const.SIDE.Y
---@param init_value number Initial value of progress bar
function druid__progress.init(self, node, key, init_value) end

--- Set progress bar max node size
---@param self druid.progress @{Progress}
---@param max_size vector3 The new node maximum (full) size
---@return druid.progress @{Progress}
function druid__progress.set_max_size(self, max_size) end

--- Set points on progress bar to fire the callback
---@param self druid.progress @{Progress}
---@param steps number[] Array of progress bar values
---@param callback function Callback on intersect step value
function druid__progress.set_steps(self, steps, callback) end

--- Instant fill progress bar to value
---@param self druid.progress @{Progress}
---@param to number Progress bar value, from 0 to 1
function druid__progress.set_to(self, to) end

--- Start animation of a progress bar
---@param self druid.progress @{Progress}
---@param to number value between 0..1
---@param callback function Callback on animation ends
function druid__progress.to(self, to, callback) end


---@class druid.progress.style
---@field MIN_DELTA field  Minimum step to fill progress bar
---@field SPEED field  Progress bas fill rate. More -> faster
local druid__progress__style = {}


---@class druid.radio_group : druid.base_component
---@field checkboxes Checkbox[] Array of checkbox components
---@field on_radio_click druid.event On any checkbox click
local druid__radio_group = {}

--- Return radio group state
---@param self druid.radio_group @{RadioGroup}
---@return number Index in radio group
function druid__radio_group.get_state(self) end

--- Component init function
---@param self druid.radio_group @{RadioGroup}
---@param nodes node[] Array of gui node
---@param callback function Radio callback
---@param click_nodes node[] Array of trigger nodes, by default equals to nodes
function druid__radio_group.init(self, nodes, callback, click_nodes) end

--- Set radio group state
---@param self druid.radio_group @{RadioGroup}
---@param index number Index in radio group
---@param is_instant boolean If is instant state change
function druid__radio_group.set_state(self, index, is_instant) end


---@class druid.rich_input : druid.input
---@field cursor node On input field text change to empty string callback(self, input_text)
---@field druid druid_instance The component druid instance
---@field input druid.input On input field text change callback(self, input_text)
---@field placeholder druid.text On input field text change to max length string callback(self, input_text)
local druid__rich_input = {}

--- Component init function
---@param self druid.rich_input @{RichInput}
---@param template string The template string name
---@param nodes table Nodes table from gui.clone_tree
function druid__rich_input.init(self, template, nodes) end

--- Set placeholder text
---@param self druid.rich_input @{RichInput}
---@param placeholder_text string The placeholder text
function druid__rich_input.set_placeholder(self, placeholder_text) end


---@class druid.rich_text : druid.base_component
---@field component field The component druid instance
---@field style druid.rich_text.style Component style params.
local druid__rich_text = {}

--- Clear all created words.
function druid__rich_text.clear() end

--- Get current line metrics
---@return druid.rich_text.lines_metrics
function druid__rich_text.get_line_metric() end

--- Get all current words.
---@return table druid.rich_text.word[]
function druid__rich_text.get_words() end

--- Rich Text component constructor
---@param self druid.rich_text @{RichText}
---@param template string The Rich Text template name
---@param nodes table The node table, if prefab was copied by gui.clone_tree()
function druid__rich_text.init(self, template, nodes) end

--- Set text for Rich Text
---@param self druid.rich_text @{RichText}
---@param text string The text to set
---@return druid.rich_text.word[] words
---@return druid.rich_text.lines_metrics line_metrics
function druid__rich_text.set_text(self, text) end

--- Get all words, which has a passed tag.
---@param tag string
---@return druid.rich_text.word[] words
function druid__rich_text.tagged(tag) end


---@class druid.rich_text.style
---@field ADJUST_SCALE_DELTA field  Scale step on each height adjust step
---@field ADJUST_STEPS field  Amount steps of attemps text adjust by height
---@field COLORS field  Rich Text color aliases
local druid__rich_text__style = {}


---@class druid.scroll : druid.base_component
---@field available_pos vector4 Available position for content node: (min_x, max_y, max_x, min_y)
---@field available_size vector3 Size of available positions: (width, height, 0)
---@field content_node node Scroll content node
---@field drag druid.drag Drag Druid component
---@field inertion vector3 Current inert speed
---@field is_animate bool Flag, if scroll now animating by gui.animate
---@field is_inert bool Flag, if scroll now moving by inertion
---@field on_point_scroll druid.event On scroll_to_index function callback(self, index, point)
---@field on_scroll druid.event On scroll move callback(self, position)
---@field on_scroll_to druid.event On scroll_to function callback(self, target, is_instant)
---@field position vector3 Current scroll posisition
---@field selected number Current index of points of interests
---@field style druid.scroll.style Component style params.
---@field target_position vector3 Current scroll target position
---@field view_node node Scroll view node
local druid__scroll = {}

--- Bind the grid component (Static or Dynamic) to recalculate  scroll size on grid changes
---@param self druid.scroll @{Scroll}
---@param grid druid.static_grid|druid.dynamic_grid Druid grid component
---@return druid.scroll Current scroll instance
function druid__scroll.bind_grid(self, grid) end

--- Return current scroll progress status.
--- Values will be in [0..1] interval
---@param self druid.scroll @{Scroll}
---@return vector3 New vector with scroll progress values
function druid__scroll.get_percent(self) end

--- Return vector of scroll size with width and height.
---@param self druid.scroll @{Scroll}
---@return vector3 Available scroll size
function druid__scroll.get_scroll_size(self) end

--- @{Scroll} constructor
---@param self druid.scroll @{Scroll}
---@param view_node string|node GUI view scroll node
---@param content_node string|node GUI content scroll node
function druid__scroll.init(self, view_node, content_node) end

--- Return if scroll have inertion.
---@param self druid.scroll @{Scroll}
---@return bool If scroll have inertion
function druid__scroll.is_inert(self) end

--- Check node if it visible now on scroll.
--- Extra border is not affected. Return true for elements in extra scroll zone
---@param self druid.scroll @{Scroll}
---@param node node The node to check
---@return boolean True if node in visible scroll area
function druid__scroll.is_node_in_view(self, node) end

--- Start scroll to target point.
---@param self druid.scroll @{Scroll}
---@param point vector3 Target point
---@param is_instant? bool Instant scroll flag
function druid__scroll.scroll_to(self, point, is_instant) end

--- Scroll to item in scroll by point index.
---@param self druid.scroll @{Scroll}
---@param index number Point index
---@param skip_cb? bool If true, skip the point callback
function druid__scroll.scroll_to_index(self, index, skip_cb) end

--- Start scroll to target scroll percent
---@param self druid.scroll @{Scroll}
---@param percent vector3 target percent
---@param is_instant? bool instant scroll flag
function druid__scroll.scroll_to_percent(self, percent, is_instant) end

--- Strict drag scroll area.
--- Useful for  restrict events outside stencil node
---@param self druid.drag
---@param node node|string Gui node (or node id)
function druid__scroll.set_click_zone(self, node) end

--- Set extra size for scroll stretching.
--- Set 0 to disable stretching effect
---@param self druid.scroll @{Scroll}
---@param stretch_size number Size in pixels of additional scroll area
---@return druid.scroll Current scroll instance
function druid__scroll.set_extra_stretch_size(self, stretch_size) end

--- Lock or unlock horizontal scroll
---@param self druid.scroll @{Scroll}
---@param state bool True, if horizontal scroll is enabled
---@return druid.scroll Current scroll instance
function druid__scroll.set_horizontal_scroll(self, state) end

--- Enable or disable scroll inert.
--- If disabled, scroll through points (if exist)  If no points, just simple drag without inertion
---@param self druid.scroll @{Scroll}
---@param state bool Inert scroll state
---@return druid.scroll Current scroll instance
function druid__scroll.set_inert(self, state) end

--- Set points of interest.
--- Scroll will always centered on closer points
---@param self druid.scroll @{Scroll}
---@param points table Array of vector3 points
---@return druid.scroll Current scroll instance
function druid__scroll.set_points(self, points) end

--- Set scroll content size.
--- It will change content gui node size
---@param self druid.scroll @{Scroll}
---@param size vector3 The new size for content node
---@param offset? vector3 Offset value to set, where content is starts
---@return druid.scroll Current scroll instance
function druid__scroll.set_size(self, size, offset) end

--- Lock or unlock vertical scroll
---@param self druid.scroll @{Scroll}
---@param state bool True, if vertical scroll is enabled
---@return druid.scroll Current scroll instance
function druid__scroll.set_vertical_scroll(self, state) end


---@class druid.scroll.style
---@field ANIM_SPEED field  Scroll gui.animation speed for scroll_to function
---@field BACK_SPEED field  Scroll back returning lerp speed
---@field EXTRA_STRETCH_SIZE field  extra size in pixels outside of scroll (stretch effect)
---@field FRICT field  Multiplier for free inertion
---@field FRICT_HOLD field  Multiplier for inertion, while touching
---@field INERT_SPEED field  Multiplier for inertion speed
---@field INERT_THRESHOLD field  Scroll speed to stop inertion
---@field POINTS_DEADZONE field  Speed to check points of interests in no_inertion mode
---@field SMALL_CONTENT_SCROLL field  If true, content node with size less than view node size can be scrolled
---@field WHEEL_SCROLL_BY_INERTION field  If true, wheel will add inertion to scroll. Direct set position otherwise.
---@field WHEEL_SCROLL_INVERTED field  If true, invert direction for touchpad and mouse wheel scroll
---@field WHEEL_SCROLL_SPEED field  The scroll speed via mouse wheel scroll or touchpad. Set to 0 to disable wheel scrolling
local druid__scroll__style = {}


---@class druid.slider : druid.base_component
---@field dist number Length between start and end position
---@field end_pos vector3 End pin node position
---@field is_drag bool Current drag state
---@field node node Slider pin node
---@field on_change_value druid.event On change value callback(self, value)
---@field pos vector3 Current pin node position
---@field start_pos vector3 Start pin node position
---@field target_pos vector3 Targer pin node position
---@field value number Current slider value
local druid__slider = {}

--- Component init function
---@param self druid.slider @{Slider}
---@param node node Gui pin node
---@param end_pos vector3 The end position of slider
---@param callback? function On slider change callback
function druid__slider.init(self, node, end_pos, callback) end

--- Set value for slider
---@param self druid.slider @{Slider}
---@param value number Value from 0 to 1
---@param is_silent? bool Don't trigger event if true
function druid__slider.set(self, value, is_silent) end

--- Set input zone for slider.
--- User can touch any place of node, pin instantly will  move at this position and node drag will start.  This function require the Defold version 1.3.0+
---@param self druid.slider @{Slider}
---@param input_node node|string
---@return druid.slider @{Slider}
function druid__slider.set_input_node(self, input_node) end

--- Set slider steps.
--- Pin node will  apply closest step position
---@param self druid.slider @{Slider}
---@param steps number[] Array of steps
---@return druid.slider @{Slider}
function druid__slider.set_steps(self, steps) end


---@class druid.static_grid : druid.base_component
---@field anchor vector3 Item anchor [0..1]
---@field border vector4 The size of item content
---@field first_index number The first index of node in grid
---@field last_index number The last index of node in grid
---@field node_size vector3 Item size
---@field nodes node[] List of all grid nodes
---@field on_add_item druid.event On item add callback(self, node, index)
---@field on_change_items druid.event On item add, remove or change in_row callback(self, index|nil)
---@field on_clear druid.event On grid clear callback(self)
---@field on_remove_item druid.event On item remove callback(self, index)
---@field on_update_positions druid.event On update item positions callback(self)
---@field parent node Parent gui node
---@field pivot vector3 Item pivot [-0.5..0.5]
---@field style druid.static_grid.style Component style params.
local druid__static_grid = {}

--- Add new item to the grid
---@param self druid.static_grid @{StaticGrid}
---@param item node Gui node
---@param index? number The item position. By default add as last item
---@param shift_policy? number How shift nodes, if required. See const.SHIFT
---@param is_instant? boolean If true, update node positions instantly
function druid__static_grid.add(self, item, index, shift_policy, is_instant) end

--- Clear grid nodes array.
--- GUI nodes will be not deleted!  If you want to delete GUI nodes, use static_grid.nodes array before grid:clear
---@param self druid.static_grid @{StaticGrid}
---@return druid.static_grid Current grid instance
function druid__static_grid.clear(self) end

--- Return array of all node positions
---@param self druid.static_grid @{StaticGrid}
---@return vector3[] All grid node positions
function druid__static_grid.get_all_pos(self) end

--- Return grid content borders
---@param self druid.static_grid @{StaticGrid}
---@return vector3 The grid content borders
function druid__static_grid.get_borders(self) end

--- Return index for grid pos
---@param self druid.static_grid @{StaticGrid}
---@param pos vector3 The node position in the grid
---@return number The node index
function druid__static_grid.get_index(self, pos) end

--- Return grid index by node
---@param self druid.static_grid @{StaticGrid}
---@param node node The gui node in the grid
---@return number The node index
function druid__static_grid.get_index_by_node(self, node) end

--- Return StaticGrid offset, where StaticGrid content starts.
---@param self druid.static_grid @{StaticGrid} The StaticGrid instance
---@return vector3 The StaticGrid offset
function druid__static_grid.get_offset(self) end

--- Return pos for grid node index
---@param self druid.static_grid @{StaticGrid}
---@param index number The grid element index
---@return vector3 Node position
function druid__static_grid.get_pos(self, index) end

--- Return grid content size
---@param self druid.static_grid @{StaticGrid}
---@return vector3 The grid content size
function druid__static_grid.get_size(self) end

--- The @{StaticGrid} constructor
---@param self druid.static_grid @{StaticGrid}
---@param parent string|node The GUI Node container, where grid's items will be placed
---@param element node Element prefab. Need to get it size
---@param in_row? number How many nodes in row can be placed
function druid__static_grid.init(self, parent, element, in_row) end

--- Remove the item from the grid.
--- Note that gui node will be not deleted
---@param self druid.static_grid @{StaticGrid}
---@param index number The grid node index to remove
---@param shift_policy? number How shift nodes, if required. See const.SHIFT
---@param is_instant? boolean If true, update node positions instantly
---@return node The deleted gui node from grid
function druid__static_grid.remove(self, index, shift_policy, is_instant) end

--- Set grid anchor.
--- Default anchor is equal to anchor of grid parent node
---@param self druid.static_grid @{StaticGrid}
---@param anchor vector3 Anchor
function druid__static_grid.set_anchor(self, anchor) end

--- Set new in_row elements for grid
---@param self druid.static_grid @{StaticGrid}
---@param in_row number The new in_row value
---@return druid.static_grid Current grid instance
function druid__static_grid.set_in_row(self, in_row) end

--- Change set position function for grid nodes.
--- It will call on  update poses on grid elements. Default: gui.set_position
---@param self druid.static_grid @{StaticGrid}
---@param callback function Function on node set position
---@return druid.static_grid Current grid instance
function druid__static_grid.set_position_function(self, callback) end


---@class druid.static_grid.style
---@field IS_ALIGN_LAST_ROW field  If true, always align last row of the grid as grid pivot sets
---@field IS_DYNAMIC_NODE_POSES field  If true, always center grid content as grid pivot sets
local druid__static_grid__style = {}


---@class druid.swipe : druid.base_component
---@field click_zone node Restriction zone
---@field node node Swipe node
---@field on_swipe druid.event Trigger on swipe event(self, swipe_side, dist, delta_time)
---@field style druid.swipe.style Component style params.
local druid__swipe = {}

--- Component init function
---@param self druid.swipe @{Swipe}
---@param node node Gui node
---@param on_swipe_callback function Swipe callback for on_swipe_end event
function druid__swipe.init(self, node, on_swipe_callback) end

--- Strict swipe click area.
--- Useful for  restrict events outside stencil node
---@param self druid.swipe @{Swipe}
---@param zone node Gui node
function druid__swipe.set_click_zone(self, zone) end


---@class druid.swipe.style
---@field SWIPE_THRESHOLD field  Minimum distance for swipe trigger
---@field SWIPE_TIME field  Maximum time for swipe trigger
---@field SWIPE_TRIGGER_ON_MOVE field  If true, trigger on swipe moving, not only release action
local druid__swipe__style = {}


---@class druid.text : druid.base_component
---@field adjust_type number Current text size adjust settings
---@field color vector3 Current text color
---@field node node Text node
---@field node_id hash The node id of text node
---@field on_set_pivot druid.event On change pivot callback(self, pivot)
---@field on_set_text druid.event On set text callback(self, text)
---@field on_update_text_scale druid.event On adjust text size callback(self, new_scale, text_metrics)
---@field pos vector3 Current text position
---@field scale vector3 Current text node scale
---@field start_scale vector3 Initial text node scale
---@field start_size vector3 Initial text node size
---@field style druid.text.style Component style params.
---@field text_area vector3 Current text node available are
local druid__text = {}

--- Return current text adjust type
---@param self unknown
---@param adjust_type unknown
---@return number The current text adjust type
function druid__text.get_text_adjust(self, adjust_type) end

--- Calculate text width with font with respect to trailing space
---@param self druid.text @{Text}
---@param text string
---@return number Width
---@return number Height
function druid__text.get_text_size(self, text) end

--- @{Text} constructor
---@param self druid.text @{Text}
---@param node string|node Node name or GUI Text Node itself
---@param value string Initial text. Default value is node text from GUI scene.
---@param adjust_type string Adjust type for text. By default is DOWNSCALE. Look const.TEXT_ADJUST for reference
function druid__text.init(self, node, value, adjust_type) end

--- Return true, if text with line break
---@param self druid.text @{Text}
---@return bool Is text node with line break
function druid__text.is_multiline(self) end

--- Set alpha
---@param self druid.text @{Text}
---@param alpha number Alpha for node
---@return druid.text Current text instance
function druid__text.set_alpha(self, alpha) end

--- Set color
---@param self druid.text @{Text}
---@param color vector4 Color for node
---@return druid.text Current text instance
function druid__text.set_color(self, color) end

--- Set minimal scale for DOWNSCALE_LIMITED or SCALE_THEN_SCROLL adjust types
---@param self druid.text @{Text}
---@param minimal_scale number If pass nil - not use minimal scale
---@return druid.text Current text instance
function druid__text.set_minimal_scale(self, minimal_scale) end

--- Set text pivot.
--- Text will re-anchor inside text area
---@param self druid.text @{Text}
---@param pivot gui.pivot Gui pivot constant
---@return druid.text Current text instance
function druid__text.set_pivot(self, pivot) end

--- Set scale
---@param self druid.text @{Text}
---@param scale vector3 Scale for node
---@return druid.text Current text instance
function druid__text.set_scale(self, scale) end

--- Set text adjust, refresh the current text visuals, if needed
---@param self druid.text @{Text}
---@param adjust_type number See const.TEXT_ADJUST. If pass nil - use current adjust type
---@param minimal_scale number If pass nil - not use minimal scale
---@return druid.text Current text instance
function druid__text.set_text_adjust(self, adjust_type, minimal_scale) end

--- Set text to text field
---@param self druid.text @{Text}
---@param set_to string Text for node
---@return druid.text Current text instance
function druid__text.set_to(self, set_to) end


---@class druid.text.style
---@field DEFAULT_ADJUST field  The default adjust type for any text component
---@field TRIM_POSTFIX field  The postfix for TRIM adjust type
local druid__text__style = {}


---@class druid.timer : druid.base_component
---@field from number Initial timer value
---@field node node Trigger node
---@field on_set_enabled druid.event On timer change enabled state callback(self, is_enabled)
---@field on_tick druid.event On timer tick.
---@field on_timer_end druid.event On timer end callback
---@field target number Target timer value
---@field value number Current timer value
local druid__timer = {}

--- Component init function
---@param self druid.timer @{Timer}
---@param node node Gui text node
---@param seconds_from number Start timer value in seconds
---@param seconds_to number End timer value in seconds
---@param callback function Function on timer end
function druid__timer.init(self, node, seconds_from, seconds_to, callback) end

--- Set time interval
---@param self druid.timer @{Timer}
---@param from number Start time in seconds
---@param to number Target time in seconds
function druid__timer.set_interval(self, from, to) end

--- Called when update
---@param self druid.timer @{Timer}
---@param is_on bool Timer enable state
function druid__timer.set_state(self, is_on) end

--- Set text to text field
---@param self druid.timer @{Timer}
---@param set_to number Value in seconds
function druid__timer.set_to(self, set_to) end


---@class druid_const
---@field ON_INPUT field Component Interests
local druid_const = {}


---@class druid_instance
local druid_instance = {}

--- Call this in gui_script final function.
---@param self druid_instance
function druid_instance.final(self) end

--- Create new component.
---@param self druid_instance
---@param component Component Component module
---@param ... args Other component params to pass it to component:init function
function druid_instance.new(self, component, ...) end

--- Create @{BackHandler} component
---@param self druid_instance
---@param callback function On back button
---@param params any Callback argument
---@return druid.back_handler @{BackHandler} component
function druid_instance.new_back_handler(self, callback, params) end

--- Create @{Blocker} component
---@param self druid_instance
---@param node node|string Gui node (or node id)
---@return druid.blocker @{Blocker} component
function druid_instance.new_blocker(self, node) end

--- Create @{Button} component
---@param self druid_instance
---@param node node|string GUI node (or node id)
---@param callback function Button callback
---@param params? table Button callback params
---@param anim_node? node|string Button anim node (node, if not provided)
---@return druid.button @{Button} component
function druid_instance.new_button(self, node, callback, params, anim_node) end

--- Create @{Checkbox} component
---@param self druid_instance
---@param node node|string Gui node (or node id)
---@param callback function Checkbox callback
---@param click_node? node Trigger node, by default equals to node
---@param initial_state? boolean The initial state of checkbox, default - false
---@return druid.checkbox @{Checkbox} component
function druid_instance.new_checkbox(self, node, callback, click_node, initial_state) end

--- Create @{CheckboxGroup} component
---@param self druid_instance
---@param nodes (node | string)[] Array of gui node (or node id)
---@param callback function Checkbox callback
---@param click_nodes? (node | string)[] Array of trigger nodes (or node id), by default equals to nodes
---@return druid.checkbox_group @{CheckboxGroup} component
function druid_instance.new_checkbox_group(self, nodes, callback, click_nodes) end

--- Create @{DataList} component
---@param self druid_instance
---@param druid_scroll druid.scroll The Scroll instance for Data List component
---@param druid_grid Grid The Grid instance for Data List component
---@param create_function function The create function callback(self, data, index, data_list). Function should return (node, [component])
---@return druid.data_list @{DataList} component
function druid_instance.new_data_list(self, druid_scroll, druid_grid, create_function) end

--- Create @{Drag} component
---@param self druid_instance
---@param node node|string GUI node (or node id) to detect dragging
---@param on_drag_callback function Callback for on_drag_event(self, dx, dy)
---@return druid.drag @{Drag} component
function druid_instance.new_drag(self, node, on_drag_callback) end

--- Create @{DynamicGrid} component
---@param self druid_instance
---@param parent node|string The gui node (or node id) parent, where items will be placed
---@return druid.dynamic_grid @{DynamicGrid} component
function druid_instance.new_dynamic_grid(self, parent) end

--- Create @{Hotkey} component
---@param self druid_instance
---@param keys_array string|string[] Keys for trigger action. Should contains one action key and any amount of modificator keys
---@param callback function Button callback
---@param params? value Button callback params
---@return druid.hotkey @{Hotkey} component
function druid_instance.new_hotkey(self, keys_array, callback, params) end

--- Create @{Hover} component
---@param self druid_instance
---@param node node|string Gui node (or node id)
---@param on_hover_callback function Hover callback
---@return druid.hover @{Hover} component
function druid_instance.new_hover(self, node, on_hover_callback) end

--- Create @{Input} component
---@param self druid_instance
---@param click_node node|string Button node (or node id) to enabled input component
---@param text_node node|string|druid.text Text node what will be changed on user input
---@param keyboard_type? number Gui keyboard type for input field
---@return druid.input @{Input} component
function druid_instance.new_input(self, click_node, text_node, keyboard_type) end

--- Create @{LangText} component
---@param self druid_instance
---@param node node|string The text node (or node id)
---@param locale_id? string Default locale id
---@param no_adjust? bool If true, will not correct text size
---@return druid.lang_text @{LangText} component
function druid_instance.new_lang_text(self, node, locale_id, no_adjust) end

--- Create @{Layout} component
---@param self druid_instance
---@param node string|node Layout node (or node id)
---@param mode string The layout mode
---@param on_size_changed_callback? function The callback on window resize
---@return druid.layout @{Layout} component
function druid_instance.new_layout(self, node, mode, on_size_changed_callback) end

--- Create @{Progress} component
---@param self druid_instance
---@param node string|node Progress bar fill node or node name
---@param key string Progress bar direction: const.SIDE.X or const.SIDE.Y
---@param init_value? number Initial value of progress bar
---@return druid.progress @{Progress} component
function druid_instance.new_progress(self, node, key, init_value) end

--- Create @{RadioGroup} component
---@param self druid_instance
---@param nodes (node | string)[] Array of gui node (or node id)
---@param callback function Radio callback
---@param click_nodes? (node | string)[] Array of trigger nodes (or node id), by default equals to nodes
---@return druid.radio_group @{RadioGroup} component
function druid_instance.new_radio_group(self, nodes, callback, click_nodes) end

--- Create @{RichText} component.
--- As a template please check rich_text.gui layout.
---@param self druid_instance
---@param template string Template name if used
---@param nodes table Nodes table from gui.clone_tree
---@return druid.rich_text @{RichText} component
function druid_instance.new_rich_text(self, template, nodes) end

--- Create @{Scroll} component
---@param self druid_instance
---@param view_node node|string GUI view scroll node (or node id)
---@param content_node node|string GUI content scroll node (or node id)
---@return druid.scroll @{Scroll} component
function druid_instance.new_scroll(self, view_node, content_node) end

--- Create @{Slider} component
---@param self druid_instance
---@param node node|string Gui pin node (or node id)
---@param end_pos vector3 The end position of slider
---@param callback? function On slider change callback
---@return druid.slider @{Slider} component
function druid_instance.new_slider(self, node, end_pos, callback) end

--- Create @{StaticGrid} component
---@param self druid_instance
---@param parent node|string The gui node (or node id) parent, where items will be placed
---@param element node|string Element prefab (or prefab id). Need to get it size
---@param in_row? number How many nodes in row can be placed
---@return druid.static_grid @{StaticGrid} component
function druid_instance.new_static_grid(self, parent, element, in_row) end

--- Create @{Swipe} component
---@param self druid_instance
---@param node node|string Gui node (or node id)
---@param on_swipe_callback function Swipe callback for on_swipe_end event
---@return druid.swipe @{Swipe} component
function druid_instance.new_swipe(self, node, on_swipe_callback) end

--- Create @{Text} component
---@param self druid_instance
---@param node node|string Gui text node (or node id)
---@param value? string Initial text. Default value is node text from GUI scene.
---@param no_adjust? bool If true, text will be not auto-adjust size
---@return druid.text @{Text} component
function druid_instance.new_text(self, node, value, no_adjust) end

--- Create @{Timer} component
---@param self druid_instance
---@param node node|string Gui text node (or node id)
---@param seconds_from number Start timer value in seconds
---@param seconds_to? number End timer value in seconds
---@param callback? function Function on timer end
---@return druid.timer @{Timer} component
function druid_instance.new_timer(self, node, seconds_from, seconds_to, callback) end

--- Call this in gui_script on_input function.
--- Used for almost all components
---@param self druid_instance
---@param action_id hash Action_id from on_input
---@param action table Action from on_input
---@return bool The boolean value is input was consumed
function druid_instance.on_input(self, action_id, action) end

--- Call this in gui_script on_message function.
--- Used for special actions. See SPECIFIC_UI_MESSAGES table
---@param self druid_instance
---@param message_id hash Message_id from on_message
---@param message table Message from on_message
---@param sender hash Sender from on_message
function druid_instance.on_message(self, message_id, message, sender) end

--- Remove created component from Druid instance.
--- Component `on_remove` function will be invoked, if exist.
---@param self druid_instance
---@param component Component Component instance
function druid_instance.remove(self, component) end

--- Set blacklist components for input processing.
--- If blacklist is not empty and component contains in this list,  component will be not processed on input step
---@param self druid_instance @{DruidInstance}
---@param blacklist_components table|Component The array of component to blacklist
---@return self @{DruidInstance}
function druid_instance.set_blacklist(self, blacklist_components) end

--- Set whitelist components for input processing.
--- If whitelist is not empty and component not contains in this list,  component will be not processed on input step
---@param self druid_instance
---@param whitelist_components table|Component The array of component to whitelist
---@return self @{DruidInstance}
function druid_instance.set_whitelist(self, whitelist_components) end

--- Call this in gui_script update function.
--- Used for: scroll, progress, timer components
---@param self druid_instance
---@param dt number Delta time
function druid_instance.update(self, dt) end


---@class helper
local helper = {}

--- Add all elements from source array to the target array
---@param target table Array to put elements from source
---@param source table The source array to get elements from
---@return array The target array
function helper.add_array(target, source) end

--- Centerate nodes by x position with margin.
--- This functions calculate total width of nodes and set position for each node.  The centrate will be around 0 x position.
---@param margin number Offset between nodes
---@param ... unknown Gui nodes
function helper.centrate_nodes(margin, ...) end

--- Clamp value between min and max
---@param a number Value
---@param min number Min value
---@param max number Max value
---@return number Clamped value
function helper.clamp(a, min, max) end

--- Check if value is in array and return index of it
---@param t table Array
---@param value unknown Value
---@return number|nil Index of value or nil
function helper.contains(t, value) end

--- Make a copy table with all nested tables
---@param orig_table table Original table
---@return table Copy of original table
function helper.deepcopy(orig_table) end

--- Calculate distance between two points
---@param x1 number First point x
---@param y1 number First point y
---@param x2 number Second point x
---@param y2 number Second point y
---@return number Distance
function helper.distance(x1, y1, x2, y2) end

--- Distance from node position to his borders
---@param node node GUI node
---@param offset vector3 Offset from node position. Pass current node position to get non relative border values
---@return vector4 Vector4 with border values (left, top, right, down)
function helper.get_border(node, offset) end

--- Return closest non inverted clipping parent node for given node
---@param node node GUI node
---@return node|nil The closest stencil node or nil
function helper.get_closest_stencil_node(node) end

--- Get current GUI scale for each side
---@return number scale_x
---@return number scale_y
function helper.get_gui_scale() end

--- Get node offset for given GUI pivot.
--- Offset shown in [-0.5 .. 0.5] range, where -0.5 is left or bottom, 0.5 is right or top.
---@param pivot gui.pivot The node pivot
---@return vector3 Vector offset with [-0.5..0.5] values
function helper.get_pivot_offset(pivot) end

--- Get node size adjusted by scale
---@param node node GUI node
---@return vector3 Scaled size
function helper.get_scaled_size(node) end

--- Get cumulative parent's node scale
---@param node node Gui node
---@param include_passed_node_scale bool True if add current node scale to result
---@return vector3 The scene node scale
function helper.get_scene_scale(node, include_passed_node_scale) end

--- Get current screen stretch multiplier for each side
---@return number stretch_x
---@return number stretch_y
function helper.get_screen_aspect_koef() end

--- Get text metric from GUI node.
---@param text_node node
---@return GUITextMetrics
function helper.get_text_metrics_from_node(text_node) end

--- Add value to array with shift policy
--- Shift policy can be: left, right, no_shift
---@param array table Array
---@param item unknown Item to insert
---@param index number Index to insert. If nil, item will be inserted at the end of array
---@param shift_policy const.SHIFT Shift policy
---@return item Inserted item
function helper.insert_with_shift(array, item, index, shift_policy) end

--- Check if device is native mobile (Android or iOS)
---@return bool Is mobile
function helper.is_mobile() end

--- Check if device is HTML5
---@return bool Is web
function helper.is_web() end

--- Lerp between two values
---@param a number First value
---@param b number Second value
---@param t number Lerp amount
---@return number Lerped value
function helper.lerp(a, b, t) end

--- Remove value from array with shift policy
--- Shift policy can be: left, right, no_shift
---@param array table Array
---@param index number Index to remove. If nil, item will be removed from the end of array
---@param shift_policy const.SHIFT Shift policy
---@return item Removed item
function helper.remove_with_shift(array, index, shift_policy) end

--- Round number to specified decimal places
---@param num number Number
---@param num_decimal_places number Decimal places
---@return number Rounded number
function helper.round(num, num_decimal_places) end

--- Return sign of value (-1, 0, 1)
---@param val number Value
---@return number Sign
function helper.sign(val) end

--- Move value from current to target value with step amount
---@param current number Current value
---@param target number Target value
---@param step number Step amount
---@return number New value
function helper.step(current, target, step) end

--- Simple table to one-line string converter
---@param t table
---@return string
function helper.table_to_string(t) end


-- Manual Annotations --

---@class druid.rich_text.style
---@field COLORS table
---@field ADJUST_STEPS number
---@field ADJUST_SCALE_DELTA number

---@class druid.rich_text.metrics
---@field width number
---@field height number
---@field offset_x number|nil
---@field offset_y number|nil
---@field node_size vector3|nil @For images only

---@class druid.rich_text.lines_metrics
---@field text_width number
---@field text_height number
---@field lines table<number, druid.rich_text.metrics>

---@class druid.rich_text.word
---@field node node
---@field relative_scale number
---@field color vector4
---@field position vector3
---@field offset vector3
---@field scale vector3
---@field size vector3
---@field metrics druid.rich_text.metrics
---@field pivot Pivot
---@field text string
---@field shadow vector4
---@field outline vector4
---@field font string
---@field image druid.rich_text.image
---@field default_animation string
---@field anchor number
---@field br boolean
---@field nobr boolean

---@class druid.rich_text.word.image
---@field texture string
---@field anim string
---@field width number
---@field height number

---@class druid.rich_text.settings
---@field parent node
---@field size number
---@field fonts table<string, string>
---@field color vector4
---@field shadow vector4
---@field outline vector4
---@field position vector3
---@field image_pixel_grid_snap boolean
---@field combine_words boolean
---@field default_animation string
---@field node_prefab node
---@field text_prefab node

---@class GUITextMetrics
---@field width number
---@field height number
---@field max_ascent number
---@field max_descent number
