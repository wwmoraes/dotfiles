---Spoons repository settings
---@class SpoonInstallRepo
---Spoons repository URL
---@field url string
---Spoons repository description
---@field desc string
---Spoons repository branch
---@field branch string

---@param spoon Spoon
---@return nil
---@alias SpoonInstallCallback "function(spoon:Spoon):nil"

---Install and manage Spoons and Spoon repositories
---@class SpoonInstall : Spoon
---@field protected logger LoggerInstance
---Spoon repositories to fetch metadata and spoons from
---@field public repos table<string,SpoonInstallRepo>
---Synchronous repo update and package install (blocks execution if enabled)
---@field public use_syncinstall boolean
local SpoonInstall

---@class SpoonInstallAndUseArgs
---@field repo string
---@field config SpoonInstall
---@field hotkeys HotkeyMapping
---@field fn SpoonInstallCallback
---@field loglevel LogLevel
---@field start boolean
---@field disable boolean

---Declaratively install, load and configure a Spoon
---@param name string
---@param arg SpoonInstallAndUseArgs
---@return nil
function SpoonInstall:andUse(name,arg)end
