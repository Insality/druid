--[[
  Generated with github.com/astrochili/defold-annotations
  Defold 1.8.0

  Label API documentation
--]]

---@diagnostic disable: lowercase-global
---@diagnostic disable: missing-return
---@diagnostic disable: duplicate-doc-param
---@diagnostic disable: duplicate-set-field

---@class defold_api.label
label = {}

---Gets the text from a label component
---@param url string|hash|url the label to get the text from
---@return string metrics the label text
function label.get_text(url) end

---Sets the text of a label component
--- This method uses the message passing that means the value will be set after dispatch messages step.
---More information is available in the Application Lifecycle manual.
---@param url string|hash|url the label that should have a constant set
---@param text string the text
function label.set_text(url, text) end

return label