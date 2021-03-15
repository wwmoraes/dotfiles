--- interact with OS X filesystem volumes
---
--- This is distinct from `hs.fs`, which deals with UNIX filesystem operations,
--- while `hs.fs.volume` interacts with the higher level OS X concept of volumes
---@class Volume
--- volume was mounted
---@field didMount VolumeEventType
--- volume changed either its name or mountpoint (or more likely, both)
---@field didRename VolumeEventType
--- volume was unmounted
---@field didUnmount VolumeEventType
--- volume is about to be unmounted
---@field willUnmount VolumeEventType
local Volume

--- creates a watcher object for volume events
---
---@param fn VolumeWatcherFn @function that will be called when volume events happen
---@return VolumeWatcher @an `hs.fs.volume` object
function Volume.new(fn)end

--- returns a table of information about disk volumes attached to the system
---
---@param showHidden boolean @whether to show hidden volumes or not. (default: `false`)
---@return table<string,VolumeInfo> @information about disk volumes attached to the system, where the keys are the volume paths
function Volume.allVolumes(showHidden)end

--- unmounts and ejects a volume
---
---@param path string @an absolute path to the volume you wish to eject
---@return boolean,string|nil @`true` and `nil` if ejected; `false` and error message otherwise
function Volume.eject(path)end
