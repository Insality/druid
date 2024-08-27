--[[
  Generated with github.com/astrochili/defold-annotations
  Defold 1.8.0

  Messaging API documentation

  Functions for passing messages and constructing URL objects.
--]]

---@diagnostic disable: lowercase-global
---@diagnostic disable: missing-return
---@diagnostic disable: duplicate-doc-param
---@diagnostic disable: duplicate-set-field

---@class defold_api.msg
msg = {}

---Post a message to a receiving URL. The most common case is to send messages
---to a component. If the component part of the receiver is omitted, the message
---is broadcast to all components in the game object.
---The following receiver shorthands are available:
---"." the current game object
---"#" the current component
--- There is a 2 kilobyte limit to the message parameter table size.
---@param receiver string|url|hash The receiver must be a string in URL-format, a URL object or a hashed string.
---@param message_id string|hash The id must be a string or a hashed string.
---@param message table|nil a lua table with message parameters to send.
function msg.post(receiver, message_id, message) end

---creates a new URL from separate arguments
---@param socket string|hash|nil socket of the URL
---@param path string|hash|nil path of the URL
---@param fragment string|hash|nil fragment of the URL
---@return url url a new URL
function msg.url(socket, path, fragment) end

---The format of the string must be [socket:][path][#fragment], which is similar to a HTTP URL.
---When addressing instances:
---socket is the name of a valid world (a collection)
---path is the id of the instance, which can either be relative the instance of the calling script or global
---fragment would be the id of the desired component
---In addition, the following shorthands are available:
---"." the current game object
---"#" the current component
---@param urlstring string string to create the url from
---@return url url a new URL
function msg.url(urlstring) end

---This is equivalent to msg.url(nil) or msg.url("#"), which creates an url to the current
---script component.
---@return url url a new URL
function msg.url() end

return msg