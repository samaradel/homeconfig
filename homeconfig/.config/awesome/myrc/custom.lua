local awful = require("awful")
local client = require("client")
local naughty = require("naughty")
local tag = require("tag")
local shifty = require("shifty")
local screen = require("screen")
local ipairs = ipairs

module("myrc.custom")

browser = "firefox"
terminal = "urxvtc"
autostart = true
modkey = "Mod4"
modkey2 = "Mod1"

shiftytags = {
    ["1:term"] = { position = 1, exclusive = true, max_clients = 4, spawn = terminal, layout = awful.layout.suit.fair},
    ["2:im"]  = { position = 2, exclusive = true, spawn = "pidgin", layout = awful.layout.suit.floating, },
    ["3:web"]  = { position = 3, exclusive = true, spawn = browser, screen = 2, layout = awful.layout.suit.max, icon="/usr/share/icons/Tango/16x16/apps/web-browser.png"},
    ["4:mail"]  = { position = 4, exclusive = true, spawn = "thunderbird", layout = awful.layout.suit.max, screen = 1},
    ["5:fs"]  = { position = 5, exclusive = true, spawn = "thunar", layout = awful.layout.suit.floating, },
    ["6:edit"]  = { position = 6, exclusive = true, spawn = "geany", screen = 1, nopopup = true, layout = awful.layout.suit.max, },
    ["7:media"]  = { position = 7, exclusive = true, screen = 2, nopopup = true, layout = awful.layout.suit.floating, },
}
clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ "Mod1" }, 1, awful.mouse.client.move),
    awful.button({ "Mod1" }, 3, awful.mouse.client.resize))

shiftyapps = {
         { match = { "Chrome", "Chromium", "Midori", "Navigator", "Namoroka","Firefox"} , tag = "3:web" } ,
         { match = { "Thunderbird"} , tag = "4:mail" } ,
         { match = { "Pidgin", "Skype"} , tag = "2:im" } ,
         { match = { "xterm", "urxvt", "Terminator"} , honorsizehints = false, slave = true, tag = "1:term" } ,
         { match = { "Thunar", "pcmanfm", "xarchiver" }, tag = "5:fs" } ,
         { match = { "Geany" }, tag = "6:edit" } ,
         { match = { "gvim" }, tag = "6:edit" } ,
         { match = { "Eclipse" }, tag = "6:edit" } ,
         { match = { "MPlayer", "ario", "Audacious" }, tag = "7:media" } ,
         { match = { "" }, buttons =  clientbuttons },
}

shiftydefaults = {
  layout = awful.layout.suit.floating,
  ncol = 1,
  mwfact = 0.60,
  floatBars=true,
  run = function(tag) naughty.notify({ text = tag.name }) end
}

function pushincorner()
    local sel = client.focus
    local geometry = sel:geometry()
    geometry['x'] = 0
    geometry['y'] = 0
    sel:geometry(geometry)
end

function tagtoscr(scr, t)
  -- break if called with an invalid screen number
  
  if not scr or scr < 1 or scr > screen.count() then return end
  -- tag to move
  local otag = t or awful.tag.selected() 
  
  -- unselect active tag on other screen
  local remotetag = awful.tag.selected(scr)
  
  if remotetag then
    remotetag.selected = false
  end
  -- set screen and then reset tag to order properly
  
  otag.screen = scr
  if #otag:clients() > 0 then
    for _ , c in ipairs(otag:clients()) do
      if not c.sticky then
        c.screen = scr
        c:tags( { otag } )
      else
        awful.client.toggletag(otag,c)
      end
    end
  end
  return otag
end

function switchtagtonextscreen()
  local scr = client.focus.screen or mouse.screen
  scr = scr + 1
  if scr > screen.count() then
      scr = 1
  end
  tagtoscr(scr)
  
end

keybindings = awful.util.table.join(
    awful.key({ modkey2, "Control" }, "c", function () awful.util.spawn(terminal) end),
    awful.key({ }, "Print", function () awful.util.spawn("/home/Jo/mygit/scripts/bin/caputereimg.sh /home/grimpy/Pictures/SS") end),
    awful.key({ modkey,           }, "F2", function () awful.util.spawn("/home/Jo/mygit/scripts/bin/musiccontrol toggle") end),
    awful.key({ modkey,           }, "F3", function () awful.util.spawn("/home/Jo/mygit/scripts/bin/musiccontrol prev") end),
    awful.key({ modkey,           }, "F4", function () awful.util.spawn("/home/Jo/mygit/scripts/bin/musiccontrol next") end),
    awful.key({ modkey,           }, "F7", function () awful.util.spawn("/home/Jo/mygit/scripts/bin/single.sh") end),
    awful.key({ modkey,           }, "F8", function () awful.util.spawn("/home/Jo/mygit/scripts/bin/dual.sh") end),
    awful.key({ modkey,           }, "e", function () awful.util.spawn("thunar") end),
    awful.key({ modkey, }, "l", function () awful.util.spawn("alock -auth pam -bg blank") end),
    awful.key({ modkey2, "Control" }, "s", function () awful.util.spawn("skype") end),
    awful.key({ modkey2, "Control" }, "m", function () awful.util.spawn("pidgin") end),
    awful.key({ modkey, 'Shift'   }, "o", switchtagtonextscreen),
    awful.key({ modkey,    }, "c", pushincorner),
    awful.key({ modkey2, "Control" }, "k", function () awful.util.spawn("geany") end))

