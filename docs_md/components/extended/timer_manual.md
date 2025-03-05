# Druid Timer Component

## Description

The Timer component provides a way to create and manage countdown or countup timers in your UI. It can be used for game timers, cooldowns, or any feature that requires time tracking with visual feedback.

## Features

- Countdown and countup timer modes
- Customizable time format display
- Pause, resume, and reset functionality
- Events for timer updates and completion
- Optional text component integration for visual display
- Support for different time units (seconds, minutes, hours)

## Basic Usage

```lua
-- Basic countdown timer (10 seconds)
local timer = self.druid:new_timer(10, true)

-- Start the timer
timer:start()
```

### Parameters

- **time**: The initial time value in seconds
- **is_countdown**: (optional) Boolean indicating if this is a countdown timer (default: false)

## Methods

```lua
-- Start the timer
timer:start()

-- Pause the timer
timer:pause()

-- Resume a paused timer
timer:resume()

-- Reset the timer to its initial value
timer:reset()

-- Set a new time value
timer:set_time(30) -- Set to 30 seconds

-- Get current time value
local current_time = timer:get_time()

-- Check if timer is running
local is_running = timer:is_running()

-- Set a text component to display the timer
local text = self.druid:new_text("timer_text")
timer:set_text(text)

-- Set custom time format
timer:set_format(function(self, time)
    local minutes = math.floor(time / 60)
    local seconds = math.floor(time % 60)
    return string.format("%02d:%02d", minutes, seconds)
end)
```

## Events

```lua
-- Subscribe to timer tick event (called every frame while timer is running)
timer.on_tick:subscribe(function(self, value)
    print("Timer value: " .. value)
end)

-- Subscribe to timer completion event
timer.on_complete:subscribe(function(self)
    print("Timer completed!")
end)
```

## Examples

```lua
-- Create a 5-minute countdown timer with text display
local timer = self.druid:new_timer(300, true) -- 300 seconds = 5 minutes
local text = self.druid:new_text("timer_text")
timer:set_text(text)
timer:set_format(function(self, time)
    local minutes = math.floor(time / 60)
    local seconds = math.floor(time % 60)
    return string.format("%02d:%02d", minutes, seconds)
end)
timer:start()

-- Create a stopwatch (countup timer)
local stopwatch = self.druid:new_timer(0, false)
local text = self.druid:new_text("stopwatch_text")
stopwatch:set_text(text)
stopwatch:start()

-- Create a game round timer with events
local round_timer = self.druid:new_timer(60, true) -- 60 second round
round_timer.on_tick:subscribe(function(self, value)
    if value <= 10 then
        -- Last 10 seconds, show warning
        print("Time is running out!")
    end
end)
round_timer.on_complete:subscribe(function(self)
    -- Round is over
    print("Round completed!")
end)
round_timer:start()
```

## Notes

- The timer component updates every frame while running
- For countdown timers, the timer completes when it reaches 0
- For countup timers, you need to manually check for completion or set a target time
- The default time format is seconds with one decimal place (e.g., "10.0")
- You can customize the time format to display hours, minutes, seconds, or any other format
- The timer component can be paused, resumed, and reset at any time
- When using with a text component, the timer automatically updates the text display
- The timer value is in seconds, but you can convert it to other units in your format function
