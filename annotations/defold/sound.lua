--[[
  Generated with github.com/astrochili/defold-annotations
  Defold 1.8.0

  Sound API documentation
--]]

---@diagnostic disable: lowercase-global
---@diagnostic disable: missing-return
---@diagnostic disable: duplicate-doc-param
---@diagnostic disable: duplicate-set-field

---@class defold_api.sound
sound = {}

---Get mixer group gain
--- Note that gain is in linear scale, between 0 and 1.
---To get the dB value from the gain, use the formula 20 * log(gain).
---Inversely, to find the linear value from a dB value, use the formula
---10db/20.
---@param group string|hash group name
---@return number gain gain in linear scale
function sound.get_group_gain(group) end

---Get a mixer group name as a string.
--- This function is to be used for debugging and
---development tooling only. The function does a reverse hash lookup, which does not
---return a proper string value when the game is built in release mode.
---@param group string|hash group name
---@return string name group name
function sound.get_group_name(group) end

---Get a table of all mixer group names (hashes).
---@return hash[] groups table of mixer group names
function sound.get_groups() end

---Get peak value from mixer group.
--- Note that gain is in linear scale, between 0 and 1.
---To get the dB value from the gain, use the formula 20 * log(gain).
---Inversely, to find the linear value from a dB value, use the formula
---10db/20.
---Also note that the returned value might be an approximation and in particular
---the effective window might be larger than specified.
---@param group string|hash group name
---@param window number window length in seconds
---@return number peak_l peak value for left channel
---@return number peak_r peak value for right channel
function sound.get_peak(group, window) end

---Get RMS (Root Mean Square) value from mixer group. This value is the
---square root of the mean (average) value of the squared function of
---the instantaneous values.
---For instance: for a sinewave signal with a peak gain of -1.94 dB (0.8 linear),
---the RMS is 0.8 × 1/sqrt(2) which is about 0.566.
--- Note the returned value might be an approximation and in particular
---the effective window might be larger than specified.
---@param group string|hash group name
---@param window number window length in seconds
---@return number rms_l RMS value for left channel
---@return number rms_r RMS value for right channel
function sound.get_rms(group, window) end

---Checks if background music is playing, e.g. from iTunes.
--- On non mobile platforms,
---this function always return false.
--- On Android you can only get a correct reading
---of this state if your game is not playing any sounds itself. This is a limitation
---in the Android SDK. If your game is playing any sounds, even with a gain of zero, this
---function will return false.
---The best time to call this function is:
---In the init function of your main collection script before any sounds are triggered
---In a window listener callback when the window.WINDOW_EVENT_FOCUS_GAINED event is received
---Both those times will give you a correct reading of the state even when your application is
---swapped out and in while playing sounds and it works equally well on Android and iOS.
---@return boolean playing true if music is playing, otherwise false.
function sound.is_music_playing() end

---Checks if a phone call is active. If there is an active phone call all
---other sounds will be muted until the phone call is finished.
--- On non mobile platforms,
---this function always return false.
---@return boolean call_active true if there is an active phone call, false otherwise.
function sound.is_phone_call_active() end

---Pause all active voices
---@param url string|hash|url the sound that should pause
---@param pause bool true if the sound should pause
function sound.pause(url, pause) end

---Make the sound component play its sound. Multiple voices are supported. The limit is set to 32 voices per sound component.
--- Note that gain is in linear scale, between 0 and 1.
---To get the dB value from the gain, use the formula 20 * log(gain).
---Inversely, to find the linear value from a dB value, use the formula
---10db/20.
--- A sound will continue to play even if the game object the sound component belonged to is deleted. You can call sound.stop() to stop the sound.
---@param url string|hash|url the sound that should play
---@param play_properties { delay:number|nil, gain:number|nil, pan:number|nil, speed:number|nil }|nil
---optional table with properties:
---delay
---number delay in seconds before the sound starts playing, default is 0.
---gain
---number sound gain between 0 and 1, default is 1. The final gain of the sound will be a combination of this gain, the group gain and the master gain.
---pan
---number sound pan between -1 and 1, default is 0. The final pan of the sound will be an addition of this pan and the sound pan.
---speed
---number sound speed where 1.0 is normal speed, 0.5 is half speed and 2.0 is double speed. The final speed of the sound will be a multiplication of this speed and the sound speed.
---
---@param complete_function fun(self, message_id, message, sender)|nil function to call when the sound has finished playing or stopped manually via sound.stop.
---
---self
---object The current object.
---message_id
---hash The name of the completion message, which can be either "sound_done" if the sound has finished playing, or "sound_stopped" if it was stopped manually.
---message
---table Information about the completion:
---
---
---number play_id - the sequential play identifier that was given by the sound.play function.
---
---
---sender
---url The invoker of the callback: the sound component.
---
---@return number play_id The identifier for the sound voice
function sound.play(url, play_properties, complete_function) end

---Set gain on all active playing voices of a sound.
--- Note that gain is in linear scale, between 0 and 1.
---To get the dB value from the gain, use the formula 20 * log(gain).
---Inversely, to find the linear value from a dB value, use the formula
---10db/20.
---@param url string|hash|url the sound to set the gain of
---@param gain number|nil sound gain between 0 and 1. The final gain of the sound will be a combination of this gain, the group gain and the master gain.
function sound.set_gain(url, gain) end

---Set mixer group gain
--- Note that gain is in linear scale, between 0 and 1.
---To get the dB value from the gain, use the formula 20 * log(gain).
---Inversely, to find the linear value from a dB value, use the formula
---10db/20.
---@param group string|hash group name
---@param gain number gain in linear scale
function sound.set_group_gain(group, gain) end

---Set panning on all active playing voices of a sound.
---The valid range is from -1.0 to 1.0, representing -45 degrees left, to +45 degrees right.
---@param url string|hash|url the sound to set the panning value to
---@param pan number|nil sound panning between -1.0 and 1.0
function sound.set_pan(url, pan) end

---Stop playing all active voices or just one voice if play_id provided
---@param url string|hash|url the sound component that should stop
---@param stop_properties { play_id:number }|nil
---optional table with properties:
---play_id
---number the sequential play identifier that should be stopped (was given by the sound.play() function)
---
function sound.stop(url, stop_properties) end

return sound