--- Core Hammerspoon functionality
---@class Hammerspoon
---
--- configuration directory (typically `~/.hammerspoon`)
---@field configdir string
--- full path to the `docs.json` file inside Hammerspoon's app bundle. This
--- contains the full Hammerspoon API documentation and can be accessed in the
--- Console using `help("someAPI")`. It can also be loaded and processed by the
--- `hs.doc` extension
---@field docstrings_json_file string
--- read-only information about the current Hammerspoon instance
---@field processInfo ProcessInfo
--- an optional function that will be called when the Accessibility State is
--- changed
---
--- Notes:
---
--- * The function will not receive any arguments when called. To check what the
--- accessibility state has been changed to, you should call
--- `hs.accessibilityState` from within your function
---@field accessibilityStateCallback AccessibilityStateCallback
--- Gathers tab completion options for the Console window
---
--- Notes:
---
--- * Hammerspoon provides a default implementation of this function, which can
--- complete against the global Lua namespace, the `hs` (i.e. extension)
--- namespace, and object metatables. You can assign a new function to the
--- variable to replace it with your own variant.
---@field completionsForInputString CompletionsCallback
---@field dockIconClickCallback any
---@field fileDroppedToDockIconCallback any
---@field shutdownCallback any
---@field textDroppedToDockIconCallback any
---
---@field alert any
---@field appfinder any
---@field applescript any
---@field application Application
---@field audiodevice any
---@field axuielement any
---@field base64 any
---@field battery any
---@field bonjour any
---@field brightness any
---@field caffeinate Caffeinate
---@field canvas any
---@field chooser any
---@field console any
---@field crash any
---@field deezer any
---@field dialog any
---@field distributednotifications any
---@field doc any
---@field dockicon any
---@field drawing any
---@field eventtap EventTap
---@field expose any
---@field fnutils any
---@field fs Fs
---@field geometry Geometry
---@field grid any
---@field hash any
---@field hid any
---@field hints any
---@field host any
---@field hotkey Hotkey
---@field http any
---@field httpserver any
---@field image Image
---@field inspect Inspect
---@field ipc any
---@field itunes any
---@field javascript any
---@field json any
---@field keycodes any
---@field layout any
---@field location any
---@field logger Logger
---@field math any
---@field menubar any
---@field messages any
---@field midi any
---@field milight any
---@field mjomatic any
---@field mouse any
---@field network any
---@field noises any
---@field notify any
---@field osascript any
---@field pasteboard any
---@field pathwatcher Pathwatcher
---@field plist any
---@field redshift any
---@field screen Screen
---@field serial any
---@field settings any
---@field sharing any
---@field socket any
---@field sound any
---@field spaces any
---@field speech any
---@field spoons Spoons
---@field spotify any
---@field spotlight any
---@field sqlite3 any
---@field streamdeck any
---@field styledtext any
---@field tabs any
---@field tangent any
---@field task Task
---@field timer Timer
---@field uielement any
---@field urlevent any
---@field usb any
---@field utf8 any
---@field vox any
---@field watchable any
---@field websocket any
---@field webview any
---@field wifi any
---@field window Window
local Hammerspoon

function Hammerspoon.accessibilityState()end
function Hammerspoon.allowAppleScript()end
function Hammerspoon.autoLaunch()end
function Hammerspoon.automaticallyCheckForUpdates()end
function Hammerspoon.cameraState()end
function Hammerspoon.canCheckForUpdates()end
function Hammerspoon.checkForUpdates()end
function Hammerspoon.cleanUTF8forConsole()end
function Hammerspoon.closeConsole()end
function Hammerspoon.closePreferences()end
function Hammerspoon.consoleOnTop()end
function Hammerspoon.coroutineApplicationYield()end
function Hammerspoon.dockIcon()end
function Hammerspoon.execute()end
function Hammerspoon.focus()end
function Hammerspoon.getObjectMetatable()end
function Hammerspoon.help()end
function Hammerspoon.hsdocs()end
function Hammerspoon.loadSpoon()end
function Hammerspoon.menuIcon()end
function Hammerspoon.microphoneState()end
function Hammerspoon.open()end
function Hammerspoon.openAbout()end
function Hammerspoon.openConsole()end
function Hammerspoon.openConsoleOnDockClick()end
function Hammerspoon.openPreferences()end
function Hammerspoon.preferencesDarkMode()end
function Hammerspoon.printf()end
function Hammerspoon.rawprint()end
function Hammerspoon.relaunch()end
function Hammerspoon.reload()end
function Hammerspoon.screenRecordingState()end
function Hammerspoon.showError()end
function Hammerspoon.toggleConsole()end
function Hammerspoon.updateAvailable()end
function Hammerspoon.uploadCrashData()end

hs = Hammerspoon
