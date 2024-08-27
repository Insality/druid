--[[
  Generated with github.com/astrochili/defold-annotations
  Defold 1.8.0

  Timer API documentation

  Timers allow you to set a delay and a callback to be called when the timer completes.
  The timers created with this API are updated with the collection timer where they
  are created. If you pause or speed up the collection (using set_time_step) it will
  also affect the new timer.
--]]

---@diagnostic disable: lowercase-global
---@diagnostic disable: missing-return
---@diagnostic disable: duplicate-doc-param
---@diagnostic disable: duplicate-set-field

---@class defold_api.timer
timer = {}

---Indicates an invalid timer handle
timer.INVALID_TIMER_HANDLE = nil

---You may cancel a timer from inside a timer callback.
---Cancelling a timer that is already executed or cancelled is safe.
---@param handle hash the timer handle returned by timer.delay()
---@return boolean true if the timer was active, false if the timer is already cancelled / complete
function timer.cancel(handle) end

---Adds a timer and returns a unique handle.
---You may create more timers from inside a timer callback.
---Using a delay of 0 will result in a timer that triggers at the next frame just before
---script update functions.
---If you want a timer that triggers on each frame, set delay to 0.0f and repeat to true.
---Timers created within a script will automatically die when the script is deleted.
---@param delay number time interval in seconds
---@param repeating boolean true = repeat timer until cancel, false = one-shot timer
---@param callback fun(self, handle, time_elapsed) timer callback function
---
---self
---object The current object
---handle
---number The handle of the timer
---time_elapsed
---number The elapsed time - on first trigger it is time since timer.delay call, otherwise time since last trigger
---
---@return hash handle identifier for the create timer, returns timer.INVALID_TIMER_HANDLE if the timer can not be created
function timer.delay(delay, repeating, callback) end

---Get information about timer.
---@param handle hash the timer handle returned by timer.delay()
---@return { time_remaining:number, delay:number, repeating:boolean }|nil data table or nil if timer is cancelled/completed. table with data in the following fields:
---
---time_remaining
---number Time remaining until the next time a timer.delay() fires.
---delay
---number Time interval.
---repeating
---boolean true = repeat timer until cancel, false = one-shot timer.
---
function timer.get_info(handle) end

---Manual triggering a callback for a timer.
---@param handle hash the timer handle returned by timer.delay()
---@return boolean true if the timer was active, false if the timer is already cancelled / complete
function timer.trigger(handle) end

return timer