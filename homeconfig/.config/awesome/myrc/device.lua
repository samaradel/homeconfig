local os = os
local pcall = pcall
local dofile = dofile
local pairs = pairs
local awful = require('awful')

module("myrc.device")

function trim(s)
      -- from PiL2 20.4
  return (s:gsub("^%s*(.-)%s*$", "%1"))
end

local hostname = trim(awful.util.pread("hostname -s"))
local configdir = awful.util.getdir("config")
devicepath = configdir .. "/devices/defaults.lua" 
success, device = pcall(function() return dofile(devicepath) end)

-- loa device specific
local devicepath = configdir .. "/devices/" .. hostname .. ".lua"
if awful.util.file_readable(devicepath) then
    local success, mydevice = pcall(function() return dofile(devicepath) end)
    for k,v in pairs(mydevice) do device[k] = v end

end
return device
