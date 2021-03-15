---@class Application
---@field menuGlyphs table<number,string>
local Application

---@param pid integer
---@return ApplicationInstance|nil
function Application.applicationForPID(pid)end

---@param bundleID string
---@return ApplicationInstance[]
function Application.applicationsForBundleID(bundleID)end

---@param uti string
---@return string|nil
function Application.defaultAppForUTI(uti)end

---@param state boolean|nil
---@return boolean
function Application.enableSpotlightForNameSearches(state)end

---@return ApplicationInstance
function Application.frontmostApplication()end

---@param bundleID string
---@return table|nil
function Application.infoForBundleID(bundleID)end

---@param bundlePath string
---@return table|nil
function Application.infoForBundlePath(bundlePath)end

---@param name string
---@return boolean
function Application.launchOrFocus(name)end

---@param bundleID string
---@return boolean
function Application.launchOrFocusByBundleID(bundleID)end

---@param bundleID string
---@return string|nil
function Application.nameForBundleID(bundleID)end

---@param bundleID string
---@return string|nil
function Application.pathForBundleID(bundleID)end

---@return ApplicationInstance[]
function Application.runningApplications()end

---@param hint number|string
---@return ApplicationInstance[]|nil
function Application.find(hint)end

---@param hint number|string
---@return ApplicationInstance|nil
function Application.get(hint)end

---@param app string
---@param wait number|nil
---@param waitForFirstWindow boolean|nil
---@return ApplicationInstance|nil
function Application.open(app, wait, waitForFirstWindow)end
