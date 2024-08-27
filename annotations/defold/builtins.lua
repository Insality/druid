--[[
  Generated with github.com/astrochili/defold-annotations
  Defold 1.8.0

  Built-ins API documentation

  Built-in scripting functions.
--]]

---@diagnostic disable: lowercase-global
---@diagnostic disable: missing-return
---@diagnostic disable: duplicate-doc-param
---@diagnostic disable: duplicate-set-field

---All ids in the engine are represented as hashes, so a string needs to be hashed
---before it can be compared with an id.
---@param s string string to hash
---@return hash hash a hashed string
function hash(s) end

---Returns a hexadecimal representation of a hash value.
---The returned string is always padded with leading zeros.
---@param h hash hash value to get hex string for
---@return string hex hex representation of the hash
function hash_to_hex(h) end

---Pretty printing of Lua values. This function prints Lua values
---in a manner similar to +print()+, but will also recurse into tables
---and pretty print them. There is a limit to how deep the function
---will recurse.
---@param ... any value to print
function pprint(...) end