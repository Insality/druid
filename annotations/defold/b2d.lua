--[[
  Generated with github.com/astrochili/defold-annotations
  Defold 1.8.0

  Box2D documentation

  Functions for interacting with Box2D.
--]]

---@diagnostic disable: lowercase-global
---@diagnostic disable: missing-return
---@diagnostic disable: duplicate-doc-param
---@diagnostic disable: duplicate-set-field

---@class defold_api.b2d
b2d = {}

---Get the Box2D body from a collision object
---@param url string|hash|url the url to the game object collision component
---@return b2Body body the body if successful. Otherwise nil.
function b2d.get_body(url) end

---Get the Box2D world from the current collection
---@return b2World world the world if successful. Otherwise nil.
function b2d.get_world() end

return b2d