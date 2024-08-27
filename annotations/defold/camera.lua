--[[
  Generated with github.com/astrochili/defold-annotations
  Defold 1.8.0

  Camera API documentation

  Messages to control camera components and camera focus.
--]]

---@diagnostic disable: lowercase-global
---@diagnostic disable: missing-return
---@diagnostic disable: duplicate-doc-param
---@diagnostic disable: duplicate-set-field

---@class defold_api.camera
camera = {}

---makes camera active
---@param url string|hash|url url of camera component
function camera.acquire_focus(url) end

---deactivate camera
---@param url string|hash|url url of camera component
function camera.release_focus(url) end

return camera