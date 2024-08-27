--[[
  Generated with github.com/astrochili/defold-annotations
  Defold 1.8.0

  Collection proxy API documentation

  Messages for controlling and interacting with collection proxies
  which are used to dynamically load collections into the runtime.
--]]

---@diagnostic disable: lowercase-global
---@diagnostic disable: missing-return
---@diagnostic disable: duplicate-doc-param
---@diagnostic disable: duplicate-set-field

---@class defold_api.collectionproxy
collectionproxy = {}

---return an indexed table of resources for a collection proxy. Each
---entry is a hexadecimal string that represents the data of the specific
---resource. This representation corresponds with the filename for each
---individual resource that is exported when you bundle an application with
---LiveUpdate functionality.
---@param collectionproxy url the collectionproxy to check for resources.
---@return string[] resources the resources
function collectionproxy.get_resources(collectionproxy) end

---return an array of missing resources for a collection proxy. Each
---entry is a hexadecimal string that represents the data of the specific
---resource. This representation corresponds with the filename for each
---individual resource that is exported when you bundle an application with
---LiveUpdate functionality. It should be considered good practise to always
---check whether or not there are any missing resources in a collection proxy
---before attempting to load the collection proxy.
---@param collectionproxy url the collectionproxy to check for missing
---resources.
---@return string[] resources the missing resources
function collectionproxy.missing_resources(collectionproxy) end

return collectionproxy